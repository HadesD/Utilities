@echo OFF

net session >nul 2>&1
if %errorLevel% == 0 (
    echo Success: Administrative permissions confirmed.
) else (
    powershell -command start-process -file ConnectVPN.bat -verb runas
    exit /b 0
)

REM # IExpress command line install
REM # powershell.exe (New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/HadesD/Utilities/master/Batch/ConnectVPN.bat", "ConnectVPN.bat") && cmd /c ConnectVPN.bat

set VPN_NAME=VPN-For-Gamer
set SERVER_ADDR=sg-l2tp.racevpn.com
set SHARED_KEY=racevpn
set VPN_USERNAME=racevpn.com-vpn2vpn
set VPN_PASSWORD=vpn2vpn

set SERVER_ADDR=aws-sg-t3-small.hadesd.com
set SHARED_KEY=kPKsKRXYJBahzu4mdWb9
set VPN_USERNAME=vpnuser
set VPN_PASSWORD=wCEDrsTLe5bJLhjD

rasdial /DISCONNECT

powershell -command "Add-VpnConnection -ServerAddress '%SERVER_ADDR%' -Name '%VPN_NAME%' -TunnelType IKEv2 -AuthenticationMethod MachineCertificate -EncryptionLevel Required -PassThru"
powershell -command "Set-VpnConnectionIPsecConfiguration -ConnectionName '%VPN_NAME%' -AuthenticationTransformConstants GCMAES128 -CipherTransformConstants GCMAES128 -EncryptionMethod AES256 -IntegrityCheckMethod SHA256 -PfsGroup None -DHGroup Group14 -PassThru -Force  -L2tpPsk %SHARED_KEY% -RememberCredential:$true -Force:$true -Confirm:$false"

REM powershell Add-VpnConnection -Name %VPN_NAME% -ServerAddress %SERVER_ADDR% -Force -Confirm:$false && ^
REM powershell Set-VpnConnection -Name %VPN_NAME% -ServerAddress %SERVER_ADDR% -TunnelType L2tp -L2tpPsk %SHARED_KEY% -RememberCredential:$true -Force:$true -Confirm:$false

powershell Get-VpnConnection -Name %VPN_NAME% && ^
rasdial %VPN_NAME% %VPN_USERNAME% %VPN_PASSWORD%

pause
