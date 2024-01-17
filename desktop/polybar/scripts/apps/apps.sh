#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Favorite Applications

# Import Current Theme
source "$HOME"/.config/polybar/scripts/apps/theme.bash
theme="$type/$style"

# Theme Elements
prompt='Applications'
mesg="Installed Packages : `pacman -Q | wc -l` (pacman)"

if [[ ( "$theme" == *'type-1'* ) || ( "$theme" == *'type-3'* ) || ( "$theme" == *'type-5'* ) ]]; then
	list_col='1'
	list_row='6'
elif [[ ( "$theme" == *'type-2'* ) || ( "$theme" == *'type-4'* ) ]]; then
	list_col='6'
	list_row='1'
fi

# CMDs (add your apps here)
term_cmd='lightdm-settings'
file_cmd='/home/mahalo/vitrual/kali-linux/kali-linux-2023.1-vmware-amd64.vmx'
text_cmd='flatpak run com.jetbrains.CLion'
web_cmd='firefox -no-remote -P School'
music_cmd='flatpak run com.discordapp.Discord'
setting_cmd='steam'

# Options
layout=`cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2`
if [[ "$layout" == 'NO' ]]; then
	option_1=" Login Window <span weight='light' size='small'></span>"
	option_2=" Kali <span weight='light' size='small'></span>"
	option_3=" Clion <span weight='light' size='small'></span>"
	option_4=" School<span weight='light' size='small'></span>"
	option_5=" Discord <span weight='light' size='small'></span>"
	option_6=" Steam <span weight='light' size='small'></span>"
else
	option_1=" "
	option_2=" "
	option_3=" "
	option_4=" "
	option_5=" "
	option_6=" "
fi

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
}

# Execute Command
run_cmd() {
	polkit_cmd="pkexec env PATH=$PATH DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY"
	if [[ "$1" == '--opt1' ]]; then
		${polkit_cmd} ${term_cmd}
	elif [[ "$1" == '--opt2' ]]; then
		${polkit_cmd} ${file_cmd}
	elif [[ "$1" == '--opt3' ]]; then
		${text_cmd}
	elif [[ "$1" == '--opt4' ]]; then
		${web_cmd}
	elif [[ "$1" == '--opt5' ]]; then
		${music_cmd}
	elif [[ "$1" == '--opt6' ]]; then
		${setting_cmd}
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
    $option_6)
		run_cmd --opt6
        ;;
esac
