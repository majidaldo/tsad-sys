FROM ubuntu:15.04
MAINTAINER Matthew Hook <hookenz@gmail.com>


# Setup environment

RUN apt-get -y update && apt-get -y install gcc-4.8 \
    wget curl git make dpkg-dev module-init-tools && \
    mkdir -p /usr/src/kernels && \
    mkdir -p /opt/nvidia && \
    apt-get autoremove && apt-get clean
# Ensure we're using gcc 4.8
RUN update-alternatives --install  /usr/bin/gcc gcc /usr/bin/gcc-4.8 10

#ENV KERNEL_VER $(uname -r | grep -o '[0-9].[0-9].[0-9]')
ENV DRIVER_VER 352.21


# Download driver

RUN mkdir -p /opt/nvidia
# Downloading early so we fail early if we can't get the key ingredient
RUN curl  /opt/nvidia http://us.download.nvidia.com/XFree86/Linux-x86_64/$DRIVER_VER/NVIDIA-Linux-x86_64-$DRIVER_VER.run \
    > /opt/nvidia/driver.run


# Download kernel source and prepare modules

WORKDIR /usr/src/kernels
RUN curl https://www.kernel.org/pub/linux/kernel/v`uname -r | grep -o '^[0-9]'`.x/linux-`uname -r | grep -o '[0-9].[0-9].[0-9]'`.tar.xz \
    > linux.tar.xz
RUN mkdir linux
RUN tar -xvf linux.tar.xz -C linux --strip-components=1
WORKDIR linux
RUN  zcat /proc/config.gz > .config
RUN make modules_prepare
RUN echo "#define UTS_RELEASE \"$(uname -r)\"" \
    > include/generated/utsrelease.h


# Nvidia drivers setup

WORKDIR /opt/nvidia
RUN echo "./driver.run -q -a -n -s --kernel-source-path=/usr/src/kernels/linux/ && modprobe nvidia" >> install_kernel_module && \
    chmod +x driver.run install_kernel_module
#todo: install with --compat32-libdir?

#idk why the brackets result in exec format error
CMD /opt/nvidia/install_kernel_module

