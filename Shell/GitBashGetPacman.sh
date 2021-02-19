REPO_DIR_NAME=gfw-sdk-64-t
LIST_CHECKOUT_NEED="usr/bin/pacman.exe usr/bin/pacman-conf.exe usr/bin/pacman-db-upgrade usr/bin/pacman-key usr/bin/pacman-rec-filename-grep"
LIST_CHECKOUT_NEED="$LIST_CHECKOUT_NEED etc/pacman.d/ var/lib/pacman/ usr/share/makepkg/util"

git clone --depth=1 --filter=blob:none --sparse https://github.com/git-for-windows/git-sdk-64.git --no-checkout ${REPO_DIR_NAME}
cd ${REPO_DIR_NAME}
git sparse-checkout init --cone
git reset HEAD
git checkout -- $LIST_CHECKOUT_NEED
# git checkout -f $LIST_CHECKOUT_NEED

cp usr/bin/pacman* /usr/bin/
cp -a etc/pacman.* /etc/
mkdir -p /var/lib/
cp -a var/lib/pacman /var/lib/
cp -a usr/share/makepkg/util* /usr/share/makepkg/

pacman --database --check

curl -L https://raw.githubusercontent.com/git-for-windows/build-extra/master/git-for-windows-keyring/git-for-windows.gpg \
| pacman-key --add - \
&& pacman-key --lsign-key 1A9F3986

pacman -S tree
