# CoreOS-Nvidia
This is a Dockerfile that builds a container with nvidia drivers.  Once built running the container in privileged mode will install the kernel module.

It should be built on a machine running the same CoreOS version as the target machine (the one with the Nvidia card installed), if not the target machine itself.  Of course the container can only be run on a machine with Nvidia hardware installed.

### To Build

    docker build -t coreos-nvidia .    

### To Run

    docker run --privileged=true -t coreos-nvidia

To confirm the module is loaded.

    lsmod | grep -i nvidia

#### Notes

There may be a batter base image, and some post build cleanup that could be done to make the container smaller.

Currently the build uses `uname -r` to detect the running kernel version.  There maybe be a better way to do this that offers more flexibility.

Also, the driver version is hard coded (`cuda_6.5.14_linux_64`), automatically finding the latest driver would be a nice improvement.
