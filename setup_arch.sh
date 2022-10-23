LIGHTGREEN='\033[1;32m'
LIGHTRED='\033[1;91m'
WHITE='\033[1;97m'
MAGENTA='\033[1;35m'
CYAN='\033[1;96m'
NoColor='\033[0m'

printf ${LIGHTRED}"Enter your disk label (sda, sdb, etc.): "
printf ${NoColor}""

read -p "" disk_drive
disk_drive=${disk_drive:-sda}
without_p_nvme=${disk_drive//p}

#disk_chk=("/dev/${disk_drive}")
printf ${LIGHTRED}"Hostname: "
printf ${NoColor}""
read -p "" _hostname
_hostname=${_hostname:-overlord}

printf ${LIGHTRED}"Username: "
printf ${NoColor}""
read -p "" _username
_username=${_username:-jimbob}

printf ${LIGHTRED}"ROOT password: "
printf ${NoColor}""
read -p "" _rootpasswd
_rootpasswd=${_rootpasswd:-1nsdj}

printf ${LIGHTRED}"User password: "
printf ${NoColor}""
read -p "" _userpasswd
_userpasswd=${_userpasswd:-kekw}

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/$without_p_nvme
g
n


+512M
y
t
1
n


+8G
y
t
2
19
n


+35G
y
t
3
20
n


+67G
y
t
4
20
w

EOF

printf ${LIGHTRED}"Making filesystem...\n"
printf ${NoColor}""

mkfs.fat -F32 /dev/$disk_drive"1"
mkswap /dev/$disk_drive"2"
swapon /dev/$disk_drive"2"
mkfs.ext4 /dev/$disk_drive"3"
mkfs.ext4 /dev/$disk_drive"4"

printf ${LIGHTRED}"Mounting partitions...\n"
printf ${NoColor}""

mount /dev/$disk_drive"3" /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/$disk_drive"1" /mnt/boot
mount /dev/$disk_drive"4" /mnt/home

printf ${LIGHTRED}"Installing RankMirrors...\n"
printf ${NoColor}""

pacman -Sy --noconfirm
pacman -S pacman-contrib --noconfirm
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
printf ${LIGHTRED}"Searching for fastest mirrors...\n"
printf ${NoColor}""
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
printf ${LIGHTRED}"Installing Arch...\n"
printf ${NoColor}""

pacstrap -i /mnt base base-devel linux linux-headers --noconfirm
genfstab -U -p /mnt >> /mnt/etc/fstab

cp post_chroot.sh /mnt
cp setup_kde.sh /mnt
clear
export disk_drive
export _hostname
export _username
export _rootpasswd
export _userpasswd
arch-chroot /mnt ./post_chroot.sh
