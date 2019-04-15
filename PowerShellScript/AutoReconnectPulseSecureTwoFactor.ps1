Echo "Starting..."

Add-Type -AssemblyName System.Web

function Convert-Base32ToByte
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Base32
    )

    # RFC 4648 Base32 alphabet
    $rfc4648 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'

    $bits = ''

    # Convert each Base32 character to the binary value between starting at
    # 00000 for A and ending with 11111 for 7.
    foreach ($char in $Base32.ToUpper().ToCharArray())
    {
        $bits += [Convert]::ToString($rfc4648.IndexOf($char), 2).PadLeft(5, '0')
    }

    # Convert 8 bit chunks to bytes, ignore the last bits.
    for ($i = 0; $i -le ($bits.Length - 8); $i += 8)
    {
        [Byte] [Convert]::ToInt32($bits.Substring($i, 8), 2)
    }
}
<#
    .SYNOPSIS
        Generate a Time-Base One-Time Password based on RFC 6238.
    .DESCRIPTION
        This command uses the reference implementation of RFC 6238 to calculate
        a Time-Base One-Time Password. It bases on the HMAC SHA-1 hash function
        to generate a shot living One-Time Password.
    .INPUTS
        None.
    .OUTPUTS
        System.String. The one time password.
    .EXAMPLE
        PS C:\> Get-TimeBasedOneTimePassword -SharedSecret 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        Get the Time-Based One-Time Password at the moment.
    .NOTES
        Author     : Claudio Spizzi
        License    : MIT License
    .LINK
        https://github.com/claudiospizzi/SecurityFever
        https://tools.ietf.org/html/rfc6238
#>
function Get-TimeBasedOneTimePassword
{
    [CmdletBinding()]
    [Alias('Get-TOTP')]
    param
    (
        # Base 32 formatted shared secret (RFC 4648).
        [Parameter(Mandatory = $true)]
        [System.String]
        $SharedSecret,

        # The date and time for the target calculation, default is now (UTC).
        [Parameter(Mandatory = $false)]
        [System.DateTime]
        $Timestamp = (Get-Date).ToUniversalTime(),

        # Token length of the one-time password, default is 6 characters.
        [Parameter(Mandatory = $false)]
        [System.Int32]
        $Length = 6,

        # The hash method to calculate the TOTP, default is HMAC SHA-1.
        [Parameter(Mandatory = $false)]
        [System.Security.Cryptography.KeyedHashAlgorithm]
        $KeyedHashAlgorithm = (New-Object -TypeName 'System.Security.Cryptography.HMACSHA1'),

        # Baseline time to start counting the steps (T0), default is Unix epoch.
        [Parameter(Mandatory = $false)]
        [System.DateTime]
        $Baseline = '1970-01-01 00:00:00',

        # Interval for the steps in seconds (TI), default is 30 seconds.
        [Parameter(Mandatory = $false)]
        [System.Int32]
        $Interval = 30
    )

    # Generate the number of intervals between T0 and the timestamp (now) and
    # convert it to a byte array with the help of Int64 and the bit converter.
    $numberOfSeconds   = ($Timestamp - $Baseline).TotalSeconds
    $numberOfIntervals = [Convert]::ToInt64([Math]::Floor($numberOfSeconds / $Interval))
    $byteArrayInterval = [System.BitConverter]::GetBytes($numberOfIntervals)
    [Array]::Reverse($byteArrayInterval)

    # Use the shared secret as a key to convert the number of intervals to a
    # hash value.
    $KeyedHashAlgorithm.Key = Convert-Base32ToByte -Base32 $SharedSecret
    $hash = $KeyedHashAlgorithm.ComputeHash($byteArrayInterval)

    # Calculate offset, binary and otp according to RFC 6238 page 13.
    $offset = $hash[($hash.Length-1)] -band 0xf
    $binary = (($hash[$offset + 0] -band '0x7f') -shl 24) -bor
              (($hash[$offset + 1] -band '0xff') -shl 16) -bor
              (($hash[$offset + 2] -band '0xff') -shl 8) -bor
              (($hash[$offset + 3] -band '0xff'))
    $otpInt = $binary % ([Math]::Pow(10, $Length))
    $otpStr = $otpInt.ToString().PadLeft($Length, '0')

    return $otpStr
}

Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms

function Send-Keys
{
    [CmdletBinding()]
    [Alias("sdky")]
    Param
    (
        # https://msdn.microsoft.com/ja-jp/library/cc364423.aspx
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]
        $KeyStroke,

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProcessName,

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
        [int]
        $Wait = 0
    )

    Process
    {
        $Process = ps | ? {$_.Name -eq $ProcessName} | sort -Property CPU -Descending | select -First 1
        Write-Verbose $Process", KeyStroke = "$KeyStroke", Wait = "$Wait" ms."
        sleep -Milliseconds $Wait
        if ($Process -ne $null)
        {
            [Microsoft.VisualBasic.Interaction]::AppActivate($Process.ID)
        }
        [System.Windows.Forms.SendKeys]::SendWait($KeyStroke)
    }
}

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
using System.Text;

