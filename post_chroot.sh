LIGHTGREEN='\033[1;32m'
LIGHTRED='\033[1;91m'
WHITE='\033[1;97m'
MAGENTA='\033[1;35m'
CYAN='\033[1;96m'
NoColor='\033[0m'

printf ${LIGHTGREEN}""
pacman -Sy nano bash-completion
printf ${MAGENTA}"Generating locale...\n"
printf ${LIGHTGREEN}""

echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
printf ${MAGENTA}"Setting up timezone...\n"
printf ${LIGHTGREEN}""

ln -s /usr/share/zoneinfo/Europe/Moscow > /etc/localtime
hwclock --systohc --utc
clear
printf ${MAGENTA}"Type in hostname: "
printf ${NoColor}""
read -p "" _hostname
_hostname=${_hostname:-overlord}

echo $_hostname > /etc/hostname

printf ${MAGENTA}"Enabling multilib...\n"
printf ${LIGHTGREEN}""

echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
pacman -Sy

printf ${MAGENTA}"Enabling fstrim.timer...\n"
printf ${LIGHTGREEN}""
systemctl enable fstrim.timer

printf ${MAGENTA}"Username: "
printf ${NoColor}""
read -p "" _username
_username=${_username:-jimbob}

useradd -m -g users -G wheel,storage,power -s /bin/bash $_username

echo "Enter root password"
passwd
echo "Enter user password"
passwd $_username

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo "Defaults rootpw" >> /etc/sudoers

printf ${MAGENTA}"Installing bootloader...\n"
printf ${LIGHTGREEN}""

bootctl install

printf ${MAGENTA}"Installing intel-ucode...\n"
printf ${LIGHTGREEN}""

pacman -S intel-ucode

printf ${MAGENTA}"Creating configuration file for bootloader...\n"
printf ${LIGHTGREEN}""

echo "title Arch Linux" >> /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /intel-ucode.img" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf

echo "options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/$disk_drive"3") rw" nvidia-drm.modeset=1 intel_iommu=on >> /boot/loader/entries/arch.conf

clear
printf ${MAGENTA}"Installing DHCPCD...\n"
printf ${LIGHTGREEN}""

pacman -S dhcpcd
systemctl enable dhcpcd@eno1.service

printf ${MAGENTA}"Installing NVIDIA Drivers...\n"
printf ${LIGHTGREEN}""

pacman -S linux-headers
pacman -S nvidia-dkms nvidia-utils opencl-nvidia libglvnd lib32-libglvnd lib32-nvidia-utils lib32-opencl-nvidia nvidia-settings

printf ${MAGENTA}"Creating hooks for NVIDIA...\n"
printf ${LIGHTGREEN}""

mkdir /etc/pacman.d/hooks
echo "[Trigger]" >> /etc/pacman.d/hooks/nvidia
echo "Operation=Install" >> /etc/pacman.d/hooks/nvidia
echo "Operation=Upgrade" >> /etc/pacman.d/hooks/nvidia
echo "Operation=Remove" >> /etc/pacman.d/hooks/nvidia
echo "Type=Package" >> /etc/pacman.d/hooks/nvidia
echo "Target=nvidia" >> /etc/pacman.d/hooks/nvidia
echo "[Action]" >> /etc/pacman.d/hooks/nvidia
echo "Depends=mkinitcpio" >> /etc/pacman.d/hooks/nvidia
echo "When=PostTransaction" >> /etc/pacman.d/hooks/nvidia
echo "Exec=/usr/bin/mkinitcpio -P" >> /etc/pacman.d/hooks/nvidia

printf ${LIGHTRED}"\nFinished!\nNow you need to add this stuff into modules list PATH /etc/mkinitcpio.conf\nMODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)\nAnd after that you can EXIT and reboot your system\n"
printf ${LIGHTGREEN}""
