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

## Partitioning
Format disk with `cfdisk`
- `mbr` for bios, `gpt` for the complicated stuff
### EFI
- 500mb efi
- 100% linux luks
### Not EFI
....

## Cryptsetup + LVM
Do I do this before or after formatting?
```bash
# https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#Encrypted_boot_partition_(GRUB)
cryptsetup luksFormat --type luks1 -s 512 -h sha512 /dev/nvme0n1p2
cryptsetup open /dev/nvme0n1p2 lvm
pvcreate /dev/mapper/lvm
vgcreate vg /dev/mapper/lvm
lvcreate -n root -l 100%FREE vg
```

## Formatting
### EFI
```
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/dev/vg/root
```

## Mounting
```bash
mount /dev/vg/root /mnt
mkdir -p /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi
```

## Pacstrapping
```bash
pacstrap /mnt base base-devel linux-zen linux-firmware grub nano dhcpcd ntp lvm2 efibootmgr wget
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

## Installing
```bash
ln -sf /usr/share/zoneinfo/Americas/New_York /etc/localtime
hwclock --systohc
nano /etc/locale.gen # Uncomment en_US.utf-8 and en_US.thenumbers
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "<hostname>" >> /etc/hostname
nano /etc/hosts
127.0.0.1		<hostname>
::1				localhost
127.0.0.1		<hostname>.localdomain localdomain
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
`nano /etc/mkinitcpio.conf`
```
add (encrypt lvm2) before filesystems in hooks
FILES=(/crypto_keyfile.bin)
```
```bash
mkinitcpio -P linux-zen
```

## Grub
`nano /etc/default/grub`
```
GRUB_CMDLINE_LINUX="quiet cryptdevice=/dev/nvme0n1p2:lvm root=/dev/vg/root cryptkey=rootfs:/crypto_keyfile.bin"
GRUB_ENABLE_CRYPTODISK=y
```

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

# enable wifi (OLD)
```
pacman -S netctl wpa_supplicant dialog
ip link set wlp3s0 down
wifi-menu
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
umount -R /mnt
reboot
```