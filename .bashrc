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
export HISTSIZE=50000
export HISTFILESIZE=50000
# Store timestamps
export HISTTIMEFORMAT='%F %T '
if [ -n "$BASH_VERSION" ] && [ -n "$POSIXLY_CORRECT" ]; then
    # Append to history file, don't overwrite.
    shopt -s histappend
    # don't try to complete on nothing
    shopt -s no_empty_cmd_completion
fi

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

export LC_ALL="C"

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
alias rot13="tr '[A-Za-z]' '[N-ZA-Mn-za-m]'"
alias gitprune='git branch --merged master | grep -v "\* master" | xargs -n 1 git branch -d'

if [[ -f $HOME/.screensaver.sh ]]; then
    source .screensaver.sh
fi


function tmuxx() {
  name="$1";
  if [[ "$1" == "" ]]; then
      curdir=$(basename $(pwd));
      name="$curdir";
  fi

  if [[ "$name" == "bv" && -e /gitwork/Hubs-Core/ ]]; then
    cd /gitwork/Hubs-Core/
  fi

  tmux att -t "$name" || tmux new -s "$name"
}

# for crontabs, git, etc.
export EDITOR=vim

# Write commands to history as soon as they are typed
# http://briancarper.net/blog/248/
export PROMPT_COMMAND='history -a'

# iPython should live in ~/.ipython/
export IPYTHONDIR=~/.ipython/

# If block needed due to Ubuntu bug: https://bugs.launchpad.net/ubuntu/+source/lightdm/+bug/1097903
if [ -n "$BASH_VERSION" ] && [ -n "$POSIXLY_CORRECT" ]; then
    # http://bclary.com/blog/2006/07/20/pipefail-testing-pipeline-exit-codes/
    set -o pipefail
fi

###################
# OS specific stuff
###################
case $OSTYPE in
    darwin*)
        # OS X

        alias ls='ls -G' # -G colorizes ls output
        export LSCOLORS="Exfxcxdxbxegedabagacad" # make directories a readable color of blue
        alias updatedb='sudo /usr/libexec/locate.updatedb'

        # Optional bash_completion
        if [ -f `brew --prefix`/etc/bash_completion ]; then
            alias bash_completion='source `brew --prefix`/etc/bash_completion'
            #source `brew --prefix`/etc/bash_completion
        fi

        # git bash completion
        if [ -f $HOME/git-completion.bash ]; then
            source $HOME/git-completion.bash
        fi

        if [ -d $HOME/.rvm/bin ]; then
            export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
        fi

        # Use OS X emacs
        if [ -d /Applications/Emacs.app/Contents/MacOS/bin ]; then
            export PATH=/Applications/Emacs.app/Contents/MacOS/bin:$PATH
            alias emacs='emacsclient -n' # Open new files from command line in existing frame
            EDITOR="emacsclient"
        fi

        # Android Development Tools
        if [ -d "/Applications/Android Studio.app/sdk" ]; then
            export PATH="/Applications/Android Studio.app/sdk/platform-tools:${PATH}"
            export PATH="/Applications/Android Studio.app/sdk/tools:${PATH}"
        fi

        # Homebrew
        export PATH=/usr/local/bin:/usr/local/sbin:$PATH

        if [ -f $(brew --prefix nvm)/nvm.sh ]; then
            export NVM_DIR=~/.nvm
            source $(brew --prefix nvm)/nvm.sh
        fi

        export SUDO_PROMPT="Seno akta gamat: "
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
    "plishin.local")
        # BazaarVoice Macbook

        export JENV_ROOT=/usr/local/opt/jenv
        eval "$(jenv init -)"

        export MAVEN_OPTS="-Xmx1024M -XX:MaxPermSize=1024M"

        # Come on, weechat, let's have some unicode
        export LC_ALL="en_US.UTF-8"

        # Not committing this to public repo, might contain sensitive stuff
        if [ -f $HOME/.bazaarvoice.bashrc ]; then
            source $HOME/.bazaarvoice.bashrc
        fi
        if [ -f /tmp/abba_servers ]; then
            source /tmp/abba_servers
        fi
        if [ -f /tmp/connections_reporting_servers ]; then
            source /tmp/connections_reporting_servers
        fi

        # Docker crap
        export DOCKER_HOST=tcp://192.168.59.103:2376
        export DOCKER_CERT_PATH=/Users/pavel.lishin/.boot2docker/certs/boot2docker-vm
        export DOCKER_TLS_VERIFY=1

        # Open file in IntelliJ from command line
        alias idea="open -b com.jetbrains.intellij"
    ;;
    "newyork")
        # Ubuntu desktop, at home.
        true
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
    *)
        # Everything else

    ;;
esac

if [[ "$USER" == "root" ]]; then
    PS1_USER_COLOR=$COLOR_RED
    PS1_DICKS="${COLOR_RED} $ ${COLOR_CLEAR}"
    # TODO ಠ_ಠ
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

if [ -f ~/.localbashrc ]; then
    # Maybe I'm on a system I don't want to stick in the repo,
    # but I still need/want to customize
    . ~/.localbashrc
fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
