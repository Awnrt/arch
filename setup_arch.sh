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

printf ${LIGHTGREEN}"Making filesystem...\n"
#Making filesystem
mkfs.fat -F32 /dev/$disk_drive"1"
mkswap /dev/$disk_drive"2"
swapon /dev/$disk_drive"2"
mkfs.ext4 /dev/$disk_drive"3"
mkfs.ext4 /dev/$disk_drive"4"

printf ${LIGHTGREEN}"Mounting partitions...\n"
#Mounting
mount /dev/$disk_drive"3" /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/$disk_drive"1" /mnt/boot
mount /dev/$disk_drive"4" /mnt/home

printf ${LIGHTGREEN}"Searching for fastest mirrors...\n"
#Rankmirrors
pacman -Sy
pacman -S pacman-contrib
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
#Arch install
pacstrap -i /mnt base base-devel linux linux-headers
genfstab -U -p /mnt >> /mnt/etc/fstab

cp post_chroot.sh /mnt
arch-chroot /mnt
