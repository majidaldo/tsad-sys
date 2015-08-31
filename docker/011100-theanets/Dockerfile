FROM spearmint
WORKDIR /root
RUN git clone http://github.com/lmjohns3/theanets
RUN pip install climate
WORKDIR theanets
RUN python setup.py develop
