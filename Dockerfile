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

#not allowed in Dockerfile!
#ENV KERNEL_VER $(uname -r | grep -o '[0-9].[0-9].[0-9]')
ENV CUDA_VER1 7
ENV CUDA_VER2 0
ENV CUDA_VER3 28
ENV DRIVER_VER 352.21


# Download CUDA
# downloading CUDA JUST to expose nvidia_uvm kernel module
# by running devicequery from samples
# todo: do i have to install the samples?

RUN curl http://developer.download.nvidia.com/compute/cuda/${CUDA_VER1}_${CUDA_VER2}/Prod/local_installers/cuda_${CUDA_VER1}.${CUDA_VER2}.${CUDA_VER3}_linux.run \
    > /opt/nvidia/cuda.run


# Download driver
# there is a driver in the cuda download BUT it doesn't work!
# as of CUDA 7.0.28

RUN mkdir -p /opt/nvidia
# Downloading early so we fail early if we can't get the key ingredient
RUN curl  http://us.download.nvidia.com/XFree86/Linux-x86_64/${DRIVER_VER}/NVIDIA-Linux-x86_64-${DRIVER_VER}.run \
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
RUN echo "./driver.run -q -a -n -s --kernel-source-path=/usr/src/kernels/linux/ && modprobe nvidia" >> install_nvidia && \
    chmod +x driver.run install_nvidia
#todo: install with --compat32-libdir?

# Nvidia CUDA setup

RUN echo "./cuda.run --silent --toolkit --samples" \
    >> install_nvidia && \
    chmod +x cuda.run

# run samples setup

RUN echo "cd /usr/local/cuda/samples/1_Utilities/deviceQuery && make && ./deviceQuery" \
    >> install_nvidia && \
    chmod +x cuda.run


CMD /opt/nvidia/install_nvidia

