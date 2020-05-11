#!/bin/sh
set -e

/data/script/createConfigs.sh

exec "$@"
