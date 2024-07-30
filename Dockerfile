# Use ROS base image
FROM ros:melodic-ros-core

# Set environment variables
ENV TURTLEBOT3_MODEL=burger
ENV DEBIAN_FRONTEND=noninteractive

RUN rm -vf /var/lib/apt/lists/* \
    && apt-get update \
    && y | apt-get install git -y

# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    python-catkin-tools \
    ros-melodic-turtlebot3 \
    ros-melodic-turtlebot3-simulations \
    ros-melodic-turtlebot3-gazebo \
    && rm -rf /var/lib/apt/lists/*

# Create and initialize the workspace
RUN mkdir -p /root/catkin_ws/src
WORKDIR /root/catkin_ws

# Clone TurtleBot 3 repositories
RUN git clone -b melodic-devel https://github.com/ROBOTIS-GIT/turtlebot3.git src/turtlebot3
RUN git clone -b melodic-devel https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git src/turtlebot3_msgs
RUN git clone -b melodic-devel https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git src/turtlebot3_simulations

# Build the workspace
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && catkin_make"

# Source the setup file
RUN echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc

# Default command to run
CMD ["bash"]
