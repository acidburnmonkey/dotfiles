#!/bin/sh
#
# This script is part of the TexMaths package
# http://roland65.free.fr/texmaths
#
# Roland Baudin (roland65@free.fr)

# Function used to generate system log
SystemLog(){
    syslog=${UserDir}System.log
    uname -a > "$syslog"
    echo "" >> "$syslog"
    echo "osType=$osType" >> "$syslog"
    echo "cpuType=$cpuType" >> "$syslog"
    echo "" >> "$syslog"
    echo "PATH=$PATH" >> "$syslog"
    echo "" >> "$syslog"
}

# Definition of PATH and binary paths
cpu=$(uname -p)
mac=$(uname -m)
sys=$(uname -s)
[ "$cpu" = "powerpc" -o "$mac" = "ppc" ] && cpuType=ppc || cpuType=i386 
[ "$sys" = "Darwin" ] && osType=MacOSX || osType=Linux 
UserDir="/home/mahalo/.config/libreoffice/4/user/TexMaths/"
PkgDir="/home/mahalo/.config/libreoffice/4/user/uno_packages/cache/uno_packages/lu115471551y1.tmp_/TexMaths-0.52.oxt/"

PATH="${PkgDir}bin/${osType}${cpuType}:$PATH"
PATH="/usr/bin/:$PATH"
export PATH


# Process the options
ext=$1
dpi=$2
Trans="$3"
tmpPath="$4"
filename=tmpfile
compiler=$5

# Generate system log
SystemLog

# Go to the tmp directory
if [ "$tmpPath" != "" ]; then
    [ ! -d "$tmpPath" ]  && mkdir -p "$tmpPath"
    cd "$tmpPath"
fi

# Remove old files but not the tex file
mv ${filename}.tex tmptex.tex
rm ${filename}*.* >/dev/null 2>&1
mv tmptex.tex ${filename}.tex

# Compile using latex
if [ "${compiler}" = "latex" ]; then

    "/usr/bin/latex" -shell-escape -interaction=nonstopmode ${filename}.tex  > ${filename}.out

    if [ -f ${filename}.dvi ]; then

        # Conversion of the DVI file to a SVG image
        if [ "${ext}" = "svg" ]; then
            "/usr/bin/dvisvgm" -n1 --exact -e ${filename}.dvi > ${filename}.dat 2>&1
        fi



    fi

fi

# Compile using xelatex
if [ "${compiler}" = "xelatex" ]; then

    "/usr/bin/xelatex" -no-pdf -shell-escape -interaction=nonstopmode ${filename}.tex  > ${filename}.out

    # Conversion of the XDV file to a SVG image
    if [ -f ${filename}.xdv ]; then
        "/usr/bin/dvisvgm" -n1 --exact -e ${filename}.xdv > ${filename}.dat 2>&1
    fi

fi

# Compile using lualatex
if [ "${compiler}" = "lualatex" ]; then

    "/usr/bin/dvilualatex" -shell-escape -interaction=nonstopmode ${filename}.tex  > ${filename}.out

    if [ -f ${filename}.dvi ]; then

        # Conversion of the DVI file to a SVG image
        if [ "${ext}" = "svg" ]; then
            "/usr/bin/dvisvgm" -n1 --exact -e ${filename}.dvi > ${filename}.dat 2>&1
        fi



    fi

fi
