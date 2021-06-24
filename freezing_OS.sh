Prone to new Linux installation, system is randomly freezing
 (OS version > 18.04 LTS: Graphics card issues)


-  Add following lines to /etc/modprobe.d/nvidia-graphics-drivers.conf 

blacklist nouveau
blacklist lbm-nouveau
alias nouveau off
alias lbm-nouveau off

- Add nomodeset to GRUB_CMDLINE_LINUX_DEFAULT variable in /etc/default/grub file so it looks like this: 

GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nomodeset"

- Run sudo update-grub 
- Reboot 

- Add ppa repository: 
sudo add-apt-repository ppa:graphics-drivers/ppa

- Switch to runlevel 3 by typing sudo init 3. If you're seeing black screen after that switch to tty/1 with CTRL+ALT+F1  
- Install the driver 
root@hostname-x-pcxx:# ubuntu-drivers devices
== /sys/devices/pci0000:00/0000:00:03.1/0000:0b:00.0 ==
modalias : pci:v000010DEd00002187sv00001462sd00003852bc03sc00i00
vendor   : NVIDIA Corporation
model    : TU116 [GeForce GTX 1650 SUPER]
driver   : nvidia-driver-450 - third-party non-free
driver   : nvidia-driver-450-server - distro non-free
driver   : nvidia-driver-460-server - distro non-free
driver   : nvidia-driver-460 - third-party non-free recommended
driver   : xserver-xorg-video-nouveau - distro free builtin

- Install recommended (different from one system to another)

sudo apt-get install nvidia-driver-460

- Reboot 
