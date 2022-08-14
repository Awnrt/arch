LIGHTGREEN='\033[1;32m'
LIGHTRED='\033[1;91m'
WHITE='\033[1;97m'
MAGENTA='\033[1;35m'
CYAN='\033[1;96m'
NoColor='\033[0m'

clear
printf ${LIGHTRED}"Installing KDE...\n"
printf ${NoColor}""
pacman -Sy networkmanager --noconfirm
systemctl enable NetworkManager.service
pacman -S xorg-server xorg-apps xorg-xinit xorg-twn xorg-xclock xterm --noconfirm
pacman -S plasma sddm --noconfirm
systemctl enable sddm.service
pacman -S konsole --noconfirm

cd /mnt
cd ..
rm post_chroot.sh
rm setup_kde.sh
