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
echo "include /usr/share/nano/*.nanorc" >> /home/jimbob/.nanorc
echo "startx" >> /home/jimbob/.bash_profile
echo "slstatus &" >> /home/jimbob/.xinitrc
echo "exec dwm" >> /home/jimbob/.xinitrc
echo "PS1='\[\e[0;38;5;203m\][\[\e[0;38;5;214m\]\u\[\e[0;38;5;34m\]@\[\e[0;38;5;111m\]\h\[\e[0m\] \[\e[0;38;5;147m\]\W\[\e[0;38;5;203m\]]\[\e[0m\]$\[\e[0m\] \[\e[0m\]'" >> /home/jimbob/.bashrc
sudo pacman -S alsa-utils pulseaudio pulsemixer
sudo localectl --no-convert set-x11-keymap us,ru "" "" grp:ctrl_shift_toggle
sudo mv /usr/share/icons/default/index.theme backupindex.theme
sudo cp /home/jimbob/arch/macOSBigSur/index.theme /usr/share/icons/default
sudo cp /home/jimbob/arch/macOSBigSur/cursor.theme /usr/share/icons/default
sudo cp -r /home/jimbob/arch/macOSBigSur/cursors /usr/share/icons/default
