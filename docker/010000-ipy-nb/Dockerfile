FROM base

#deps

RUN apt-get install -y python-pip
RUN apt-get install -y ipython
RUN apt-get install -y ipython-notebook


# common numerical python stuff
RUN apt-get install -y python-matplotlib


#i'm running weave so this wont matter
EXPOSE 8888
COPY cmd.sh /root/cmd.sh
WORKDIR /data
CMD /root/cmd.sh
