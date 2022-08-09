#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  Clone Repository
# -----------------------------------------------------------------------------
#  Author     : Dwi Fahni Denni
#  License    : Apache v2
# -----------------------------------------------------------------------------
set -e

GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa -o IdentitiesOnly=yes -F /dev/null' git clone --depth 5 $1 $2
