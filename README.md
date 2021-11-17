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
- Clone this repository
```sh
git clone https://github.com/Awnrt/arch
```
- Use gdisk and cgdisk to create partitions
```sh
cd arch
./setup_arch.sh
```
