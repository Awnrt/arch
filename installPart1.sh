#Making filesystem
mkfs.fat -F32 /dev/nvme1n1p1
mkswap /dev/nvme1n1p2
swapon /dev/nvme1n1p2
mkfs.ext4 /dev/nvme1n1p3
mkfs.ext4 /dev/nvme1n1p4
#Mounting
mount /dev/nvme1n1p3 /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/nvme1n1p1 /mnt/boot
mount /dev/nvme1n1p4 /mnt/home
#Rankmirrors
pacman -Sy
pacman -S pacman-contrib
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
#Arch install
pacstrap -i /mnt base base-devel linux linux-headers
genfstab -U -p /mnt >> /mnt/etc/fstab
arch-chroot /mnt
