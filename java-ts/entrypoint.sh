#!/bin/bash
set -eo pipefail
shopt -s nullglob

bash ./bin/run.sh start
exec "bash"