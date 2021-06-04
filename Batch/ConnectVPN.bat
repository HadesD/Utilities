@echo OFF
set VPN_NAME=vpn-for-game
set SERVER_ADDR=sg-l2tp.racevpn.com
set SHARED_KEY=racevpn
set VPN_USERNAME=racevpn.com-vpn2vpn
set VPN_PASSWORD=vpn2vpn

rasdial /DISCONNECT

powershell Add-VpnConnection -Name %VPN_NAME% -ServerAddress %SERVER_ADDR% -Force -Confirm:$false && ^
powershell Set-VpnConnection -Name %VPN_NAME% -ServerAddress %SERVER_ADDR% -TunnelType L2tp -L2tpPsk %SHARED_KEY% -RememberCredential:$true -Force:$true -Confirm:$false

powershell Get-VpnConnection -Name %VPN_NAME% && ^
rasdial %VPN_NAME% %VPN_USERNAME% %VPN_PASSWORD%

pause
