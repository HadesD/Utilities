## Install

https://www.msys2.org/

```
pacman -Suy zsh git vim
```

## u_msys2.reg
```
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\Directory\Background\shell\u_msys2]
@="MSYS2 Here"
"Icon"="C:\\msys64\\msys2.exe"

[HKEY_CLASSES_ROOT\Directory\Background\shell\u_msys2\command]
@="C:\\msys64\\msys2.exe /usr/bin/zsh"

[HKEY_CLASSES_ROOT\Directory\shell\u_msys2]
@="MSYS2 Here"
"Icon"="C:\\msys64\\msys2.exe"

[HKEY_CLASSES_ROOT\Directory\shell\u_msys2\command]
@="C:\\msys64\\msys2.exe /usr/bin/zsh"
```

## C:/msys64/msys2.ini
```
MSYSTEM=MSYS
HOME=%USERPROFILE%
SHELL=/usr/bin/zsh
MSYS=winsymlinks:nativestrict
MSYS2_PATH_TYPE=inherit
```

*Remember to `Run as Admin` when you want to do synbolic link*

## Using git of msys2 on vscode

https://github.com/Microsoft/vscode/issues/4651
