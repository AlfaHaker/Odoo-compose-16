#!/bin/bash

set -e

# Fallback postgres connection parameters if not specified in odoo.conf or environment
: ${HOST:=${DB_PORT_5432_TCP_ADDR:='db'}}
: ${PORT:=${DB_PORT_5432_TCP_PORT:=5432}}
: ${USER:=${DB_ENV_POSTGRES_USER:=${POSTGRES_USER:='odoo'}}}
: ${PASSWORD:=${DB_ENV_POSTGRES_PASSWORD:=${POSTGRES_PASSWORD:='odoo16_db_passwd'}}}

# Install python packages if requirements.txt exists and contains active packages
if [ -f /etc/odoo/requirements.txt ] && grep -v -E '^\s*(#|$)' /etc/odoo/requirements.txt >/dev/null 2>&1; then
  pip3 install -r /etc/odoo/requirements.txt
fi

DB_ARGS=()
function check_config() {
  param="$1"
  value="$2"
  if [ -n "$ODOO_RC" ] && [ -f "$ODOO_RC" ] && grep -q -E "^\s*\b${param}\b\s*=" "$ODOO_RC"; then
    value=$(grep -E "^\s*\b${param}\b\s*=" "$ODOO_RC" | head -n 1 | sed -E 's/^\s*[^=]+=\s*//' | sed 's/["\n\r]//g')
  fi
  DB_ARGS+=("--${param}")
  DB_ARGS+=("${value}")
}

check_config "db_host" "$HOST"
check_config "db_port" "$PORT"
check_config "db_user" "$USER"
check_config "db_password" "$PASSWORD"

case "$1" in
-- | odoo)
  shift
  if [[ "$1" == "scaffold" ]]; then
    exec odoo "$@"
  else
    wait-for-psql.py ${DB_ARGS[@]} --timeout=30
    exec odoo "$@" "${DB_ARGS[@]}"
  fi
  ;;
-*)
  wait-for-psql.py ${DB_ARGS[@]} --timeout=30
  exec odoo "$@" "${DB_ARGS[@]}"
  ;;
*)
  exec "$@"
  ;;
esac

exit 1
