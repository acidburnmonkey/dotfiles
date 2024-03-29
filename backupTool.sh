#!/bin/bash


destination=mal0@192.168.1.146:/mnt/2tb/backup
getkey="ssh -i .ssh/localserv"
destination2=mal0@192.168.1.146:/mnt/2tb/windows_backup


case $1 in
    #old script
    -o) 

    ## add more folders here -u== no overwrite duplicates ##
        echo "Deprecated option use -s"
         # Home backups
        # cp -r -u ~/scripts $destination
        # cp -r -u linux-comands.txt $destination
        # cp -r -u ~/PycharmProjects $destination

;;
    
    -s)
         rsync --info=progress2 -aA --delete  --exclude={'Cemu','iso'} /media/toxic $destination2
         rsync --info=progress2 -aA --delete  --exclude={'.*','Desktop','Downloads','Documents','boxshare','repos'} ~/ $destination 

         # rsync --info=progress2 -aA --delete -e $getkey ~/Nextcloud $destination 
         # rsync --info=progress2 -aA --delete -e $getkey ~/python $destination 
         # rsync --info=progress2 -aA --delete -e $getkey ~/scripts $destination 
         # rsync --info=progress2 -aA --delete -e $getkey ~/stuff $destination 
         # rsync --info=progress2 -aA --delete -e $getkey ~/programs $destination 
         # rsync --info=progress2 -aA --delete -e $getkey ~/linux-comands.txt $destination 
        
         # -e started conpyging private key Dont use anymore

        ;;
        
    *)
        echo "No option selected -s (sync) or -o (old)"
        ;;  
 esac


echo "All Done"
