FROM ubuntu:15.04
MAINTAINER Majid alDosari



# Setup environment

#restricted by gcc that was used to compile the kernel
#as of Aug '15, coreos kernel was compiled with gcc 4.8
#this is further complicated by compiler requirements
#of CUDA. todo: anyway to decouple this??
#for cuda 6
#ENV GCC_VER 4.7
#for cuda 7
ENV GCC_VER 4.8

RUN apt-get -y update && apt-get -y install \
    gcc-${GCC_VER} g++-${GCC_VER} \
    wget curl git make dpkg-dev module-init-tools && \
    mkdir -p /usr/src/kernels && \
    mkdir -p /opt/nvidia && \
    apt-get autoremove && apt-get clean
# Ensure we're using gcc version GCC_VER
RUN update-alternatives --install  /usr/bin/gcc gcc /usr/bin/gcc-${GCC_VER} 10


ENV CUDA_VER1 7
ENV CUDA_VER2 0
ENV CUDA_VER3 28
#ENV CUDA_VER1 6
#ENV CUDA_VER2 5
#ENV CUDA_VER3 14
ENV DRIVER_VER 355.06
#ENV DRIVER_VER 352.21
#todo: make a check for driver download existence
#installing the driver from cuda does not work
#maybe bc driver in cuda cant install in 4.x kernel
#ENV DRIVER_VER CUDA
#'CUDA' means whatever driver came with CUDA


# Download CUDA
# downloading CUDA JUST to expose nvidia_uvm kernel module
# by running devicequery from samples
# todo: do i have to install the samples?


#different urls for differnt versions. thx nvidia!
#if not caring about cuda
#RUN if [ "${CUDA_VER1}" -ge 7 ] && [ "${DRIVER_VER}" = "CUDA" ]
RUN if [ "${CUDA_VER1}" -ge 7 ] ; then curl http://developer.download.nvidia.com/compute/cuda/${CUDA_VER1}_${CUDA_VER2}/Prod/local_installers/cuda_${CUDA_VER1}.${CUDA_VER2}.${CUDA_VER3}_linux.run \
    > /opt/nvidia/cuda.run ; fi
#RUN if [ "${CUDA_VER1}" -lt 7 ] && [ "${DRIVER_VER}" = "CUDA" ]
RUN if [ "${CUDA_VER1}" -lt 7 ] ; then curl http://developer.download.nvidia.com/compute/cuda/${CUDA_VER1}_${CUDA_VER2}/rel/installers/cuda_${CUDA_VER1}.${CUDA_VER2}.${CUDA_VER3}_linux_64.run \
    > /opt/nvidia/cuda.run ; fi


# Download driver
# there is a driver in the cuda download BUT it doesn't work!
# as of CUDA 7.0.28

RUN mkdir -p /opt/nvidia
RUN if [ "$DRIVER_VER" != "CUDA" ]; then curl  http://us.download.nvidia.com/XFree86/Linux-x86_64/${DRIVER_VER}/NVIDIA-Linux-x86_64-${DRIVER_VER}.run \
    > /opt/nvidia/driver.run ; fi


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
RUN echo "if [ "$DRIVER_VER" = "CUDA" ]; then chmod +x ./cuda.run && ./cuda.run --silent --driver --kernel-source-path=/usr/src/kernels/linux/ && modprobe nvidia ; else  chmod +x driver.run && ./driver.run -q -a -n -s --kernel-source-path=/usr/src/kernels/linux/ && modprobe nvidia ; fi" >> install_nvidia  \
    && chmod +x install_nvidia
#todo: install with --compat32-libdir?

# Nvidia CUDA setup

RUN echo "chmod +x cuda.run && ./cuda.run --silent --toolkit --samples" \
    >> install_nvidia

# run samples setup

RUN echo "cd /usr/local/cuda/samples/1_Utilities/deviceQuery && make && ./deviceQuery" \
    >> install_nvidia

CMD /opt/nvidia/install_nvidia


# Common stuff
# in case this Dockerfile is used as a base to build images

ONBUILD WORKDIR /opt/nvidia
ONBUILD RUN chmod +x cuda.run
ONBUILD RUN chmod +x driver.run
#so when this dockerfile is called it just does the toolkit ...
#..and (not the kernel module)
#opengl support gives an error (not installed?) but the driver
#install may work anyways
ONBUILD RUN ./driver.run --silent --no-kernel-module --no-unified-memory --no-opengl-files
#the samples take space but are a great way to chk cuda
#you could remove --samples
ONBUILD RUN ./cuda.run --toolkit --samples --silent

# setup stuff
ONBUILD ENV PATH=/usr/local/cuda/bin:$PATH
ONBUILD ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

ONBUILD WORKDIR /root
ONBUILD CMD /bin/bash

