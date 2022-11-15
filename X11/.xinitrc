#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap


if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi


monitor=`xrandr | grep 'HDMI-A-0 connected'`
if [ ! -z  "$monitor" ]; then
    # make external monitor the primary
    xrandr --output HDMI-A-0 --primary --mode 3840x2160 --right-of eDP --output eDP --off
    xrandr --output HDMI-A-0 --set TearFree on
    sed -i -E 's/^Xft.dpi:\ 96/Xft.dpi:\ 192/' ~/.Xresources
else
    xrandr --output eDP --set TearFree on
    xrandr --dpi 96
    sed -i -E 's/^Xft.dpi:\ 192/Xft.dpi:\ 96/' ~/.Xresources
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

xsetroot -cursor_name left_ptr
xbanish &
numlockx &
exec bspwm
