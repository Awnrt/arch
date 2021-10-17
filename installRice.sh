sudo pacman -Sy xorg-server xorg-xinit libx11 libxinerama libxft webkit2gtk
sudo pacman -S ttf-dejavu ttf-font-awesome
git clone https://github.com/MentalOutlaw/dwm
git clone https://github.com/MentalOutlaw/st
git clone https://github.com/MentalOutlaw/slstatus
nano dwm/config.h
nano st/config.h
cd /home/jimbob/arch/dwm
sudo make clean install
cd /home/jimbob/arch/st
sudo make clean install
cd /home/jimbob/arch/slstatus
sudo make clean install
echo "slstatus &" >> /home/jimbob/.xinitrc
echo "exec dwm" >> /home/jimbob/.xinitrc
sudo pacman -S alsa-utils pulseaudio pulsemixer
