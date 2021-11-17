LIGHTGREEN='\033[1;32m'
LIGHTRED='\033[1;91m'
WHITE='\033[1;97m'
MAGENTA='\033[1;35m'
CYAN='\033[1;96m'

printf ${LIGHTGREEN}"Making filesystem...\n"
#Making filesystem
mkfs.fat -F32 /dev/nvme1n1p1
mkswap /dev/nvme1n1p2
swapon /dev/nvme1n1p2
mkfs.ext4 /dev/nvme1n1p3
mkfs.ext4 /dev/nvme1n1p4

printf ${LIGHTGREEN}"Mounting partitions...\n"
#Mounting
mount /dev/nvme1n1p3 /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/nvme1n1p1 /mnt/boot
mount /dev/nvme1n1p4 /mnt/home

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
