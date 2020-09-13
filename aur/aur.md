# Aur
Aur cheatsheet

## Classic
- Use build directory `~/aur/`
### Dependencies
- git
- base-devel

### Install
```bash
git clone https://aur.archlinux.org/<package>.git
cd <package>
makepkg -sric # --syncdeps(pacman) --remove-dependencies-after-build --install-after-build --clean-after-build
```

### Update
```bash
cd <package>
git pull
makepkg -sric
```
### Uninstall
```bash
pacman -Rcns <package>
```
## [Yay](https://github.com/Jguer/yay)
### Install
```bash
yay -S <pkgName>
```
### Update

#### Update all (official & aur)
```bash
yay -Syu
```

### Uninstall
```bash
yay -Rs <pkgName>
```