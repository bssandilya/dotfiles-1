# ~/.bashrc: executed by bash(1) for non-login shells.

# if not running interactively, don't do anything
[ -z "$PS1" ] && return

COLOR_BLACK="\[\033[0;30m\]"
COLOR_BLUE="\[\033[0;34m\]"
COLOR_GREEN="\[\033[0;32m\]"
COLOR_CYAN="\[\033[0;36m\]"
COLOR_RED="\[\033[0;31m\]"
COLOR_PURPLE="\[\033[0;35m\]"
COLOR_BROWN="\[\033[0;33m\]"
COLOR_LIGHT_GRAY="\[\033[0;37m\]"
COLOR_DARK_GRAY="\[\033[1;30m\]"
COLOR_LIGHT_BLUE="\[\033[1;34m\]"
COLOR_LIGHT_GREEN="\[\033[1;32m\]"
COLOR_LIGHT_CYAN="\[\033[1;36m\]"
COLOR_LIGHT_RED="\[\033[1;31m\]"
COLOR_LIGHT_PURPLE="\[\033[1;35m\]"
COLOR_YELLOW="\[\033[1;33m\]"
COLOR_WHITE="\[\033[1;37m\]"
COLOR_CLEAR="\[\033[0m\]"


# Bash-specific options

# Don't add this shit to history
export HISTIGNORE="sudo shutdown:sudo re:bg:fg"
# Ignore duplicates, and commands that start with a space
export HISTCONTROL=ignoredups:ignorespace
# Remember a lot.
export HISTSIZE=5000
export HISTFILESIZE=5000
# Store timestamps
export HISTTIMEFORMAT='%F %T '
# Append to history file, don't overwrite.
shopt -s histappend
# don't try to complete on nothing
shopt -s no_empty_cmd_completion
# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
# Uh, I think this is actually fucking shit up.
# shopt -s checkwinsize

if [ -d "${HOME}/bin" ]; then
    export PATH=${HOME}/bin:$PATH
fi
if [ -d "/var/lib/gems/1.8/bin" ]; then
    export PATH=/var/lib/gems/1.8/bin:$PATH
fi
if [ -d "${HOME}/.gem/ruby/1.8/bin" ]; then
    export PATH=${HOME}/.gem/ruby/1.8/bin:$PATH
fi
if [[ "$LC_ALL" == "" ]]; then
    # Shut the fuck up, perl on prgmr
    export LC_ALL="C"
fi



PS1=""
PS1_DATE=1
PS1_USER=1
PS1_HOST=1
PS1_PATH=1
PS1_NEWLINE=1
# 23:00:09 <@fancybone> hey, what's the last character of a bash prompt called
# 23:00:18 <@brett_h> dicks
# 23:00:23 <@fancybone> dicks it is
PS1_DICKS="\n# "
PS1_DATE_COLOR=$COLOR_LIGHT_BLUE
PS1_USER_COLOR=$COLOR_LIGHT_BLUE
PS1_HOST_COLOR=$COLOR_LIGHT_BLUE
PS1_PATH_COLOR=$COLOR_LIGHT_CYAN

alias grep='grep --color=auto'

# for crontabs, git, etc.
export EDITOR=vim


###################
# OS specific stuff
###################
case $OSTYPE in
    darwin*)
        # OS X
        alias ls='ls -G'

        # Optional bash_completion
        if [ -f `brew --prefix`/etc/bash_completion ]; then
            alias bash_completion='source `brew --prefix`/etc/bash_completion'
            #source `brew --prefix`/etc/bash_completion
        fi

        # Use OS X emacs
        if [ -d /Applications/Emacs.app/Contents/MacOS/bin/ ]; then
            export PATH=/Applications/Emacs.app/Contents/MacOS/bin/:$PATH
            # Prevent Emacs from being launched twice;
            # and from launching from /usr/bin/emacs
            # and fuck it, this is what I mean all the time anyway.
            alias emacs='emacsclient -c -n'
            EDITOR="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c"
        fi

        # Write commands to history as soon as they are typed
        export PROMPT_COMMAND='history -a'

    ;;
    *)
        # Everything else
        alias ls='ls --color=auto'
    ;;
