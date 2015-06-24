#!/bin/bash

source ${HOME}/common.sh

check_env_vars

generate_postgresql_config
generate_passwd_file

initialize_database

unset_env_vars
exec postgres "$@"
