# Arch Linux Installation script
#### Based on Mutahar Anas guide
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
- Use gdisk and cgdisk to create partitions like that:
- part1 boot partition
- part2 swap partition
- part3 root partition
- part4 home partition

- Clone this repository
```sh
git clone https://github.com/Awnrt/arch
```
```sh
cd arch
./setup_arch.sh
```
