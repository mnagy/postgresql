#!/bin/bash

source ${HOME}/common.sh

function initialize_replica() {
  echo "Initializing replica"
  chmod 0700 $PGDATA
  local master=$(postgresql_master_addr)
  PGPASSWORD="${POSTGRESQL_PASSWORD}" pg_basebackup -x --no-password --pgdata ${PGDATA} --host=${master} --port=5432 -U "${POSTGRESQL_USER}"
  # PostgreSQL recovery configuration.
  cat >> "$PGDATA/recovery.conf" <<-EOF

    # Custom OpenShift recovery configuration:
    include '../openshift-custom-recovery.conf'
EOF

  envsubst < ${POSTGRESQL_RECOVERY_FILE}.template > ${POSTGRESQL_RECOVERY_FILE}
}

check_env_vars
generate_postgresql_config
generate_passwd_file
initialize_replica
unset_env_vars

# Testing
pg_ctl -w start
pg_ctl stop

exec postgres "$@"
