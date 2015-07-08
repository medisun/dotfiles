# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

export GOPATH="$HOME/go"
export PATH="$HOME/go/bin:$PATH"

TOOLS_DIR=$(dirname "${BASH_SOURCE[0]}")

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups

# auto cd folder
shopt -s autocd

# attempts to save all lines of a multiple-line command in the same history entry
shopt -s cmdhist

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# append to the history file, don't overwrite it
shopt -s histappend

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Keybinds for search by up and down keys
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# User variable settings
set show-all-if-ambiguous on
set completion-ignore-case off

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ -n "$RANGER_LEVEL" ]; then
    RANGER_PROMPT='ranger:'$RANGER_LEVEL
else
    RANGER_PROMPT=''
fi

## TODO: TMUX

if [ "$color_prompt" = yes ]; then
    PS1="\nlast:$?\n\[\e[92m\]┳ \#.${debian_chroot:+($debian_chroot)}\[\e[0m\][\[\e[1;07m\] \w \[\e[0m\]] \[\e[1;92m\]\u@\H \$\[\e[00m\] \[\e[1;37m\]\$(stat -c %A '$PWD')\[\e[00m\] \[\e[92m\] shlvl:$SHLVL $RANGER_PROMPT\n┗\[\e[01;0m\] "

    GIT_PROMPT_START="\nlast:$?\n\[\e[92m\]┳ \#.${debian_chroot:+($debian_chroot)}\[\e[0m\][\[\e[1;07m\] \w \[\e[0m\]] \[\e[1;92m\]\u@\H \$\[\e[00m\] \[\e[1;37m\]\$(stat -c %A '$PWD')\[\e[00m\] "    
    GIT_PROMPT_END="\[\e[92m\] shlvl:$SHLVL $RANGER_PROMPT\n┗\[\e[01;0m\] "
else
    PS1="\nlast:$?\n┳ \#.${debian_chroot:+($debian_chroot)}[ \w ] \u@\H \$ \$(stat -c %A '$PWD') shlvl:$SHLVL $RANGER_PROMPT\n┗ "
    GIT_PROMPT_START="\nlast:$?\n┳ \#.${debian_chroot:+($debian_chroot)}[ \w ] \u@\H \$ \$(stat -c %A '$PWD') "    
    GIT_PROMPT_END=" shlvl:$SHLVL $RANGER_PROMPT \n┗ "
fi

unset color_prompt force_color_prompt

## Git prompt
##
GIT_PROMPT_ONLY_IN_REPO=1
GIT_PROMPT_FETCH_REMOTE_STATUS=0
GIT_PROMPT_THEME=Solarized
source /opt/bash-git-prompt/gitprompt.sh

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


#      █████╗ ██╗     ██╗ █████╗ ███████╗███████╗███████╗ 
#     ██╔══██╗██║     ██║██╔══██╗██╔════╝██╔════╝██╔════╝ 
#     ███████║██║     ██║███████║███████╗█████╗  ███████╗ 
#     ██╔══██║██║     ██║██╔══██║╚════██║██╔══╝  ╚════██║ 
#     ██║  ██║███████╗██║██║  ██║███████║███████╗███████║ 
#     ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝ 

function matrix {
    echo -e "\e[1;40m" ; clear ; while :; do echo $LINES $COLUMNS $(( $RANDOM % $COLUMNS)) $( printf "\U$(( $RANDOM % 500 ))" ) ;sleep 0.05; done|gawk '{c=$4; letter=$4;a[$3]=0;for (x in a) {o=a[x];a[x]=a[x]+1; printf "\033[%s;%sH\033[2;32m%s",o,x,letter; printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter;if (a[x] >= $1) { a[x]=0; } }}'
}


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Tools
alias lh='ls -Alh'
alias ll='ls -Alh'
alias la='ls -A'
alias l='ls -CF'
alias hist='history | grep'
alias install='sudo aptitude install'
alias search='sudo aptitude search'
alias show='sudo aptitude show'
alias rg='ranger'
alias subl="sublime_text"
alias note="vim ~/documents/quicknotes"
alias matrix=matrix

## artisan aliases
alias migrate='php artisan migrate'
alias dbseed='php artisan db:seed'





