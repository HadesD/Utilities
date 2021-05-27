read -p 'EXTRACT_PASSWORD=' EXTRACT_PASSWORD

7z a -t7z ../RemoteTools.7z ../Keys ../Navicat ../SSH ../WinSCP ../Zip -p"${EXTRACT_PASSWORD}"