esac

# This is mostly a placeholder.
case $MACHTYPE in
    *redhat-linux-gnu)
        # RedHat machine. Whatever.
    ;;
    *)
        # Everything else;
    ;;
esac


#####################
# Host specific stuff
#####################
case $HOSTNAME in
    "vodkamat.netomat.net" | "austin" | "addison")
        # My Macbook
        #TODO this hostname is temporary, damnit, this thing should be called "austin"

        # Prompt
        PS1_DATE_COLOR=$COLOR_LIGHT_GREEN
        PS1_USER_COLOR=$COLOR_LIGHT_GREEN
        PS1_HOST_COLOR=$COLOR_LIGHT_GREEN
        PS1_PATH_COLOR=$COLOR_LIGHT_CYAN

        # Aliases
        alias mirror=/Users/pavel/projects/mirror/src/mirror2.py
        alias 4ch='/Users/pavel/projects/mirror/src/mirror2.py --4ch'
        alias updatedb="LC_ALL='C' sudo gupdatedb --prunepaths='/Volumes'"  # Don't index any external drives, or anything mounted via sshfs, etc.

        # Make sure tmux can display UTF data correctly
        alias tmux='tmux -u'

        # MacPorts
        export PATH=/opt/local/bin:/opt/local/sbin:$PATH

        alias restart_growl="killall GrowlHelperApp; open -b com.Growl.GrowlHelperApp"

        # Launch tinyur desktop screenshot monitor
        # *after* my happy Tmux session starts, so we don't get multiples.
        if ! ps ax | egrep tinyu[r].py > /dev/null && which tinyur.py > /dev/null; then
            nohup tinyur.py 1>~/tinyur.err 2>~/tinyur.err &
        fi

        # Make sure TotalTerminal is running
        # PROBLEM - this makes the current terminal window fuck off forever,
        # even if you just open a new tab.
        if [[ -f ~/bin/is_total_terminal_running.sh && `~/bin/is_total_terminal_running.sh` == "no" ]]; then
            if [ -d /Applications/TotalTerminal.app/ ]; then
                open /Applications/TotalTerminal.app/
            fi
        fi

        # Bash completion, obv.
        # if [ -f `brew --prefix`/etc/bash_completion ]; then
        #     source `brew --prefix`/etc/bash_completion
        # fi

        # Virtualenv Wrapper
        # if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
        #     source /usr/local/bin/virtualenvwrapper.sh
        # fi

        # Start tmux
        if ! tmux has-session -t startup 1>/dev/null 2>/dev/null; then
            tmux -u new-session -d -s startup
        fi

        # I don't know why, but when I try to attach tmux in TotalTerminal,
        # it refuses to show UTF8 characters. So fuck it! This really only runs
        # once per boot, anyway.
        #ONLY attach in visor
        # if [[ $COLUMNS -gt 120 ]]; then tmux att -t startup fi

        if [ -f /Applications/XAMPP/xamppfiles/bin/php ]; then
            alias xphp='/Applications/XAMPP/xamppfiles/bin/php'
            alias xmysql='/Applications/XAMPP/xamppfiles/bin/mysql'
        fi

        #TODO these might have to be global
        export CLICOLOR=1
        export LSCOLORS=ExFxCxDxBxegedabagacad

        # Load RVM into a shell session *as a function*
        [[ -s "/Users/pavel/.rvm/scripts/rvm" ]] && source "/Users/pavel/.rvm/scripts/rvm"
    ;;
    "newyork")
        # Ubuntu desktop, at home.

        # Start synergys, unless it's already running
        if ! ps ax | grep synergy[s] > /dev/null; then
            synergys -c $HOME/.synergy.newyork.conf
        fi
        # alternatively, i might actually start working on my new macbook
        # since SYNERGY and EMACS don't FUCKING WORK WELL TOGETHER
        # better UNSUBJUGATE MYSELF http://debbugs.gnu.org/cgi-bin/bugreport.cgi?bug=4008
            #if ! ps ax | grep synergy[c] > /dev/null; tehn
        #    synergyc -f -n newyork 192.168.0.11 # gotta figure out a permanent ip for adison
        #fi
    ;;
    "vodka")
        # My virtualbox

        PS1_DATE_COLOR=$COLOR_LIGHT_CYAN
        PS1_USER_COLOR=$COLOR_LIGHT_CYAN
        PS1_HOST_COLOR=$COLOR_LIGHT_CYAN
        PS1_PATH_COLOR=$COLOR_LIGHT_GREEN

        # enable programmable completion features (you don't need to enable
        # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
        # sources /etc/bash.bashrc).
        if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
            . /etc/bash_completion
        fi

        # Update ForwardAgent settings
        [[ -f $HOME/bin/grabssh.sh ]] && $HOME/bin/grabssh.sh

        # Lol, node.js
        export PATH=$HOME/local/node/bin:$PATH

    ;;
    "yonk")
        # My slicehost server
        if [[ "$TERM" == "xterm-256color" ]]; then
            # Screen can't handle the power of my mac
            export TERM=xterm-color
        fi
    ;;
    "fancybone.xen.prgmr.com")
        # My prgmr server
        # Gotta say somethin'
        true
    ;;
    "champ" | "boom")
        # Work servers

        PS1_DATE_COLOR=$COLOR_LIGHT_GREEN
        PS1_USER_COLOR=$COLOR_LIGHT_GREEN
        PS1_HOST_COLOR=$COLOR_YELLOW
        PS1_PATH_COLOR=$COLOR_LIGHT_CYAN

        # Update ForwardAgent settings
        [[ -f $HOME/bin/grabssh.sh ]] && $HOME/bin/grabssh.sh

        # Path to python 2.6
        export PATH=/opt/py26/usr/local/bin/:$PATH
        # Path to Ruby 1.9.2
        export PATH=/opt/ruby192/bin/:$PATH

    ;;
    "moobox")
        # Work server under my desk

        PS1_DATE_COLOR=$COLOR_LIGHT_GREEN
        PS1_USER_COLOR=$COLOR_LIGHT_GREEN
        PS1_HOST_COLOR=$COLOR_YELLOW
        PS1_PATH_COLOR=$COLOR_LIGHT_CYAN

        # Update ForwardAgent settings
        [[ -f $HOME/bin/grabssh.sh ]] && $HOME/bin/grabssh.sh

        # Start synergyc, unless it's already running
        if ! ps ax | grep synergyc | grep -v grep > /dev/null; then
            synergyc austin.netomat.net
        fi
    ;;
    *)
        # Everything else

    ;;
esac


if [[ "$USER" == "root" ]]; then
    PS1_USER_COLOR=$COLOR_RED
    PS1_DICKS="${COLOR_RED} $ ${COLOR_CLEAR}"
fi

# prompt
if [[ $PS1_DATE == 1 ]]; then
    PS1="${PS1}[${PS1_DATE_COLOR}\D{%Y-%m-%d %H:%M:%S}$COLOR_CLEAR] "
fi
if [[ $PS1_USER == 1 ]]; then
    PS1="${PS1}${PS1_USER_COLOR}\u$COLOR_CLEAR"
fi
if [[ $PS1_HOST == 1 ]]; then
    PS1="${PS1}${PS1_HOST_COLOR}@\h$COLOR_CLEAR"
fi
if [[ $PS1_PATH == 1 ]]; then
    PS1="${PS1}:${PS1_PATH_COLOR}\w$COLOR_CLEAR"
fi
PS1="${PS1}${PS1_DICKS}"
export PS1
