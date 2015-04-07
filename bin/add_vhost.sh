#!/bin/bash
# Create new apache2.4 virual host
#
#
#

VHOSTDIR="/etc/apache2/sites-available/"
SSLCERTIFICATEFILE="/etc/apache2/cert/localhost.crt"
SSLCERTIFICATEKEYFILE="/etc/apache2/cert/localhost.key"


# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Make shure 2 arguments given
if [ $# -lt 2 ]; then
	echo "2 required arguments: the hostname and directory" 1>&2
	echo "script.sh site.com /home/to/public/direcory/" 1>&2
	exit 1
fi

# Check if public directory exist
if [ -d "$2" ]; then 
  while true; do
	  read -p "$2 Directory already exist. Overwrite? (Yy/Nn/Ss) " yn
    case $yn in
        [Ss]* ) ls -Alh "$2";;
        [Yy]* ) mkdir "$2" break;;
        [Nn]* ) break;;
        * ) echo "Please answer (Yy/Nn/Ss) ";;
    esac
	done
else
	echo "Creating directory $2"
	mkdir "$2" 
fi

# Check if conf file already exist
if [ -f "$VHOSTDIR$1.conf" ]; then 
  while true; do
	  read -p "$VHOSTDIR$1.conf Apache conf file already exist. Overwrite? (Yy/Nn/Ss) " yn
    case $yn in
        [Ss]* ) less "$VHOSTDIR$1.conf";;
        [Yy]* ) break;;
        [Nn]* ) echo "Nothing to do! Exit." & exit;;
        * ) echo "Please answer (Yy/Nn/Ss)) ";;
    esac
done
fi

echo "Creating virtualhost conf file $VHOSTDIR$1.conf"
echo "
<VirtualHost *:80>
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

# echo "Add the host to the hosts file ... "
# echo 127.0.0.1	$1 >> /etc/hosts

a2ensite $1
 
# Reload Apache2
/etc/init.d/apache2 restart
 
echo "The host is available at http://$1"

exit 0
