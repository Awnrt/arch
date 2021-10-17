#Locale installation
echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
#Setting timezone
ln -s /usr/share/zoneinfo/Europe/Moscow > /etc/localtime
hwclock --systohc --utc
#Setting hostname
echo overlord > /etc/hostname
#Enabling multilib
echo "Enabling multilib..."
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
pacman -Sy
#For SSDs
systemctl enable fstrim.timer
#Useradd
useradd -m -g users -G wheel,storage,power -s /bin/bash jimbob
#Setting password for root and user
echo "Enter root password"
passwd
echo "Enter user password"
passwd jimbob
#Sudoers adding wheel group to users
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo "Defaults rootpw" >> /etc/sudoers
#Installing bootloader
bootctl install
#Settings boot options
pacman -S intel-ucode
echo "title Arch Linux" >> /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /intel-ucode.img" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
#Hardening boot path
echo "options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/nvme1n1p3) rw" nvidia-drm.modeset=1 intel_iommu=on >> /boot/loader/entries/arch.conf
#DHCPCD installation
pacman -S dhcpcd
systemctl enable dhcpcd@eno1.service
#Installing NVIDIA Drivers
pacman -S linux-headers
pacman -S nvidia-dkms nvidia-utils opencl-nvidia libglvnd lib32-libglvnd lib32-nvidia-utils lib32-opencl-nvidia nvidia-settings
#Creating hooks for NVIDIA
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
#Modules
echo "Now you need to add this stuff into modules list PATH /etc/mkinitcpio.conf"
echo "MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)"
echo "And after that you can EXIT and reboot your system"
