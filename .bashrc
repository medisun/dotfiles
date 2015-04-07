# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000


# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

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

if [ "$color_prompt" = yes ]; then
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1="\n\[\e[92m\]┳ \#.\[\e[0m\][\[\e[1;07m\] \w \[\e[0m\]] \[\e[1;92m\]\u@\H \$\[\e[00m\] \[\e[1;37m\]\$(stat -c %A '$PWD')\[\e[00m\] \[\e[92m\]${debian_chroot:+($debian_chroot)}\n┗\[\e[01;0m\] "

else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

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

# some more ls aliases
alias rg='ranger'
alias lh='ls -Alh'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias hist='history | grep'
alias install='sudo aptitude install'
alias search='sudo aptitude search'
alias show='sudo aptitude show'

## Projects
alias dealbook='cd /home/morock/projects/dealbook'
alias circleofeducation='cd /home/morock/projects/circleofeducation/git/src'
alias pbay='cd /home/morock/projects/pbay/git'
alias glisser='cd /home/morock/projects/glisser'
alias glisser-api='cd /home/morock/projects/glisser/glisser-eventbrite-api'
alias glisser-mng='cd /home/morock/projects/glisser/glisser-manage-integration/modules/Eventbrite'

alias ssh217livlicio='ssh livlicio@182.160.157.217'
alias ssh58devel='ssh devel@192.168.0.58'
alias ssh86devel='ssh devel@192.168.0.86'
alias ssh36root='ssh root@192.168.0.36'
alias ssh77devel='ssh devel@192.168.0.77'


# User key bindings
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'


# User variable settings
set show-all-if-ambiguous on
set completion-ignore-case off

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'



# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

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


#############################
## GITPROMPT CONFIGURATION ##
#############################

# Set config variables first
GIT_PROMPT_ONLY_IN_REPO=1

GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status

# uncomment for custom prompt start sequence
GIT_PROMPT_START="\n\[\e[92m\]┳ \#.\[\e[0m\][\[\e[1;07m\] \w \[\e[0m\]] \[\e[1;92m\]\u@\H \$\[\e[00m\] \[\e[1;37m\]\$(stat -c %A '$PWD')\[\e[00m\] "    

# uncomment for custom prompt end sequence
GIT_PROMPT_END=" ${debian_chroot:+($debian_chroot)}\[\e[92m\]\n┗\[\e[01;0m\] "

# as last entry source the gitprompt script
source /opt/git-bash/gitprompt.sh
alias subl="sublime_text"
