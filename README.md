# Turtlebot2 on ROS2

### Original Maintainer: [Ingot Robotics](https://ingotrobotics.com)
### Branch Maintainer: NewHavenRobotics

*This Readme has been modified to relfect the changes made in this fork. This fork is stripped down to simply connect to the base, no sensors. It also is modified to use Humble, not Iron. It also uses the offical ROS image from DockerHub. It also has an entrypoint thats been added so it can be run with a oneliner.*

# Quick Start

Build

    docker build -t turtlebot2-ros-humble:humble -f turtlebot2_ros2.dockerfile --build-arg from_image=ros:humble --build-arg parallel_jobs=4 .

Copy Udev Rules

    sudo cp 60-kobuki.rules /etc/udev/rules.d/ 

Youll probably need to be in dialout group if you aren't already. This typically requires a system restart:

    sudo adduser $USER dialout

One liner to start docker container and ros node 

    docker run -it --network=host --pid=host --v /dev:/dev --device=/dev/kobuki turtlebot2-ros-humble:humble ros2 launch kobuki_node kobuki_node-launch.py




### *--Original Readme with some modifications. See original repo to see fully original Readme--*

There have been previous efforts to support Turtlebot2 (based on Yujin's Kobuki mobile base), but none of them are docker-based nor supporting ROS2 humble. This repository is our attempt to address this. We followed and then edited the instructions for the release-1.0.x for the Kobuki <https://kobuki.readthedocs.io/en/release-1.0.x/software.html>, and we took inspiration from the ROS 2 Bouncy Turtlebot2 repo: <https://github.com/ros2/turtlebot2_demo/tree/master>.

The repository contains a dockerfile, two udev rules files, and two packages to run a Turtlebot2.

Additional navigation sensors may be added if requested, and pull requests are always appreciated.


## Setup

After building up the Turtlebot2 and installing Ubuntu 22.04 on the robot computer, install Docker (`docker.io`), git, and any other favorite packages. We use a separate laptop for controlling the robot, so the robot computer also needs Open-SSH server and tmux.

Clone this repo, and from that directory, the dockerfile can be built with the command
`docker build -t turtlebot2-ros-humble:humble -f turtlebot2_ros2.dockerfile --build-arg from_image=ros:humble --build-arg parallel_jobs=4 .` <- Don't forget the dot.
The dockerfile has default values for the base image (`ros:humble`) and parallel build jobs (8), but the command above overrides the defaults. Adjust as fits your needs.

The robot computer needs the udev rules installed in `/etc/udev/rules.d/`. The Kobuki udev rule comes from the [Kobuki](https://github.com/kobuki-base) organization: <https://raw.githubusercontent.com/kobuki-base/kobuki_ftdi/devel/60-kobuki.rules>.

After the docker container is built, it can be launched with the command
`docker run -it -v /dev:/dev --device=/dev/kobuki <container name>`.
If you are not running any of the Kobuki utilities like `kobuki-version-info`, you can omit the `--device=/dev/kobuki` switch.
If you will run rviz on a separate machine, adding `--network=host` is a docker networking work-around to allow containers on separate machines but the same local network to communicate.

Inside the docker container, first source the overlay: `source install/setup.bash`, then launch the Turtlebot2 with `ros2 launch turtlebot2_bringup turtlebot2_bringup.launch.py`

The Turtlebot2 can be controlled by a separate instance of the same container. To run this instance, drop all of the `--device` switches from the `docker run` command above. Once in the container, source the overlay, and then run a keyboard or joystick control node, such as `ros2 run kobuki_keyop kobuki_keyop_node` or `ros2 run teleop_twist_keyboard teleop_twist_keyboard`. Alternatively, `rviz2` and the Navigation2 stacks allow the use of naviation goals on the map.

If you want to interact with the Kobuki base without bringing up the full Turtlebot2 stack, launch the Kobuki with `ros2 launch kobuki_node kobuki_node-launch.py` and run keyboard teleoperation with remapping for the velocity commands:
`ros2 run kobuki_keyop kobuki_keyop_node --ros-args --remap /cmd_vel:=/commands/velocity` or `ros2 run teleop_twist teleop_twist_keyboard --ros-args -r /cmd_vel:=/commands/velocity`.





