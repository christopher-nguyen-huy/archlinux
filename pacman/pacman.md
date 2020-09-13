# Pacman cheat sheet
Installing
```bash
pacman -S package
```
Updating
```bash
pacman -Syu
```
Removing
```bash
pacman -Rcns package
# -R remove
# -s remove dependencies
# -n remove backup configuration files 
# -c remove all packages that depend on this package
```
List
```bash
pacman -Qqe
```

## Color output
In `/etc/pacman.conf`, uncomment Color