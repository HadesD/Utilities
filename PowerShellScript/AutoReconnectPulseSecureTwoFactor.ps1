# https://qiita.com/nimzo6689/items/488467dbe0c4e5645745

Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms
<#
.Synopsis
   実行中の任意のプロセスにキーストロークを送る操作をします。
.DESCRIPTION
   パラメータのキーストローク、プロセス名がそれぞれ未指定の場合、何も実行されません。
   キーストロークのみが指定された場合は実行時のフォーカスへキーストロークを送り、
   プロセス名のみが指定された場合はフォーカスのみが指定されたプロセスに変更します。
.EXAMPLE
   Send-Keys -KeyStroke "test.%~" -ProcessName "LINE"

   このコマンドは既に起動中のLINEアプリに対して"test."と入力し、
   Altキーを押しながらEnterキーを押下する操作をしています。
#>
function Send-Keys
{
    [CmdletBinding()]
    [Alias("sdky")]
    Param
    (
        # キーストローク
        # アプリケーションに送りたいキーストローク内容を指定します。
        # キーストロークの記述方法は下記のWebページを参照。
        # https://msdn.microsoft.com/ja-jp/library/cc364423.aspx
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]
        $KeyStroke,

        # プロセス名
        # キーストロークを送りたいアプリケーションのプロセス名を指定します。
        # 複数ある場合は、PIDが一番低いプロセスを対象とする。
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProcessName,

        # 待機時間
        # コマンドを実行する前の待機時間をミリ秒単位で指定します。
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

# https://qiita.com/y-takano/items/cb752ad6a10e550ec92f

# ========= C#言語によるWin32Api関数定義(ここから) =========
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class Win32Api
{
    [DllImport("user32.dll")]
    public static extern int MessageBox(
        IntPtr hWnd,        // オーナーウィンドウのハンドル
        string lpText,      // メッセージボックス内のテキスト
        string lpCaption,   // メッセージボックスのタイトル
        UInt32 uType        // メッセージボックスのスタイル
    );

    [DllImport("user32.dll")]
    public static extern IntPtr FindWindow(String sClassName, IntPtr sAppName);

    [DllImport("kernel32.dll")]
    public static extern uint GetLastError();

    [DllImport("user32.dll")]
    public static extern bool SetWindowPos(
        IntPtr hWnd,            // ウィンドウのハンドル
        IntPtr hWndInsertAfter, // 配置順序のハンドル
        int    X,               // 横方向の位置
        int    Y,               // 縦方向の位置
        int    cx,              // 幅
        int    cy,              // 高さ
        UInt32 uFlags           // ウィンドウ位置のオプション
    );

    [DllImport("user32.dll")]
    public static extern bool PostMessage(IntPtr hWnd, uint Msg, int wParam, int lParam);

    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll", SetLastError=true)]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint processId);

    [DllImport("kernel32.dll")]
    public static extern IntPtr OpenProcess(int dwDesiredAccess, bool bInheritHandle, int dwProcessId);

    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern bool CloseHandle(
        IntPtr hObject   // handle to object
    );
}
"@

# Get current active app
$activeHandle = [Win32Api]::GetForegroundWindow()
$hwndProcess = Get-Process | ? {$_.MainWindowHandle -eq $activeHandle}
#Echo $hwndProcess

# Test
#Send-Keys '123456{Enter}' -ProcessName 'mintty'
#[Microsoft.VisualBasic.Interaction]::AppActivate($hwndProcess.Id)
#Echo $activeHandle
#$win32::PostMessage($activeHandle, 0x0100, 65, 0);
#$win32::PostMessage($activeHandle, 0x0102, 65, 0);

#$win32::FindWindow([IntPtr]::Zero, "JamShadowClass");

# Processing
while($true)
{
    # Get window Handle
    $pulseHwnd = [Win32Api]::FindWindow("JamShadowClass", [IntPtr]::Zero);
    Echo "Pulse Secure hWnd: $pulseHwnd"

    <#
    $pulsePId = [UInt32]::Zero
    $retCode = [Win32Api]::GetWindowThreadProcessId($pulseHwnd, [ref] $pulsePId);
    Echo "Pulse Secure PId: $pulsePId"
    $hPId = [Win32Api]::OpenProcess(0x1F0FFF, $true, $pulsePId);
    Echo "Pulse Secure Process Handle: $hPId"
    #>

    [Win32Api]::PostMessage($pulseHwnd, 0x0100, 13, 0);
    sleep -Milliseconds 1000
}

# Close Handle
$retCloseHandle = [Win32Api]::CloseHandle($hPId)
Echo "CloseHandle of PId($pulsePId): $retCloseHandle"
