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


printf ${LIGHTRED}"Partitioning the disk...\n"
printf ${NoColor}""

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | gdisk /dev/$disk_drive
x
z
y
y
EOF
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/$disk_drive
g
n


+512M
t
1
n


+8G
t
2
19
n


+35G
t
3
20
n


+67G
t
4
20
w

EOF
printf ${LIGHTRED}"Making filesystem...\n"
printf ${NoColor}""

mkfs.fat -F32 /dev/$disk_drive"p1"
mkswap /dev/$disk_drive"p2"
swapon /dev/$disk_drive"p2"
mkfs.ext4 /dev/$disk_drive"p3"
mkfs.ext4 /dev/$disk_drive"p4"

printf ${LIGHTRED}"Mounting partitions...\n"
printf ${NoColor}""

mount /dev/$disk_drive"p3" /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/$disk_drive"p1" /mnt/boot
mount /dev/$disk_drive"p4" /mnt/home

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
