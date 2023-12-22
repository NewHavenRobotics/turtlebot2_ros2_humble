#!/bin/bash
set -e

# setup ros2 environment
source "/opt/ros/humble/setup.bash"
source "/root/robot/install/setup.bash"
exec "$@"