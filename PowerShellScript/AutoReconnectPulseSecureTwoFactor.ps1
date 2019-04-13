# https://qiita.com/nimzo6689/items/488467dbe0c4e5645745

Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms

# https://qiita.com/y-takano/items/cb752ad6a10e550ec92f

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

    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

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
            GetClassName(hWnd, classText, windowClassName.Length + 1);
            if (classText.ToString() == windowClassName)
            {
                GetWindowText(hWnd, windowText, windowTitle.Length + 1);
                if (windowText.ToString().Contains(windowTitle))
                {
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

if (![System.IO.File]::Exists($otpAuthFilePath))
{
    Echo '' | Out-File -FilePath $otpAuthFilePath -Force -NoNewline
}

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$otpAuthText = [Microsoft.VisualBasic.Interaction]::InputBox("Enter OtpAuth RawText:", "OtpAuth", [IO.File]::ReadAllText($otpAuthFilePath))
if ([String]::IsNullOrEmpty($otpAuthText))
{
    exit
}
Echo $otpAuthText | Out-File -FilePath $otpAuthFilePath -Force -NoNewline

# Processing
while($true)
{
    # Get window Handle
    $pulseHwnd = [Win32Api]::GetWindowByClassAndTitle("JamShadowClass", "Connect to:");
    If ($pulseHwnd -eq 0)
    {
        # Start-Process -FilePath Chrome -ArgumentList chrome-extension://bhghoamapcdpbohphigoooaddinpkbai/view/popup.html
        Sleep -Seconds 5
        continue;
    }

    Echo "Pulse Secure hWnd: $pulseHwnd"
    
    Start-Process -FilePath Chrome -ArgumentList chrome-extension://bhghoamapcdpbohphigoooaddinpkbai/view/popup.html

    #[Win32Api]::PostMessage($pulseHwnd, 0x0100, 13, 0);
    sleep -Milliseconds 1000
}
