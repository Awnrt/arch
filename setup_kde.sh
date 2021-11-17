pacman -Sy networkmanager
systemctl enable NetworkManager.service
pacman -S xorg-server xorg-apps xorg-xinit xorg-twn xorg-xclock xterm
pacman -S plasma sddm
systemctl enable sddm.service
pacman -S konsole

printf ${LIGHTRED}"\nFinished!\nNow you need to add this stuff into modules list PATH /etc/mkinitcpio.conf\nMODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)\nAnd after that you can EXIT and reboot your system\n"
printf ${LIGHTGREEN}""
cd /mnt
cd ..
rm post_chroot.sh
rm setup_kde.sh
