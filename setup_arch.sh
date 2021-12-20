LIGHTGREEN='\033[1;32m'
LIGHTRED='\033[1;91m'
WHITE='\033[1;97m'
MAGENTA='\033[1;35m'
CYAN='\033[1;96m'
NoColor='\033[0m'

printf ${MAGENTA}"Enter your disk label (sda, sdb, etc.): "
printf ${NoColor}""

read -p "" disk_drive
disk_drive=${disk_drive:-sda}
#disk_chk=("/dev/${disk_drive}")

printf ${MAGENTA}"Making filesystem...\n"
printf ${LIGHTGREEN}""

mkfs.fat -F32 /dev/$disk_drive"1"
mkswap /dev/$disk_drive"2"
swapon /dev/$disk_drive"2"
mkfs.ext4 /dev/$disk_drive"3"
mkfs.ext4 /dev/$disk_drive"4"

printf ${MAGENTA}"Mounting partitions...\n"
printf ${LIGHTGREEN}""

mount /dev/$disk_drive"3" /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/$disk_drive"1" /mnt/boot
mount /dev/$disk_drive"4" /mnt/home

printf ${MAGENTA}"Installing RankMirrors...\n"
printf ${LIGHTGREEN}""

pacman -Sy --noconfirm
pacman -S pacman-contrib --noconfirm
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
printf ${MAGENTA}"Searching for fastest mirrors...\n"
printf ${LIGHTGREEN}""
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
printf ${MAGENTA}"Installing Arch...\n"
printf ${LIGHTGREEN}""

pacstrap -i /mnt base base-devel linux linux-headers --noconfirm
genfstab -U -p /mnt >> /mnt/etc/fstab

cp post_chroot.sh /mnt
cp setup_kde.sh /mnt
clear
export disk_drive
arch-chroot /mnt ./post_chroot.sh
