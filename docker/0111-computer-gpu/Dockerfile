FROM registry:5000/cuda
RUN apt-get update

WORKDIR /root
RUN curl https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh > conda.sh
RUN chmod +x conda.sh
RUN bash ./conda.sh -b -p /root/conda
RUN rm conda.sh
ENV PATH /root/conda/bin:$PATH


# computation essentials

RUN conda install -y pip
RUN conda install -y numpy
RUN conda install -y scipy
RUN conda install -y matplotlib
RUN conda install -y scikit-learn
RUN conda install -y ipython
RUN conda install -y ipython-notebook


# spearmint

WORKDIR /root
RUN git clone https://github.com/majidaldo/Spearmint.git spearmint
#                 why backslash???
RUN pip install -e \spearmint


# theano

RUN conda install -y nose
RUN apt-get install -y build-essential
RUN git clone --recursive git://github.com/Theano/Theano.git theano
RUN pip install --upgrade --no-deps -e theano
# Set up .theanorc 
RUN echo "[global]\ndevice=gpu\nfloatX=float32" > /root/.theanorc

# theanets

WORKDIR /root
RUN git clone --recursive http://github.com/lmjohns3/theanets
RUN pip install climate
WORKDIR theanets
RUN python setup.py develop

# support

RUN conda install -y ipyparallel
RUN conda install -y psutil
RUN pip install pymongo

#i'm running weave so this wont matter
EXPOSE 8888

COPY ipykernel.sh    /root/ipykernel
COPY ipyengine.sh    /root/ipyengine
COPY ipynotebook.sh  /root/ipynotebook
copy ipython.sh      /root/ipython
RUN echo "/usr/bin/bash" > /root/bash

WORKDIR /data
CMD /root/ipykernel.sh

RUN mkdir -p /root/.jupyter
RUN mkdir -p /root/.ipython


VOLUME /root/.ipython
VOLUME /root/.jupyter
