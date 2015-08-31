FROM ipy-nb

#deps

RUN apt-get install -y python-pip
RUN apt-get install -y python-numpy
RUN apt-get install -y python-scipy

RUN apt-get install -y git
WORKDIR /root
RUN git clone https://github.com/HIPS/Spearmint.git
#                 why backslash???
RUN pip install -e \Spearmint

