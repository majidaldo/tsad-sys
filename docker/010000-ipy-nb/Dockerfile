FROM base

#deps

RUN apt-get install -y python-pip
RUN apt-get install -y ipython
RUN apt-get install -y ipython-notebook


#i'm running weave so this wont matter
EXPOSE 8888
COPY cmd.sh /root/cmd.sh
WORKDIR /data
CMD /root/cmd.sh
