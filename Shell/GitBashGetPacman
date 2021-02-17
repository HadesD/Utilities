git clone --depth=1 https://github.com/git-for-windows/git-sdk-64 gfw-sdk

cp gfw-sdk/usr/bin/pacman* /usr/bin/
cp -a gfw-sdk/etc/pacman.* /etc/
mkdir -p /var/lib/
cp -a gfw-sdk/var/lib/pacman /var/lib/
cp -a gfw-sdk/usr/share/makepkg/util* /usr/share/makepkg/

pacman --database --check

curl -L https://raw.githubusercontent.com/git-for-windows/build-extra/master/git-for-windows-keyring/git-for-windows.gpg \
| pacman-key --add - \
&& pacman-key --lsign-key 1A9F3986

pacman -S tree
