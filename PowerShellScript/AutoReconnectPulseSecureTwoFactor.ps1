Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms

<#
https://qiita.com/nimzo6689/items/488467dbe0c4e5645745
.Synopsis
   å®Ÿè¡Œä¸­ã®ä»»æ„ã®ãƒ—ãƒ­ã‚»ã‚¹ã«ã‚­ãƒ¼ã‚¹ãƒˆãƒ­ãƒ¼ã‚¯ã‚’é€ã‚‹æ“ä½œã‚’ã—ã¾ã™ã€‚
.DESCRIPTION
   ãƒ‘ãƒ©ãƒ¡ãƒ¼ã‚¿ã®ã‚­ãƒ¼ã‚¹ãƒˆãƒ­ãƒ¼ã‚¯ã€ãƒ—ãƒ­ã‚»ã‚¹åãŒãã‚Œãžã‚ŒæœªæŒ‡å®šã®å ´åˆã€ä½•ã‚‚å®Ÿè¡Œã•ã‚Œã¾ã›ã‚“ã€‚
   ã‚­ãƒ¼ã‚¹ãƒˆãƒ­ãƒ¼ã‚¯ã®ã¿ãŒæŒ‡å®šã•ã‚ŒãŸå ´åˆã¯å®Ÿè¡Œæ™‚ã®ãƒ•ã‚©ãƒ¼ã‚«ã‚¹ã¸ã‚­ãƒ¼ã‚¹ãƒˆãƒ­ãƒ¼ã‚¯ã‚’é€ã‚Šã€
   ãƒ—ãƒ­ã‚»ã‚¹åã®ã¿ãŒæŒ‡å®šã•ã‚ŒãŸå ´åˆã¯ãƒ•ã‚©ãƒ¼ã‚«ã‚¹ã®ã¿ãŒæŒ‡å®šã•ã‚ŒãŸãƒ—ãƒ­ã‚»ã‚¹ã«å¤‰æ›´ã—ã¾ã™ã€‚
.EXAMPLE
   Send-Keys -KeyStroke "test.%~" -ProcessName "LINE"
   ã“ã®ã‚³ãƒžãƒ³ãƒ‰ã¯æ—¢ã«èµ·å‹•ä¸­ã®LINEã‚¢ãƒ—ãƒªã«å¯¾ã—ã¦"test."ã¨å…¥åŠ›ã—ã€
   Altã‚­ãƒ¼ã‚’æŠ¼ã—ãªãŒã‚‰Enterã‚­ãƒ¼ã‚’æŠ¼ä¸‹ã™ã‚‹æ“ä½œã‚’ã—ã¦ã„ã¾ã™ã€‚
#>
function Send-Keys
{
    [CmdletBinding()]
    [Alias("sdky")]
    Param
    (
        # ã‚­ãƒ¼ã‚¹ãƒˆãƒ­ãƒ¼ã‚¯
        # ã‚¢ãƒ—ãƒªã‚±ãƒ¼ã‚·ãƒ§ãƒ³ã«é€ã‚ŠãŸã„ã‚­ãƒ¼ã‚¹ãƒˆãƒ­ãƒ¼ã‚¯å†…å®¹ã‚’æŒ‡å®šã—ã¾ã™ã€‚
        # ã‚­ãƒ¼ã‚¹ãƒˆãƒ­ãƒ¼ã‚¯ã®è¨˜è¿°æ–¹æ³•ã¯ä¸‹è¨˜ã®Webãƒšãƒ¼ã‚¸ã‚’å‚ç…§ã€‚
        # https://msdn.microsoft.com/ja-jp/library/cc364423.aspx
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]
        $KeyStroke,

        # ãƒ—ãƒ­ã‚»ã‚¹å
        # ã‚­ãƒ¼ã‚¹ãƒˆãƒ­ãƒ¼ã‚¯ã‚’é€ã‚ŠãŸã„ã‚¢ãƒ—ãƒªã‚±ãƒ¼ã‚·ãƒ§ãƒ³ã®ãƒ—ãƒ­ã‚»ã‚¹åã‚’æŒ‡å®šã—ã¾ã™ã€‚
        # è¤‡æ•°ã‚ã‚‹å ´åˆã¯ã€PIDãŒä¸€ç•ªä½Žã„ãƒ—ãƒ­ã‚»ã‚¹ã‚’å¯¾è±¡ã¨ã™ã‚‹ã€‚
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProcessName,

        # å¾…æ©Ÿæ™‚é–“
        # ã‚³ãƒžãƒ³ãƒ‰ã‚’å®Ÿè¡Œã™ã‚‹å‰ã®å¾…æ©Ÿæ™‚é–“ã‚’ãƒŸãƒªç§’å˜ä½ã§æŒ‡å®šã—ã¾ã™ã€‚
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
            [Microsoft.VisualBasic.Interaction]::AppActivate($Process.Id)
        }
        [System.Windows.Forms.SendKeys]::SendWait($KeyStroke)
    }
}
# https://qiita.com/y-takano/items/cb752ad6a10e550ec92f
$Win32 = &{
# ========= C#言語によるWin32Api関数定義(ここから) =========
$cscode = @"

[DllImport("user32.dll")]
public static extern int MessageBox(
    IntPtr hWnd,        // オーナーウィンドウのハンドル
    string lpText,      // メッセージボックス内のテキスト
    string lpCaption,   // メッセージボックスのタイトル
    UInt32 uType        // メッセージボックスのスタイル
);

[DllImport("user32.dll")]
public static extern IntPtr FindWindow(
    string lpClassName,  // クラス名
    string lpWindowName  // ウィンドウ名
);

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

"@
# ========= C#言語によるWin32Api関数定義(ここまで) =========

    return (add-type -memberDefinition $cscode -name "Win32ApiFunctions" -passthru)
}


# Get current active app
$activeHandle = $win32::GetForegroundWindow()
$hwndProcess = Get-Process | ? {$_.MainWindowHandle -eq $activeHandle}
#Echo $hwndProcess

# Test
#Send-Keys '123456{Enter}' -ProcessName 'mintty'
#[Microsoft.VisualBasic.Interaction]::AppActivate($hwndProcess.Id)

$win32::PostMessage($activeHandle, 0x0100, 100, 0);
