# Add nano as default editor
# export SHELL="/bin/bash"
export EDITOR=vim
export TERMINAL=terminator
export VISUAL=vim
# export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

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
shopt -s globstar

complete -cf killall
complete -cf kill
complete -cf sudo
complete -cf optirun
complete -cf man
complete -d  cd

# Keybinds for search by up and down keys
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# User variable settings
set show-all-if-ambiguous on
set completion-ignore-case off

# set -o vi

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

## GIT prompt
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUPSTREAM=verbose
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_DESCRIBE_STYLE=branch
[ -f /usr/share/git/completion/git-prompt.sh ] && source /usr/share/git/completion/git-prompt.sh

LAST_PROMPT_SHOWED_AT=$(date +%s)

function __prompt_command() {
    local EXIT="$?"             # This needs to be first
    PS1=""
    CURRENT_TIMESTAMP=$(date +%s)
    PROMPT_DELTA=$(( $CURRENT_TIMESTAMP - $LAST_PROMPT_SHOWED_AT ))
    LAST_PROMPT_SHOWED_AT=$CURRENT_TIMESTAMP

    local LOW=''
    local RED=''
    local REDB=''
    local REDBG=''
    local GRN=''
    local GRNB=''
    local BLWH=''
    local WHB=''
    local CLR=''
    local BRWN=''
    local YLLW_ON_BROWN=''
    local BLUE_ON_MAGENTA=''

    local USER_PROMPT=''
    local DIRECTORY_PROMPT=''
    local TMUX_PROMPT=''
    local RANGER_PROMPT=''
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi

    if [ "$color_prompt" = yes ]; then
        LOW='\[\e[m\]'
        RED='\[\e[0;91m\]'
        REDB='\[\e[1;91m\]'
        REDBG='\[\e[1;37;41m\]'
        GRN='\[\e[0;92m\]'
        GRNB='\[\e[1;92m\]'
        BLWH='\[\e[7;49;33m\]'
        WHB='\[\e[1;37m\]'
        CLR='\[\e[0;0;0m\]'
        BRWN='\[\e[;;40m\]'
        YLLW_ON_BROWN='\[\e[33;40m\]'
        BLUE_ON_MAGENTA='\[\e[1;33;40m\]'
    fi

    if [ "$EUID" -ne 0 ]; then
        USER_PROMPT="${YLLW_ON_BROWN} \u${BRWN}@${BLUE_ON_MAGENTA}\H${BRWN}"
    else
        USER_PROMPT="${REDB} \u${BRWN}@${BLUE_ON_MAGENTA}\H${BRWN}"
    fi

    if [ -w "$PWD" ]; then
        DIRECTORY_PROMPT=":${BLWH}${PWD//$HOME/~}${CLR}"
    else 
        DIRECTORY_PROMPT=":${REDBG}${PWD//$HOME/~}${CLR}"
    fi

    if [ -n "$TMUX" ]; then
        TMUX_PROMPT=" tmux"
    fi

    if [ -n "$RANGER_LEVEL" ]; then
        RANGER_PROMPT=" ranger:${RANGER_LEVEL}"
    fi

    PS1="${CLR}${LOW}\nexit: ${EXIT} | ${PROMPT_DELTA}s ago\n${GRN}▼ \#.${debian_chroot:+($debian_chroot)}${USER_PROMPT}${DIRECTORY_PROMPT}${BRWN}$(__git_ps1 ' (%s)') shl:${SHLVL}${TMUX_PROMPT}${RANGER_PROMPT} \T ${CLR}\n"
}

export PS1='\[\e[1;35m\]▶\[\e[0m\] '
export PS2='\[\e[1;30m\]◀\[\e[0m\] '
PROMPT_COMMAND=__prompt_command

unset color_prompt force_color_prompt


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

## CPU heavy
function matrix {
    echo -e "\e[1;40m" ; clear ; while :; do sleep 0.05s; echo $LINES $COLUMNS $(( $RANDOM % $COLUMNS)) $( printf "\U$(( $RANDOM % 500 ))" ) ;sleep 0.05; done|gawk '{c=$4; letter=$4;a[$3]=0;for (x in a) {o=a[x];a[x]=a[x]+1; printf "\033[%s;%sH\033[2;32m%s",o,x,letter; printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter;if (a[x] >= $1) { a[x]=0; } }}'
}

