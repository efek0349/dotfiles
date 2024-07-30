function fish_greeting
end
command echo "            _.-|-/\-._     "
command echo "         \-'          '-.   " 
command echo "        /    /\    /\    \/          _____                 ____   _____ _____  "
command echo "      \/  <    .  >  ./.  \/        / ___ \               |  _ \ / ____|  __ \ "
command echo "  _   /  <         > /___\ |.      / /  / /___  ___  ____ | |_) | (___ | |  | |"
command echo ".< \ /  <     /\    > ( #) |#)    / /  / / __ \/ _ \/ __ \|  _ < \___ \| |  | |"
command echo "  | |    <       /\   -.   __\   / /__/ / /_/ /  __/ / / /| |_) |____) | |__| |"
command echo "   \   <  <   V      > )./_._)|  \_____/ .___/\___/_/ /_/ |____/|_____/|_____/ "
command echo "  .)/\   <  <  .-     /  \_'_))-..    /_/"
command echo "      \  <   ./  /  > >      /._./"
command echo "      /\   <  '-' >    >    /   "
command echo "        '-._ < v    >   _.-'"
command echo "         '/ '-.__\/__.-' \'"
command echo ""
command sysctl | grep "kern.version" && sysctl | grep "deraadt"
command echo ""
command sysctl hw.disknames
command sysctl | grep "cpu0.temp0"
command echo ""
command neofetch uptime memory battery

alias hints="less ~/.config/fish/config.fish"
alias hcat='highlight -O ansi --force'
alias sshprx='export http_proxy=socks5://127.0.0.1:3333 https_proxy=socks5://127.0.0.1:3333'
alias torprx='export http_proxy=socks5://127.0.0.1:9150 https_proxy=socks5://127.0.0.1:9150'
alias unprx='unset http_proxy https_proxy'
alias srm='gshred -uzfv --random-source=/dev/random -n'
alias q='exit'
alias qe='qemu-system-x86_64 -enable-kvm'
alias envpy3='workon python3'
alias du='du -hs'
alias gdb='gdb -n'
#alias gpg='gpg2'
alias gdd='gdd status=progress'
alias init-tor='torsocks w3m http://kpvz7ki2v5agwt35.onion -no-cookie -graph -N'
alias attacks1='iridium --enable-unveil --enable-pledge --incognito http://map.norsecorp.com/'
alias attacks2='iridium --enable-unveil --enable-pledge --incognito http://www.digitalattackmap.com/'
alias sha256control='sha256 -c  < ~/code/systemsums.txt |grep FAILED'
alias mg='mg -n'
alias vime='gvim -u /home/$LOGNAME/.vimencrypt -x'
alias gvime='gvim -u /home/$LOGNAME/.vimencrypt -x'
alias rcp='rsync --progress'
alias ytdown='youtube-dl --no-mtime --restrict-filenames'
alias ytmp3='youtube-dl -x --audio-format mp3'
alias hr='printf $(printf "\e[$(gshuf -i 91-97 -n 1);1m%%%ds\e[0m\n" $(tput cols)) | tr " " ='
alias disks='echo "`hr`";echo "______ d i s k . u s a g e"; echo "_____________________________________________________ _ _ "; df -h;echo "`hr`"'
alias wget='wget -o "$TMPDIR"/wget-log.txt --hsts-file="$TMPDIR"/wget-hist.txt -c'
alias neo='neofetch --color_blocks off --w3m /home/$LOGNAME/Pictures/OpenBSDpuffy.png'
alias w3m='w3m -no-cookie -graph -N'
alias gld='git log --topo-order --stat --patch --full-diff'
alias ssh-agdres='eval `ssh-agent -s`;ssh-add $HOME/.ssh/git_rsa'
alias upssh_agent='. $TMPDIR/keychain-ssh_agent'
alias info='pinfo'
alias speaktr='espeak -v tr'
alias screen='screen -q'
alias fix='reset; stty sane; tput rs1; clear; echo -e "\033c"'
alias httpsrv3='python3 -m http.server'
alias httpsrv2='python -m SimpleHTTPServer'
alias q32='qemu-system-i386 -m 650 -net nic -net user'
alias q64='qemu-system-x86_64 -m 650 -net nic -net user'
alias adump='mpv --untimed --vd=dummy -vo null -ao pcm'
alias usb3='doas /usr/local/sbin/mount.exfat -o uid=1000 /dev/sd3i /mnt/usb/'
alias usb2='doas /usr/local/sbin/mount.exfat -o uid=1000 /dev/sd2i /mnt/usb/'
alias nousb='doas /sbin/umount /mnt/usb'
alias nomtp='doas /sbin/umount /mnt/mtp'
alias pkg_add='doas /usr/sbin/pkg_add'
alias ports.sh='doas /usr/local/bin/ports.sh'
alias wget="wget -U 'noleak'"
alias curl="curl --user-agent 'noleak'"
alias dateup="doas /usr/sbin/rdate -ncv pool.ntp.org"
alias nmap="doas /usr/local/bin/nmap"
alias tsharkwifi="doas /usr/local/bin/tshark -i iwm0"
alias kali="ssh root@100.64.1.3"
alias obsd="ssh root@100.64.2.3"
alias vmk="vmctl status"
alias vmkk="vmctl start 1"
alias vmko="vmctl start 2"
alias vmkkc="vmctl console 1"
alias vmkoc="vmctl console 2"
alias su="su -"
alias phone="simple-mtpfs --device 1 /mnt/mtp -o uid=1000 -o gid=1000 -o allow_other"
alias screenshotf="import -window root"
alias screenshotk="import"
alias cp="cp -v"
alias mv="mv -v"
alias rm="rm -v"
alias ll='ls++ --potsf -a'
alias ifconfig='grc ifconfig'
alias netstat='grc netstat'
alias traceroute='grc traceroute'
alias diff='grc diff'
alias df='grc df'
alias ping='grc ping'
alias ps='grc ps'
alias mount='grc mount'
alias dig='grc dig'
alias make='grc make'
alias gmake='grc gmake'
alias configure='grc ./configure'
alias nmap='grc nmap'
alias du='grc du'
alias w='grc w'
alias grep='ggrep --color=always'
alias ls='gls -hF --color=auto --group-directories-first'
alias la='gls -a --color=auto --group-directories-first'
alias sl='ls'
alias l='la'
alias wifa='doas /sbin/ifconfig re0 lladdr random up;doas /usr/sbin/rcctl restart dnscrypt_proxy unbound'
alias wifi='doas /sbin/ifconfig iwm0 lladdr random up ;doas /bin/sh /etc/wiconfig -s iwm0'
