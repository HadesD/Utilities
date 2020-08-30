@echo OFF

set HOSTSFILE="%SYSTEMROOT%\System32\drivers\etc\hosts"

type %HOSTSFILE% | findstr "127.0.0.1.*111.fanren520.com.*" > nul
if %ERRORLEVEL% EQU 1 (
	echo "127.0.0.1 hi.baidu.com xz.jack52088.com hi.n.shifen.com 111.fanren520.com lll.fanren520.com" >> %HOSTSFILE%
	type %HOSTSFILE%
)
pause
