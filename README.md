# Arch Linux Installation script
#### Based on Mutahar Anas guide
**Script doesn't install DE or WM**
**It is basically for NVIDIA/Intel hardware**
**If you have AMD you need to change a couple of things**
SomeOrdinaryGamers <https://www.youtube.com/c/SomeOrdinaryGamers>
Arch Linux guide <https://www.youtube.com/watch?v=H1ieRvLRxP0>
#### How to use:

- Boot from flashdrive
- Install git
```sh
sudo pacman -Sy git
```
- Clone this repository
```sh
git clone https://github.com/Awnrt/arch
```
- Use gdisk and cgdisk to create partitions
- Edit installPart1.sh with any editor. You need to change all disk labels in script to yours. (For example nvme1n1p1 = sda1, nvme1n1p2 = sda2, etc.)
- Make script executable
```sh
sudo chmod +x installPart1.sh
./installPart1.sh
```
- After execution of installPart1.sh you need to install git and clone repository again
- You have to find line in installPart2.sh that contains
```sh
echo "options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/nvme1n1p3) rw" nvidia-drm.modeset=1 intel_iommu=on
```
-  and change nvme1n1p3 to your root partition
-  If you don't want to use system for virtual machines, then delete "intel_iommu=on"
-  By default script creating user named "jimbob"
- Make script executable
```sh
sudo chmod +x installPart2.sh
./installPart2.sh
```
- After execution of installPart2.sh you need to edit /etc/mkinitcpio.conf to add nvidia modules
```sh
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```
- Reboot
