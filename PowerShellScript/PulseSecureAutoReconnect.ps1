<#
    .SYNOPSIS
        Auto reconnect pulse secure when prompt appear.
    .IExpress Install Command:
        PowerShell.exe -NoProfile -WindowStyle Minimized -STA -ExecutionPolicy Bypass -File PulseSecureAutoReconnect.ps1
    .INSTALLATION:
        Copy PulseSecureAutoReconnect.EXE to
        C:\Users\%UserName%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
#>

$version = "0.9.5";
$appTitle = "[Pulse Secure] Auto Reconnect";
$Host.UI.RawUI.WindowTitle = "$appTitle | Version: $version"

Write-Host @"
========================================================================
#                                                                      #
# $($Host.UI.RawUI.WindowTitle)
# This application will help you auto reconnect Pulse Secure VPN
"@

Add-Type -AssemblyName System.Web
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName Microsoft.VisualBasic

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

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
using System.Text;

public static class Win32Api
{
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern IntPtr SendMessage(IntPtr hWnd, uint Msg, IntPtr wParam, string lParam);
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern IntPtr PostMessage(IntPtr hWnd, uint Msg, IntPtr wParam, string lParam);

    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll")]
    public static extern int ShowWindow(IntPtr hwnd, int nCmdShow);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern IntPtr FindWindowEx(IntPtr hwndParent, IntPtr hwndChildAfter, string lpszClass = null, string lpszWindow = null);

    [DllImport("User32.dll")]
    public static extern long GetClassName(IntPtr hWnd, StringBuilder lpClassName, long nMaxCount);
    [DllImport("User32.dll")]
    public static extern IntPtr GetWindow(IntPtr hWnd, int uCmd);
    [DllImport("User32.dll")]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);
    [DllImport("User32.dll")]
    public static extern int SetWindowText(IntPtr hWnd, string lpString);
    [DllImport("user32.dll")]
    public static extern IntPtr GetWindowLong(IntPtr hWnd, int nIndex);
}
"@

function GetWindowByClassAndTitle
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $windowClassName,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $windowTitles
    )
    
    process
    {
        $classText = (New-Object -TypeName 'System.Text.StringBuilder' 50);
        $windowText = (New-Object -TypeName 'System.Text.StringBuilder' 50);
        $hWnd = [Win32Api]::GetWindow([Win32Api]::GetForegroundWindow(), 0); # GW_HWNDFIRST
        while ($hWnd -ne [IntPtr]::Zero)
        {
            [void][Win32Api]::GetClassName($hWnd, $classText, 50);
            if ($classText.ToString() -eq $windowClassName)
            {
                [void][Win32Api]::GetWindowText($hWnd, $windowText, 50);
                $_wndTxt = $windowText.ToString();
                $found = $false;
                foreach ($windowTitle in $windowTitles)
                {
                    # Write-Host $_windowTitle
                    if ($_wndTxt.Contains($windowTitle) -or $windowTitle.Contains($_wndTxt))
                    {
                        # Echo $_windowTitle
                        $found = $true;
                        break;
                    }
                }
                if ($found)
                {
                    break;
                }
            }

            $hWnd = [Win32Api]::GetWindow($hWnd, 2); # GW_HWNDNEXT
        }

        return $hWnd;
    }
}

