# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Path LC_ALL=
if [ -e "/home/$USER/.pam_environment" ]; then
        LANG=$( cat ~/.pam_environment | grep LANGUAGE | cut -d= -f2 | cut -c 1-5 )
        export LC_ALL=$LANG.UTF-8
        export LANG=$LANG.UTF-8
        export LANGUAGE=$LANG.UTF-8
    else
    if [ -d "/rofs" ]; then
        export LC_ALL=en_US.UTF-8
        export LANG=en_US.UTF-8
        export LANGUAGE=en_US.UTF-8
    fi
fi
