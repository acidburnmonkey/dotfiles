#!/bin/bash



#call this scritpt as:
# For volume
#dunstthree.sh vup
#dunstthree.sh vdonw
#dunstthree.sh mute
#  For Brightness
#dunstthree.sh bup
#dunstthree.sh bdown


###### Volume Notifications ###
function get_volume {
    amixer  get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function send_notification_volume {
    
    declare -i volume=`get_volume`
    progres=$(seq -s "─" $(($volume/5)) | sed 's/[0-9]//g')

## Gets the volume icon for volume
    if [ $volume -ge  55 ]  
    then
       local  icon=~/.config/i3/dunstthree/icons/audio-volume-high.svg 
         
    else
        local icon=~/.config/i3/dunstthree/icons/audio-volume-medium.svg 
    fi

#Generated notification
     dunstify "$volume" -h int:value:"$volume" -h string:synchronous:"$progres" -t 2000 -i $icon   --replace=555

}

function check_mute {
   amixer  get Master | awk 'NR== 6 {print $6}'   
}

function send_notification_mute {
    local  Pass=`check_mute`
    declare -i volume=`get_volume`

    if [ $Pass = "[on]" ]; then
         dunstify "Unmuted"  -h int:value:"$volume" -h string:synchronous:"$progres" -t 2000 -i ~/.config/i3/dunstthree/icons/audio-volume-medium.svg --replace=555
     else
         dunstify "Muted"  -t 2000 -i ~/.config/i3/dunstthree/icons/audio-volume-muted.svg --replace=555
    fi
}


# Brightness

function get_brightness {
  xbacklight -get | cut -d '.' -f 1
}


function send_notification_bright {
    
     declare -i brightness=`get_brightness`
     progres=$(seq -s "─" $(($brightness/5)) | sed 's/[0-9]//g')

     dunstify "$brightness" -h int:value:"$brightness" -h string:synchronous:"$progres" -t 2000 -i ~/.config/i3/dunstthree/icons/brightness.png   --replace=555

}


### Calls ###
case $1 in
    vup)
	# Set the volume on (if it was muted)
	amixer  sset Master 5%+ > /dev/null
	send_notification_volume
	;;
    vdown)
	amixer  set Master on > /dev/null
	amixer  sset Master 5%- > /dev/null
	send_notification_volume
	;;
    mute)
    	# Toggle mute
	amixer  set Master 1+ toggle > /dev/null
    send_notification_mute
	;;
    bup)
         xbacklight -inc 5
        send_notification_bright
        ;;
    bdown)
         xbacklight -dec 5
        send_notification_bright
        ;;

esac
