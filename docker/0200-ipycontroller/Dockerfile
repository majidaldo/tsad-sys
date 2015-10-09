FROM registry:5000/base

WORKDIR /root
RUN curl https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh > conda.sh
RUN chmod +x conda.sh
RUN bash ./conda.sh -b -p /root/conda
RUN rm conda.sh
ENV PATH /root/conda/bin:$PATH

#future ipyparallel fixes pymongo problem
RUN conda install -y ipyparallel
#as of 10/8/'15 pymongo 3 doesn't work w/ ipyp
RUN conda install -y pymongo=2.8 

WORKDIR /root
COPY cmd.sh /root/cmd.sh
VOLUME /root/.ipython

CMD /root/cmd.sh
EXPOSE 4321
