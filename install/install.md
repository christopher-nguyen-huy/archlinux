# Installing
## ISO
### Windows
- Download ISO
- Use Rufus to apply iso to usb in iso mode
- Ensure that usb name has the correct month of the iso

### Linux
[Reference](https://wiki.archlinux.org/index.php/USB_flash_installation_medium#Using_basic_CLI_utilities)
Run the following command, replacing `/dev/sdx` with your drive, e.g. `/dev/sdb`. (Do not append a partition number, so do not use something like `/dev/sdb1`):
- `# cat path/to/archlinux.iso > /dev/sdx`
- `# cp path/to/archlinux.iso /dev/sdx`
- `# dd bs=4M if=path/to/archlinux.iso of=/dev/sdx status=progress oflag=sync`
- `# tee < path/to/archlinux.iso > /dev/sdx`

## Bootup
- Type e to add kernel parameters

### Kernel parameters
- acpi=off
- nomodeset
- i915.modeset=off
- nouveau.modeset=0

## Sync clock
Otherwise internet doesn't work [Reference](https://www.tecmint.com/set-time-timezone-and-synchronize-time-using-timedatectl-command/)
```
# timedatectl set-ntp true
# timedatectl status # check to see if it works
# timedatectl set-ntp 0 # disable
# timedatectl set-time "2019-11-20 14:25:30" # use utc time
# timedatectl set-ntp true
```

## Formating
Format disk with `cfdisk`
- `mbr` for bios, `gpt` for the complicated stuff
### EFI

### Not EFI

## Mounting
```bash
pacstrap /mnt base base-devel linux-firmware linux-zen lvm2 efibootmgr nano dhcpcd wget
genfstab -U /mnt >> /mnt/etc/fstab
```

## Installing
```bash
pacstrap /mnt base linux-zen linux-firmware grub nano dhcpcd ntp lvm2 efibootmgr wget
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Americas/New_York /etc/localtime
hwclock --systohc
nano /etc/locale.gen # Uncomment en_US.utf-8 and en_US.thenumbers
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "<hostname>" >> /etc/hostname
nano /etc/hosts
passwd # change password
```

## Create user
```bash
useradd -m -g users -G chris
passwd chris
visudo
```
```
root ALL=(ALL) ALL
chris ALL=(ALL) ALL
```

## Crypto Keyfile
```bash
dd if=/dev/urandom of=/crypto_keyfile.bin bs=512 count=10
chmod 000 /crypto_keyfile.bin
exit # exit chroot
cryptsetup luksAddKey /dev/nvme0n1p2 /mnt/crypto_keyfile.bin
arch-chroot /mnt # re-enter chroot
```

## CPU Microcode
```bash
pacman -S amd-ucode
pacman -S intel-ucode
```

## Kernel
```bash
mkinitcpio -P linux-zen
```

## Grub
```bash
grub-mkconfig -o /boot/grub/grub.cfg
grub-install --target=x86_64-efi --efi-directory=/efi
```

## Enable dhcp
```
systemctl enable dhcpcd.service
systemctl start dhcpcd.service
```

## Enable ntp
```
systemctl enable ntpd.service
systemctl start ntpd.service
```

## Setup root home folder
### Bash shell
- To know if you're root
### Default dotfiles
- For comfort when sudoing
```bash
cp /etc/skel/nano
```

## Exit reboot
```bash
exit
reboot
```