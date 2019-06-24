#!/usr/bin/env bash

set -e
set -u

###
### Globals
###

# Path to scripts to source
FUNC_DIR="/scripts/func.d"
# Supervisord config directory
SUPERVISOR_CONFD="/etc/supervisor/conf.d"
RUNTIME_CONFIG_DIR="/scripts/pre-init.d"

###
### Source libs
###
init="$( find "${FUNC_DIR}" -name '*.sh' -type f | sort -u )"
for f in ${init}; do
	. "${f}"
done

#############################################################
## Entry Point
#############################################################

###
### Set Debug level
###
DEBUG_LEVEL="$( env_get "DEBUG_ENTRYPOINT" "0" )"
log "info" "Debug level: ${DEBUG_LEVEL}" "${DEBUG_LEVEL}"

###
### Runtime script
###
exec_script="$( find "${RUNTIME_CONFIG_DIR}" -name '*.sh' -type f | sort -u )"
for f in ${exec_script}; do
	. "${f}"
done

###
### Validate socat port forwards
###
if ! port_forward_validate "FORWARD_PORTS_TO_LOCALHOST" "${DEBUG_LEVEL}"; then
	exit 1
fi

##
## Supervisor: socat
##
for line in $( port_forward_get_lines "FORWARD_PORTS_TO_LOCALHOST" ); do
	lport="$( port_forward_get_lport "${line}" )"
	rhost="$( port_forward_get_rhost "${line}" )"
	rport="$( port_forward_get_rport "${line}" )"
	supervisor_add_service \
		"socat-${lport}-${rhost}-${rport}" \
		"/usr/bin/socat tcp-listen:${lport},reuseaddr,fork tcp:${rhost}:${rport}" "root" \
		"${SUPERVISOR_CONFD}" \
		"${DEBUG_LEVEL}"
done

###
### Supervisor: php-fpm
###
supervisor_add_service "php-fpm" "/usr/local/sbin/php-fpm" "root" "${SUPERVISOR_CONFD}" "${DEBUG_LEVEL}"

###
###
### Startup
###
log "info" "Starting supervisord" "${DEBUG_LEVEL}"
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
