## jp
## ctrl+space
## F6 & F7 hiragana <-> katakana
export GTK_IM_MODULE="xim"
export QT_IM_MODULE="xim"
export XMODIFIERS="@im=SCIM"

export ENV=$HOME/.kshrc
export GTK_USE_XFT=1
export QT_XFT=true
#export GDK_SCALE=1.5
#export QT_SCALE_FACTOR=1.5
export MOZ_DISABLE_PANGO=1
export VDPAU_DRIVER=i965
export LIBVA_DRIVER_NAME=vdpau
export RXVT_SOCKET='/tmp/urxvt-socket'
export LANG=en_US.UTF-8
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_ALL=en_US.UTF-8
export TERMCMD=urxvtc

## Browser shitz
export MOZ_USE_XINPUT2=1
export MOZ_ACCELERATED=1
export MOZ_WEBRENDER=1
## WASM for Chromium
export ENABLE_WASM=1

if [[ -x $(command -v urxvtd) ]];then
	urxvtd -q -o -f &
fi

# Disable core dumps
#
ulimit -c 0

# load .Xresources
[[ -f $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources

xset fp default
[[ -d /usr/local/share/fonts/inconsolata ]] && xset +fp /usr/local/share/fonts/inconsolata
[[ -d /usr/local/share/fonts/terminus ]] && xset +fp /usr/local/share/fonts/terminus
[[ -d /usr/local/share/fonts/spleen ]] && xset +fp  /usr/local/share/fonts/spleen
xset fp rehash

$HOME/bin/new_mail_sound.sh &
$HOME/bin/multiple-tmux &
$HOME/bin/dzen-start &

xsetroot -solid black &
xset -dpms
xset s off
xset -b #Bell off
# increase mouse acceleration
xset m 3
xset r rate 350 45

# use caps lock as ctrl key
setxkbmap -option ctrl:nocaps

/usr/bin/doas /usr/sbin/rcctl restart smtpd
# set background
sh $HOME/.fehbg

#xidle -program '/usr/X11R6/bin/xlock' -timeout 60 &
#xconsole -geometry -891+730 &
#exec cwm
polybar -c ~/.config/polybar/mockup &

## DBus
#if [ -x /usr/local/bin/dbus-launch -a -z "${DBUS_SESSION_BUS_ADDRESS}" ]; then
#        eval `dbus-launch --sh-syntax --exit-with-x11`
#fi

/usr/local/bin/scim -d &
exec dbus-launch --exit-with-session --sh-syntax cwm