# sends email using sendmail
# usage: echo "my email message" | email "foo@bar.com" "new event happened" "serverX" "noreply@serverx.com"
function email {
  content="$(cat - )"; email="$1"; subject="$2"; fromname="$3"; from="$4"
  {
    echo "Subject: $subject"
    echo "From: $fromname <$from>";
    echo "To: $email";
    echo "$content"
  } | $(which sendmail) -F "$from" "$email"
}

function top_inotify {
    for foo in /proc/*/fd/*; do readlink -f $foo; done | grep inotify | cut -d/ -f3 | xargs -I '{}' -- ps --no-headers -o '%p %U %c' -p '{}' | uniq -c | sort -nr
}
# 
function top_gpu {
    nvidia-smi --query-gpu=memory.total,memory.free,memory.used --format=csv
}

# get public ip
function ippublic {
    wget http://ipinfo.io/ip -qO -
}

# highlight IP pattern 
function highlight_ip() {
    perl -pe 's/((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])/\e[1;31m$&\e[0m/g'
}

function buff() {
    xclip -in -sel clip
}

# public file sharing
function transfer() { 
    if [ $# -eq 0 ]; then echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi 
    tmpfile=$( mktemp -t transferXXX ); 
    if tty -s; then 
        basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); 
        curl --progress-bar -H "Max-Downloads: 6" -H "Max-Days: 10" --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; 
    else 
        curl --progress-bar -H "Max-Downloads: 6" -H "Max-Days: 10" --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; 
    fi; 
    cat $tmpfile; rm -f $tmpfile; 
}

# color table
function color_test() {
    T='gYw'   # The test text
    echo -e "\n                 40m     41m     42m     43m     44m     45m     46m     47m";
    for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' '  36m' '1;36m' '  37m' '1;37m'; do 
        FG=${FGs// /}
        echo -en " $FGs \033[$FG  $T  "
        for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do 
            echo -en "$EINS \033[$FG\033[$BG  $T \033[0m\033[$BG \033[0m";
        done
        echo;
    done
    echo
}

## Show unmerged branches in GIT
function unmerged {
    git branch -r --no-merged | grep -v HEAD | xargs -L1 git --no-pager log --pretty=tformat:'%Cgreen%d%Creset - %h by %an (%Cblue%ar%Creset)' -1
}

function cdd {
    cd $(dirname $1)
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
    alias ls='ls --color=always'
    alias dir='dir --color=always'
    alias vdir='vdir --color=always'

    alias grep='grep --color=always'
    alias fgrep='fgrep --color=always'
    alias egrep='egrep --color=always'
fi


## Git aliases
alias ga="git add"
alias gst="git status"
alias gbl="git branch -l"
alias gpl="git pull"
alias gp="git push"
alias gcb="git checkout"
alias gcm="git commit -m"


# Tools
alias ll='ls -AlhFZQ --group-directories-first'
alias la='ls -A'
alias l='ls -CF'
alias composer='composer --ansi'
alias pacman='pacman --color always'
alias hist='history | grep'
alias update='sudo pacman -Syyu'
alias remove='sudo pacman -Rs'
alias install='sudo pacman -S'
alias search='pacman -Ss'
alias show='pacman -Si'
alias rg='ranger'
alias subl="sublime_text"
alias note="vim ~/documents/quicknotes"
# alias matrix=matrix

## docker aliases
alias dockip="docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "
alias docom="docker-compose"
alias docom-build="docker-compose build --no-cache --compress --parallel --force-rm --pull"
alias dockup="docker-compose up -d; docker-compose logs -f"
alias dock-php-7="docker run --rm -i --volume $(pwd):/app -w /app php:7-cli-alpine php"
alias dock-php-5="docker run --rm -i --volume $(pwd):/app -w /app php:5-cli-alpine php"


[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash

[ -f ~/.git-completion.bash ] && source ~/.git-completion.bash
[ -f ~/.bash/bspc_completion ] && source ~/.bash/bspc_completion
[ -f ~/.bash/make_completion ] && source ~/.bash/make_completion

# export JAVA_HOME='/usr/lib/jvm/java-7-openjdk/'
# export ANDROID_HOME="$HOME/Android/Sdk/"

[ -s "/etc/profile.d/android-sdk-platform-tools.sh" ] && . "/etc/profile.d/android-sdk-platform-tools.sh" 

# complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' Makefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make
