sudo pacman -S networkmanager
sudo systemctl enable NetworkManager.service
sudo pacman -S xorg-server xorg-apps xorg-xinit xorg-twn xorg-xclock xterm
sudo pacman -S plasma sddm
sudo systemctl enable sddm.service
reboot
