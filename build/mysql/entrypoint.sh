#!/bin/bash

# execute any pre-init scripts
for i in /scripts/pre-init.d/*sh
do
	if [ -e "${i}" ]; then
		echo "[i] pre-init.d - processing $i"
		. "${i}"
	fi
done

/bin/bash /docker-entrypoint.sh mysqld --user=mysql --console --skip-name-resolve --skip-networking=0