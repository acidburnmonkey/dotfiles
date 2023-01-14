#!/bin/bash

## add more folders here -u== no overwrite duplicates ##

     # mouts the hhd
sudo mount /dev/sdb1 /media/2tb
sleep 2
    #the folders to backup 
cp -r -u /media/Toxic/calendar2022_generated.jpg /media/2tb/backup
cp -r -u /media/Toxic/camaro\ payments /media/2tb/backup
cp -r -u /media/Toxic/deck /media/2tb/backup
cp -r -u /media/Toxic/el\ tatoo /media/2tb/backup
cp -r -u /media/Toxic/Firmware\ 14.0.0.zip /media/2tb/backup
cp -r -u /media/Toxic/fitness /media/2tb/backup
cp -r -u /media/Toxic/Games /media/2tb/backup
cp -r -u /media/Toxic/important\ documents /media/2tb/backup
cp -r -u /media/Toxic/linuxbackup /media/2tb/backup
cp -r -u /media/Toxic/manuals /media/2tb/backup
cp -r -u /media/Toxic/Monero\ Wallet /media/2tb/backup
cp -r -u /media/Toxic/Notes /media/2tb/backup
cp -r -u /media/Toxic/orders /media/2tb/backup
cp -r -u /media/Toxic/programs /media/2tb/backup
cp -r -u /media/Toxic/video\ projects /media/2tb/backup
cp -r -u /media/Toxic/photos /media/2tb/backup

# Home backups
cp -r -u ~/scripts /media/2tb/backup
cp -r -u linux-comands.txt /media/2tb/backup

 #-moved
  
    # -l will unmount the hhd when not bussy 
sudo umount -l /media/2tb
echo "All Done"
