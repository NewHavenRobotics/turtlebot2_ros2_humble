#!/bin/bash
set -e

# setup ros2 environment
source "/root/robot/install/setup.sh" --
exec "$@"