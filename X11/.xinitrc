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

cp ~/.config/bspwm/bspwmrc.in ~/.config/bspwm/bspwmrc

monitor=`xrandr | grep 'HDMI-A-0 connected'`
hidpi=`xrandr -q | grep '3840x2160'`

if [ ! -z  "$monitor" ]; then
    if [ ! -z  "$hidpi" ]; then
        xrandr --output HDMI-A-0 --primary --mode 3840x2160 --right-of eDP --output eDP --off
        xrandr --output HDMI-A-0 --set TearFree on
        sed -i "s/%bar_dpi%/uhd/g" ~/.config/bspwm/bspwmrc
        sed -i "s/%top_padding%/52/g" ~/.config/bspwm/bspwmrc
        sed -i "s/%border_width%/4/g" ~/.config/bspwm/bspwmrc
        sed -i -E 's/^Xft.dpi:\ 96/Xft.dpi:\ 192/' ~/.Xresources
    else
        xrandr --output HDMI-A-0 --primary --mode 1920x1080 --right-of eDP --output eDP --off
        xrandr --output HDMI-A-0 --set TearFree on
        sed -i "s/%bar_dpi%/hd/g" ~/.config/bspwm/bspwmrc
        sed -i "s/%top_padding%/26/g" ~/.config/bspwm/bspwmrc
        sed -i "s/%border_width%/2/g" ~/.config/bspwm/bspwmrc
        sed -i -E 's/^Xft.dpi:\ 192/Xft.dpi:\ 96/' ~/.Xresources
    fi
else
    xrandr --output eDP --set TearFree on
    xrandr --dpi 96
    ln -s ~/.config/bspwm/hd ~/.config/bspwm/bspwmrc
    sed -i -E 's/^Xft.dpi:\ 192/Xft.dpi:\ 96/' ~/.Xresources
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

xsetroot -cursor_name left_ptr
xbanish &
numlockx &
exec bspwm
