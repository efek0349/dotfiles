## jp
## ctrl+space
## F6 & F7 hiragana <-> katakana
export GTK_IM_MODULE="xim"
export QT_IM_MODULE="xim"
export XMODIFIERS="@im=SCIM"

export ENV=$HOME/.kshrc
#export GTK_USE_XFT=1
#export QT_XFT=true
#export GDK_SCALE=1.5
#export QT_SCALE_FACTOR=1.5
#export VDPAU_DRIVER=i965
#export LIBVA_DRIVER_NAME=vdpau
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
export GPG_TTY=$(tty)

## Browser shitz
export MOZ_USE_XINPUT2=1
export MOZ_ACCELERATED=1
export MOZ_WEBRENDER=1
export MOZ_DISABLE_PANGO=1
## WASM for Chromium
export ENABLE_WASM=1

# load .Xresources
[[ -f $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources

xset fp default
[[ -d /usr/local/share/fonts/inconsolata ]] && xset +fp /usr/local/share/fonts/inconsolata
[[ -d /usr/local/share/fonts/terminus ]] && xset +fp /usr/local/share/fonts/terminus
[[ -d /usr/local/share/fonts/mensch ]] && xset +fp /usr/local/share/fonts/mensch
[[ -d /usr/local/share/fonts/spleen ]] && xset +fp  /usr/local/share/fonts/spleen
xset fp rehash

# Disable core dumps
ulimit -Sc 0
#$HOME/bin/new_mail_sound.sh &
$HOME/bin/multiple-tmux &
$HOME/bin/dzen-start &

xsetroot -solid black &
xset -dpms
xset s off

# increase mouse acceleration
xset m 3
xset r rate 300 45

# use caps lock as ctrl key
setxkbmap -option ctrl:nocaps

if [[ -x $(command -v urxvtd) ]];then
	urxvtd -q -o -f &
fi

# set background
sh $HOME/.fehbg

#xidle -program '/usr/X11R6/bin/xlock' -timeout 60 &
#xconsole -geometry -891+730 &
polybar -c ~/.config/polybar/mockup &

## DBus
#if [ -x /usr/local/bin/dbus-launch -a -z "${DBUS_SESSION_BUS_ADDRESS}" ]; then
#        eval `dbus-launch --sh-syntax --exit-with-x11`
#fi

/usr/bin/doas /usr/sbin/rcctl restart smtpd &
#/usr/local/bin/scim -d &
/home/efek/bin/www-ramdisk &
exec dbus-launch --exit-with-session --sh-syntax cwm
