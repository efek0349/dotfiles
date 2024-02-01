# $OpenBSD: ksh.kshrc,v 1.32 2018/05/16 14:01:41 mpf Exp $
#
# sh/ksh initialization
PATH=/root/bin:/root/.local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games:.
if [[ $(id -u) == 1000 ]];then
  if [[ -x $(command -v ruby) ]];then
	PATH="$PATH:$(ruby -e 'print Gem.user_dir')/bin"
  fi
fi
export GEM_HOME=$HOME/.gem
#################################################################
bind -m '^L'=clear'^J'
#################################################################
[ -n "$TMUX" ] && export TERM=tmux-256color
#################################################################
# Disable core dumps
#
ulimit -c 0

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

if [[ -f "/root/.config/dir_colours" ]]; then
 if [[ -x $(command -v gdircolors) ]];then
  eval $(gdircolors -b "/root/.config/dir_colours")
 fi
fi
#################################################################
export LANG=en_US.UTF-8
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_ALL=en_US.UTF-8

export PATH HOME TERM
export HISTFILE=$TMPDIR/.ksh_history
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
#export GREP_COLOR='mt=30;43'
export GREP_COLOR='30;43'
export LESSCHARSET=utf-8
export LESS='-F -g -i -M -R -S -w -X -z-4'
export USE_CCACHE=1
export GOPATH="/root/code/gopath"
export PYTHONSTARTUP="/root/.pythonrc"
export PYTHONDOCS="/usr/local/share/doc/python2.7/html"
export PROJECT_HOME="/root/code/python"
export VIRTUALENVWRAPPER_PYTHON="/usr/local/bin/python3.6"
#export PKG_CACHE="/var/db/Packages/snapshots/`arch -s`/" #  mkdir -p $PKG_CACHE
# Home directory for virtualenvwrapper
export WORKON_HOME="/root/.virtualenvs"
# color man-pages persistently
if [[ -x $(command -v most) ]];then
export PAGER='most'
fi
###################################################
if [ -f /usr/local/share/GNUstep/Makefiles/GNUstep.sh ];then
. /usr/local/share/GNUstep/Makefiles/GNUstep.sh
fi
if [ -f /root/.git-prompt-ksh.sh ];then
. /root/.git-prompt-ksh.sh
fi
if [ -f /root/.kshrc.alias ];then
. /root/.kshrc.alias
fi

if [ -f $TMPDIR/keychain-ssh_agent ];then
. $TMPDIR/keychain-ssh_agent
fi
###################################################
# ksh completions https://github.com/qbit/dotfiles
set -A complete_adb -- start-server kill-server devices push pull shell reboot reboot-bootloader root
set -A complete_rcctl_1 -- disable enable get ls order set restart start stop
set -A complete_rcctl_2 -- $(rcctl ls all)
set -A complete_signify_1 -- -C -G -S -V
set -A complete_signify_2 -- -q -p -x -c -m -t -z -e
set -A complete_signify_3 -- -p -x -c -m -t -z
set -A complete_make_1 -- install clean repackage reinstall search makesum show=
set -A complete_gpg2 -- --refresh --receive-keys --armor --clearsign --sign --list-key --decrypt --verify --detach-sig
set -A complete_git_1 -- pull push clone checkout status commit
set -A complete_git_2 -- -m
set -A complete_kill_1 -- -9 -HUP -INFO -KILL -TERM
set -A complete_xrdb_1 -- -merge
set -A complete_sudo_1 --  $(/bin/ls `echo $PATH | sed 's/:/ /g'`|sed 's/.*\://;s/\*//g;s/\@//g' | xargs)
set -A complete_sumsignify_1 -- $(/bin/ls -1 /etc/signify)
####################################################

battery()
{
    local bat=""
    local level=""
    local charg=""
    bat=$(apm -b 2>/dev/null)
    if [ -n "$bat" -a "$bat" -lt "4" ]; then
        level=$(apm -l 2>/dev/null)
        charg=$(apm -a 2>/dev/null)
        if [ -n "$charg" -a "$charg" -eq "1" ]; then
            #charging green
            printf "\033[01;32m$level%%\033[00m"
        else
            if [ "$level" -lt "20" ]; then
                #print red
                print -- "\033[01;31m$level%\033[00m"
            else 
                #print blue
                print -- "\033[01;34m$level%\033[00m"
            fi
        fi
    else
        #no battery
        print -- ""
    fi
}

case $(id -u) in
   0) export PS1='$(battery) \w$(__git_ps1 " (%s)")\\n\033[0;31m# \033[0m' ;;
   *) export PS1='$(battery) \w$(__git_ps1 " (%s)")\\n\033[0;33m$ \033[0m' ;;
esac
girl