function GetChildHwnd
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.IntPtr]
        $hWndParent,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $windowClassNames,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        [AllowEmptyString()]
        $windowTitles,

        [Parameter(Mandatory = $false)]
        [System.IntPtr]
        $windowStyle = [IntPtr]::Zero,
        
        [Parameter(Mandatory = $false)]
        [Bool]
        $isExact = $false
    )
    
    process
    {
        $classText = (New-Object -TypeName 'System.Text.StringBuilder' 50);
        $windowText = (New-Object -TypeName 'System.Text.StringBuilder' 50);
        $hWnd = [IntPtr]::Zero;

        $foundWndClass = $false;
        foreach ($windowClassName in $windowClassNames)
        {
            $hWnd = [Win32Api]::FindWindowEx($hWndParent, 0);

            while ($hWnd -ne [IntPtr]::Zero)
            {
                [void][Win32Api]::GetClassName($hWnd, $classText, 50);
            
                if ($classText.ToString().Contains($windowClassName))
                {
                    $_ = [Win32Api]::GetWindowText($hWnd, $windowText, 50);
                    $_wndTxt = $windowText.ToString();
                    $found = $false;
                    foreach ($windowTitle in $windowTitles)
                    {
                        if ($isExact)
                        {
                            # Write-Host FFF $windowClassName $windowTitle TXT $_wndTxt
                            if ($_wndTxt -eq $windowTitle)
                            {
                                if ($windowStyle -eq [IntPtr]::Zero)
                                {
                                    $foundWndClass = $true;
                                    $found = $true;
                                    break;
                                }
                                else
                                {
                                    $_wndStyle = [Win32Api]::GetWindowLong($hWnd, -16);
                                    if ($_wndStyle -eq $windowStyle)
                                    {
                                        $foundWndClass = $true;
                                        $found = $true;
                                        break;
                                    }
                                }
                            }
                        }
                        elseif ($_wndTxt.Contains($windowTitle) -or $windowTitle.Contains($_wndTxt))
                        {
                            if ($windowStyle -eq [IntPtr]::Zero)
                            {
                                $foundWndClass = $true;
                                $found = $true;
                                break;
                            }
                            else
                            {
                                $_wndStyle = [Win32Api]::GetWindowLong($hWnd, -16);
                                if ($_wndStyle -eq $windowStyle)
                                {
                                    $foundWndClass = $true;
                                    $found = $true;
                                    break;
                                }
                            }
                        }
                    }
                    if ($found)
                    {
                        break;
                    }
                }
            
                # Find Next
                $hWnd = [Win32Api]::FindWindowEx($hWndParent, $hWnd);
            }
            if ($foundWndClass)
            {
                break;
            }
        }

        return $hWnd;
    }
}

if (-not([System.Management.Automation.PSTypeName]('Win32Api')).Type)
{
    Write-Warning "[x] Script is corrupted. Not found Win32Api type.";
    Write-Warning "[x] Please check script or contact the Author 's team";
    exit;
}

$otpAuthFilePath = "$env:USERPROFILE/PulseSecureOtpAuth.txt"

function InputOtpAuthText
{
    if (![System.IO.File]::Exists($otpAuthFilePath))
    {
        Write-Host "Creating $otpAuthFilePath";
        Echo '' | Out-File -FilePath $otpAuthFilePath -Force -NoNewline;
    }

    Write-Host "[*] Please input your OtpAuth RawText in prompted window!"
    $otpAuthText = [Microsoft.VisualBasic.Interaction]::InputBox(
        "Please enter OtpAuth raw text."+[char](13)+[char](10)+[char](13)+[char](10)+"You can get it from decoded QR-Code image",
        "$appTitle | OtpAuth",
        [IO.File]::ReadAllText($otpAuthFilePath)
    ) | foreach { $_.trim() }
    if ([System.String]::IsNullOrEmpty($otpAuthText -as [string]))
    {
        Write-Warning "[x] Input form was closed by user!";
        exit;
    }

    Echo $otpAuthText | Out-File -FilePath $otpAuthFilePath -Force -NoNewline;
    Write-Host "[+] Saved AuthRawText!";
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
        Write-Warning "[x] Can not parse OtpUri";
        return $null;
    }

    $query = $url_parse.Query;
    if (!$query)
    {
        Write-Warning "[x] Can not get Query from input Uri";
        return $null;
    }

    $queries = [System.Web.HttpUtility]::ParseQueryString($query);
    if (!$queries)
    {
        Write-Warning "[x] Can not get Array from Query";
        return $null;
    }

    return $queries['secret'];
}

# Check and set secret
$sharedSecret = $null;
while (!$sharedSecret)
{
    Try
    {
        $sharedSecret = GetSecret;
        # Echo "Secret: $sharedSecret"
        If (!$sharedSecret)
        {
            InputOtpAuthText;
        }
    }
    Catch
    {
        Write-Warning $_.Exception.GetType().FullName;
        Write-Warning $_.Exception.Message;
        break;
    }
}

