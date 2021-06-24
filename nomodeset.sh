Set "nomodeset" Intel Driver Option for Linux Booting

Note: YGeneric Canonical Ubuntu media (some OEM Dell media) or 
      other Linux media does not boot to the live environment or 
      installer as usual and instead the system will hang or get stuck.

The newest kernels have moved the video mode setting into the kernel.
So all the programming of the hardware specific clock rates and registers on the video card happen in the kernel rather than in the X driver when the X server starts.
This makes it possible to have high resolution nice looking splash (boot) screens and flicker free transitions from boot splash to login screen. 
Unfortunately, on some cards this doesn't work properly and you end up with a black screen. 
Adding the nomodeset parameter instructs the kernel not to load video drivers and use BIOS modes instead until X is loaded.
    
• quiet - This option tells the kernel to NOT produce any output (a.k.a. Non verbose mode).
          If you boot without this option, you'll see lots of kernel messages such as drivers/modules activations, filesystem checks and errors. 
          Not having the quiet parameter may be useful when you need to find an error.

• splash - This option is used to start an eye-candy "loading" screen while all the core parts of the system are loaded in the background. 
           If you disable it and have quiet enable you'll get a blank screen.

• nomodeset - tells the kernel to not start video drivers until the system is up and running.

- With media attached, power on the system. 

- On the "GNU GRUB" bootloader screen? 

- When you see the option for "Ubuntu" as shown, press the "e" key on your keyboard.

- Type the "nomodeset" line option into the end of the line.

linux   /boot/vmlinuz-x.x.xx-generic.efi.signed root=UUID=xx ro quiet splash nomodeset $vt_handoff

-  Press "CTRL+X" keys and your system should boot to the normal installer or live environment like normal

-  Add nomodeset to GRUB_CMDLINE_LINUX_DEFAULT variable in /etc/default/grub file so it looks like this: 

GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nomodeset"

-  Run sudo update-grub 

OR

If the option to choose ubuntu does not show up, use the Live CD/bootable option!!!

Boot into ubuntu environment on a live CD with same distro and version.

sudo -i

mount /dev/filesystem (containing etc/ dev/ proc/ sys/) /mnt

edit file /etc/default/grub (add nomodeset!)

mount --bind /dev /mnt/dev
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys

chroot /mnt

update-grub

exit

umount -a

reboot



