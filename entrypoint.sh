#!/bin/bash
set -e

: "${APACHE_CONFDIR:=/etc/apache2}"
: "${APACHE_ENVVARS:=$APACHE_CONFDIR/envvars}"
if test -f "$APACHE_ENVVARS"; then
	. "$APACHE_ENVVARS"
fi

: "${APACHE_RUN_DIR:=/var/run/apache2}"
: "${APACHE_PID_FILE:=$APACHE_RUN_DIR/apache2.pid}"
rm -f "$APACHE_PID_FILE"

# create missing directories
# (especially APACHE_RUN_DIR, APACHE_LOCK_DIR, and APACHE_LOG_DIR)
for e in "${!APACHE_@}"; do
	if [[ "$e" == *_DIR ]] && [[ "${!e}" == /* ]]; then
		# handle "/var/lock" being a symlink to "/run/lock", but "/run/lock" not existing beforehand, so "/var/lock/something" fails to mkdir
		#   mkdir: cannot create directory '/var/lock': File exists
		dir="${!e}"
		while [ "$dir" != "$(dirname "$dir")" ]; do
			dir="$(dirname "$dir")"
			if [ -d "$dir" ]; then
				break
			fi
			absDir="$(readlink -f "$dir" 2>/dev/null || :)"
			if [ -n "$absDir" ]; then
				mkdir -p "$absDir"
			fi
		done

		mkdir -p "${!e}"
	fi
done

# check if Admidio directory is empty.
# when empty then copy files from prov folder
for folder in adm_plugins adm_themes adm_my_files;
do
	if [ -n "$(find $WWW/$ADM/$folder/ -maxdepth 0 -type d -empty 2>/dev/null)" ]; then
    echo "directory is Empty"
    echo "copy from prov $folder"
    cp -a $WWW/$PROV/$folder/* $WWW/$ADM/$folder/
    chown -R www-data:www-data $WWW/$ADM/$folder
	fi
done

# patch
# AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using <docker_ip> Set the 'ServerName' directive globally to suppress this message
APACHE_CONF="/etc/apache2/conf-available"
APACHE_CONF_ENABLE="/etc/apache2/conf-enabled"
if [ ! -f "$APACHE_CONF/fqdn.conf" ]
then
	echo "ServerName   `hostname`" > "$APACHE_CONF/fqdn.conf" && ln -s "$APACHE_CONF/fqdn.conf" "$APACHE_CONF_ENABLE/fqdn.conf"
fi

exec apache2 -DFOREGROUND "$@"
