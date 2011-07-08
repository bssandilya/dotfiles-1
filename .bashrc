# ~/.bashrc: executed by bash(1) for non-login shells.

# if not running interactively, don't do anything
[ -z "$PS1" ] && return

function _inside_screen() { 
    if [ "$STY" = "" ]; then echo "false"; else echo "true"; fi 
}
function _screen_name() { 
    echo ${STY#*.} 
}

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

# Default prompt
PS1="${COLOR_YELLOW}\u@\h$COLOR_CLEAR:$COLOR_LIGHT_CYAN$\w$COLOR_CLEAR
\$ "

alias grep='grep --color=auto'

# Don't add this shit to history
export HISTIGNORE="sudo shutdown:sudo re:bg:fg" 
# Ignore duplicates, and commands that start with a space
export HISTCONTROL=ignoredups:ignorespace
# Remember a lot.
export HISTSIZE=5000
export HISTFILESIZE=5000
# Append to history file, don't overwrite.
shopt -s histappend
# don't try to complete on nothing
shopt -s no_empty_cmd_completion
# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

if [ -d "${HOME}/bin" ]; then
    export PATH=${HOME}/bin:$PATH
fi

###################
# OS specific stuff
###################
case $OSTYPE in
    darwin*)
        # OS X
        alias ls='ls -G'
    ;;
    *)
        # Everything else
        alias ls='ls --color=auto'
    ;;
esac

#####################
# Host specific stuff
#####################
case $HOSTNAME in
    vodkamat.netomat.net)
        # My Macbook
        #TODO this hostname is temporary, damnit, this thing should be called "austin"

        # Prompt
        export PS1="${COLOR_LIGHT_GREEN}\u@\h${COLOR_CLEAR}:${COLOR_LIGHT_CYAN}\w${COLOR_CLEAR}\n\$ "
        
        # Aliases
        alias mirror=/Users/pavel/projects/mirror/src/mirror.py
        alias 4ch='/Users/pavel/projects/mirror/src/mirror.py --4ch'
        alias updatedb="LC_ALL='C' sudo gupdatedb --prunepaths='/Volumes'"  # Don't index any external drives, or anything mounted via sshfs, etc.
        
        # MacPorts
        export PATH=/opt/local/bin:/opt/local/sbin:$PATH
        
        # If the startup screen isn't running, run it, using a custom .screenrc file that launches tinyur and synergy
        if ! screen -ls | grep 'startup' > /dev/null; then
            screen -S startup -c .screenrc-startup
        fi
        
        # Bash completion, obv.
        if [ -f `brew --prefix`/etc/bash_completion ]; then
            #source `brew --prefix`/etc/bash_completion
            cat /dev/null
        fi

        # Virtualenv Wrapper
        if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
            #source /usr/local/bin/virtualenvwrapper.sh
            cat /dev/null
        fi

        #TODO these might have to be global
        export CLICOLOR=1
        export LSCOLORS=ExFxCxDxBxegedabagacad        
    ;;
    "champ" | "boom")
        # Work server

        export PS1="${COLOR_LIGHT_GREEN}\u@\h${COLOR_CLEAR}:${COLOR_LIGHT_CYAN}\w${COLOR_CLEAR} \$ "
        
    ;;
    *)
        # Everything else
        
        # Update ForwardAgent settings
        [[ -f $HOME/grabssh.sh ]] && $HOME/grabssh.sh
    ;;
esac