public static class Win32Api
{
    static int GW_HWNDFIRST = 0;
    static int GW_HWNDNEXT = 2;

    [DllImport("user32.dll")]
    public static extern bool PostMessage(IntPtr hWnd, uint Msg, int wParam, int lParam);
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern uint SendMessage(IntPtr hWnd, int Msg, int wParam, int lParam);

    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);

    [DllImport("User32.dll")]
    public static extern long GetClassName(IntPtr hWnd, StringBuilder lpClassName, long nMaxCount);
    [DllImport("User32.dll")]
    public static extern IntPtr GetWindow(IntPtr hWnd, int uCmd);
    [DllImport("User32.dll")]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

    public static IntPtr GetWindowByClassAndTitle(string windowClassName, string windowTitle)
    {
        StringBuilder classText = new StringBuilder(windowClassName.Length + 1);
        StringBuilder windowText = new StringBuilder(windowTitle.Length + 1);
        IntPtr hWnd = GetWindow(GetForegroundWindow(), GW_HWNDFIRST);

        while (hWnd != IntPtr.Zero)
        {
            GetClassName(hWnd, classText, windowClassName.Length * 2);
            if (classText.ToString() == windowClassName)
            {
                GetWindowText(hWnd, windowText, windowTitle.Length * 2);
                string _wndTxt = windowText.ToString();
                if (_wndTxt.Contains(windowTitle) || windowTitle.Contains(_wndTxt))
                {
                    // Console.WriteLine("Found hWnd");
                    break;
                }
            }

            hWnd = GetWindow(hWnd, GW_HWNDNEXT);
        }

        return hWnd;
    }
}
"@

$otpAuthFilePath = "$env:USERPROFILE/PulseSecureOtpAuth.txt"

function InputOtpAuthText
{
    if (![System.IO.File]::Exists($otpAuthFilePath))
    {
        Write-Host "Creating $otpAuthFilePath"
        Echo '' | Out-File -FilePath $otpAuthFilePath -Force -NoNewline
    }

    Write-Host "Please input your OtpAuth RawText in prompted window!"
    $otpAuthText = [Microsoft.VisualBasic.Interaction]::InputBox("Enter OtpAuth RawText:", "OtpAuth", [IO.File]::ReadAllText($otpAuthFilePath)) | foreach { $_.trim() }
    if ([String]::IsNullOrEmpty($otpAuthText))
    {
        exit
    }

    Echo $otpAuthText | Out-File -FilePath $otpAuthFilePath -Force -NoNewline
    Write-Host "Saved AuthRawText!"
}

function GetSecret
{
    $otpAuthText = $null

    if (![System.IO.File]::Exists($otpAuthFilePath))
    {
        $otpAuthText = InputOtpAuthText;
    }
    else
    {
        $otpAuthText = [IO.File]::ReadAllText($otpAuthFilePath);
    }

    $url_parse = [System.Uri]($otpAuthText);

    if (!$url_parse)
    {
        Write-Warning "Can not parse OtpUri";
        return $null;
    }

    $query = $url_parse.Query;
    if (!$query)
    {
        Write-Warning "Can not get Query from input Uri";
        return $null;
    }

    $queries = [System.Web.HttpUtility]::ParseQueryString($query);
    if (!$queries)
    {
        Write-Warning "Can not get Array from Query";
        return $null;
    }

    return $queries['secret'];
}

$sharedSecret = $null;
while (!$sharedSecret)
{
    # try
    #{
        $sharedSecret = GetSecret;
        # Echo "Secret: $sharedSecret"
        If (!$sharedSecret)
        {
            InputOtpAuthText;
        }
    #}
    # catch
    #{
        # Write-Warning $_
    #}
}

Echo "Found Secret. Application is started successfully!"

# Processing
while($true)
{
    # Get window Handle
    $pulseHwnd = [Win32Api]::GetWindowByClassAndTitle("JamShadowClass", "Connect to: ");
    If ($pulseHwnd -eq 0)
    {
        $pulseHwnd = [Win32Api]::GetWindowByClassAndTitle("JamShadowClass", "接続先:");
        If ($pulseHwnd -eq 0)
        {
            Sleep -Seconds 5
            continue;
        }
    }

    Echo "Pulse Secure hWnd: $pulseHwnd"

    $password = Get-TimeBasedOneTimePassword -SharedSecret $sharedSecret
    Echo "Now password: $password"
    
    [Win32Api]::SetForegroundWindow($pulseHwnd);
    [System.Windows.Forms.SendKeys]::SendWait($password);
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}");

    sleep -Milliseconds 2000
}
