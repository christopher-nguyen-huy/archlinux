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
Clear cache except last 3 builds
```bash
paccache -r
```
Clear all Cache
```bash
pacman -Sc
```
## Size cleanup
```bash
expac -H M '%m\t%n' | sort -h
pacgraph -c
```
## Dependencies
```bash
pacman -Qii package
```
START???
Find dependencies of package
```bash
pactree -u package
```
Find dependants of package
```bash
pactree -r package
```
END???
## Color output
In `/etc/pacman.conf`, uncomment Color