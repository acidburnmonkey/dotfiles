DUMP PROCESS

dconf dump /org/cinnamon/ > cinnamon.dconf
dconf dump /org/nemo/ > nemo.dconf
dconf dump /org/gtk/ > gtk.dconf
dconf dump /org/gnome/ > gnome.dconf

LOAD PROCESS

dconf load /org/cinnamon/ < cinnamon.dconf
dconf load /org/nemo/ < nemo.dconf
dconf load /org/gtk/ < gtk.dconf
dconf load /org/gnome/ < gnome.dconf


Each of them in a a batch file, make it executable and dump on one pc and load on an another.