if (-not($sharedSecret))
{
    Write-Warning "[x] Not found secret"
    exit;
}

Write-Host "# Found Secret. Application is started successfully!"
Write-Host "# You can click [Minimize] to hide this window then back to your work now."
Write-Host @"
#                                                                      #
========================================================================

"@
Write-Warning "DO NOT CLOSE THIS WINDOW."

# [void][System.Windows.Forms.Messagebox]::Show("Application run successfully!", $appTitle, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Asterisk)

# Processing
while($true)
{
    Try
    {
        $curHWnd = [Win32Api]::GetForegroundWindow();

        # Get window Handle
        $pulseHwnd = GetWindowByClassAndTitle -windowClassName "JamShadowClass" -windowTitle "Connect to: ", ": ";
        If (!$pulseHwnd -or ($pulseHwnd -eq 0) -or ($pulseHwnd -eq [IntPtr]::Zero))
        {
            Sleep -Seconds 5
            continue;
        }

        Write-Host "[+] Pulse Secure hWnd: 0x$($pulseHwnd.ToString("x8"))=$pulseHwnd"

        # Get Button
        $btnHwnd = GetChildHwnd -hWndParent $pulseHwnd -windowClassName "JAM_BitmapButton" -windowTitles "(&C)", "&Connect";

        if (!$btnHwnd -or ($btnHwnd -eq 0) -or ($btnHwnd -eq [IntPtr]::Zero))
        {
            $btnHwnd = GetChildHwnd -hWndParent $pulseHwnd -windowClassName "JAM_BitmapButton" -windowTitles "Retry", "Extend";
            if (!$btnHwnd -or ($btnHwnd -eq 0) -or ($btnHwnd -eq [IntPtr]::Zero))
            {
                Write-Host "[+] Pulse Secure is submitting or not found Submit button"
                Sleep -Seconds 2
                continue;
            }
            [void][Win32Api]::SendMessage($btnHwnd, 0x00F5, 0, 0); # BM_CLICK
            Sleep -Seconds 2
            continue;
        }

        Write-Host "[+] Btn hWnd: 0x$($btnHwnd.ToString("x8"))=$btnHwnd"

        $twoFactorInput = GetChildHwnd -hWndParent $pulseHwnd -windowClassNames "ATL:" -windowTitles "" -windowStyle 0x500100A0 -isExact $true;

        if ($twoFactorInput -and ($twoFactorInput -ne 0) -and ($twoFactorInput -ne [IntPtr]::Zero))
        {
            Write-Host "[+] Input hWnd: 0x$($twoFactorInput.ToString("x8"))=$twoFactorInput"
            $password = Get-TimeBasedOneTimePassword -SharedSecret $sharedSecret
            Write-Host "[+] Now password: $password"
    
            [void][Win32Api]::ShowWindow($pulseHwnd, 9);
            [void][Win32Api]::SetForegroundWindow($pulseHwnd);
            if ([Win32Api]::GetForegroundWindow() -eq $pulseHwnd)
            {
                [void][System.Windows.Forms.SendKeys]::SendWait($password);
                [void][Win32Api]::SendMessage($btnHwnd, 0x00F5, 0, 0); # BM_CLICK
            }
            else
            {
                Write-Warning "[x] Can not SetForegroundWindow($pulseHwnd)"
                Sleep -Seconds 1
                continue;
            }
        }
        else
        {
            $unameInput = GetChildHwnd -hWndParent $pulseHwnd -windowClassNames "ATL:" -windowTitles "" -windowStyle 0x58010080 -isExact $false;
            if ($unameInput -eq [IntPtr]::Zero)
            {
                [void][Win32Api]::SendMessage($btnHwnd, 0x00F5, 0, 0); # BM_CLICK
            }
        }

        [void][Win32Api]::SetForegroundWindow($curHWnd);
    }
    Catch
    {
        Write-Warning $_.Exception.GetType().FullName
        Write-Warning $_.Exception.Message
    }

    Sleep -Seconds 2
}
