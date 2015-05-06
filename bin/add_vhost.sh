#!/usr/bin/env bash
# Create new apache2.4 virual host
#
# Dependencies:
#

VHOSTDIR="/etc/apache2/sites-available/"
SSLCERTIFICATEFILE="/etc/apache2/cert/localhost.crt"
SSLCERTIFICATEKEYFILE="/etc/apache2/cert/localhost.key"

##------------------------------------------------------------------------------
## Color print management
##------------------------------------------------------------------------------
COLOR_ERROR='\e[1;41;37m'
COLOR_SUCCESS='\e[1;32m'
COLOR_PROMPT='\e[1;36m'
COLOR_NORMAL='\e[1;1m'
COLOR_RESET='\e[0m' # No Color

m_error () {
    echo -e "${COLOR_ERROR} ${1} ${COLOR_RESET} "
}
m_success () {
    echo -e "${COLOR_SUCCESS} ${1} ${COLOR_RESET} "
}
m_prompt () {
    echo -e "${COLOR_PROMPT}?? ${1}${COLOR_RESET} "
}
m_normal () {
    echo -e "${COLOR_NORMAL}>> ${1}${COLOR_RESET} "
}
## aliases
##------------------------------------------------------------------------------


# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   m_error "This script must be run as root" 1>&2
   exit 1
fi

# Make shure 2 arguments given
if [ $# -lt 2 ]; then
    m_error "2 required arguments: the hostname and directory" 1>&2
    exit 1
fi

# Check if public directory exist
while true; do
    if [ -e "$2" ]; then 
        while true; do
            m_prompt "$2 Directory already exist. Overwrite? (Yy/Nn/Ss) "
            read yn
            case $yn in
                [Ss]* ) ls -Alh "$2";;
                [Yy]* ) rm -rvf "$2"
                    break;;
                [Nn]* ) break 2;;
                * ) m_prompt "Please answer (Yy/Nn/Ss) ";;
            esac
        done
    fi
    
    m_normal "Creating directory $2"
    mkdir "$2"
    break
done

# Check if conf file already exist
while true; do
    if [ -e "$VHOSTDIR$1.conf" ]; then 
      while true; do
        m_prompt "$VHOSTDIR$1.conf Apache conf file already exist. Overwrite? (Yy/Nn/Ss) "
        read yn
        case $yn in
            [Ss]* ) less "$VHOSTDIR$1.conf";;
            [Yy]* ) rm -rvf "$VHOSTDIR$1.conf"
                break;;
            [Nn]* ) break 2;;
            * ) m_prompt "Please answer (Yy/Nn/Ss)) ";;
        esac
    done
    fi

    m_normal "Creating virtualhost conf file $VHOSTDIR$1.conf"
    echo "<VirtualHost *:80>
    ServerName $1
    ServerAlias www.$1
    DocumentRoot '$2/'

    <Directory '$2/'>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>

<VirtualHost *:443>
    ServerName $1
    ServerAlias www.$1
    DocumentRoot '$2/'

    SSLEngine on
    SSLCertificateFile    '$SSLCERTIFICATEFILE'
    SSLCertificateKeyFile '$SSLCERTIFICATEKEYFILE'

    <Directory '$2/'>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
" > "$VHOSTDIR$1.conf"
    break
done

# m_normal "Add new host to the hosts file ... "
# echo "127.0.0.1    $1" >> /etc/hosts

m_normal "Enabling site"
a2ensite $1
 
m_normal "Reloading apache2"
apache2ctl restart

m_normal "Available hosts\n"
apache2ctl -S

m_success "\nThe host is available at http://$1"

exit 0
