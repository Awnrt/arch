LIGHTGREEN='\033[1;32m'
LIGHTRED='\033[1;91m'
WHITE='\033[1;97m'
MAGENTA='\033[1;35m'
CYAN='\033[1;96m'
NoColor='\033[0m'

printf ${NoColor}""
pacman -Sy bash-completion --noconfirm
printf ${LIGHTRED}"Generating locale...\n"
printf ${NoColor}""

echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
printf ${LIGHTRED}"Setting up timezone...\n"
printf ${NoColor}""

ln -s /usr/share/zoneinfo/Europe/Moscow > /etc/localtime
hwclock --systohc --utc
clear

echo $_hostname > /etc/hostname

printf ${LIGHTRED}"Enabling multilib...\n"
printf ${NoColor}""

echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
pacman -Sy --noconfirm

printf ${LIGHTRED}"Enabling fstrim.timer...\n"
printf ${NoColor}""
systemctl enable fstrim.timer

useradd -m -g users -G wheel,storage,power -s /bin/bash $_username

echo root:$_rootpasswd | chpasswd

echo $_username:$_userpasswd | chpasswd

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo "Defaults rootpw" >> /etc/sudoers

printf ${LIGHTRED}"Installing bootloader...\n"
printf ${NoColor}""

bootctl install

printf ${LIGHTRED}"Installing intel-ucode...\n"
printf ${NoColor}""

pacman -S intel-ucode --noconfirm

printf ${LIGHTRED}"Creating configuration file for bootloader...\n"
printf ${NoColor}""

echo "title Arch Linux" >> /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /intel-ucode.img" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf

echo "options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/$disk_drive"3") rw" nvidia-drm.modeset=1 intel_iommu=on >> /boot/loader/entries/arch.conf

clear
printf ${LIGHTRED}"Installing DHCPCD...\n"
printf ${NoColor}""

pacman -S dhcpcd --noconfirm
systemctl enable dhcpcd@eno1.service

printf ${LIGHTRED}"Installing NVIDIA Drivers...\n"
printf ${NoColor}""

pacman -S linux-headers --noconfirm
pacman -S nvidia-dkms nvidia-utils opencl-nvidia libglvnd lib32-libglvnd lib32-nvidia-utils lib32-opencl-nvidia nvidia-settings --noconfirm

sudo sed -i -e 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/g' /etc/mkinitcpio.conf

printf ${LIGHTRED}"Creating hooks for NVIDIA...\n"
printf ${NoColor}""

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

echo "include /usr/share/nano/*.nanorc" >> /home/$_username/.nanorc

cd /mnt
cd ..
./setup_kde.sh
