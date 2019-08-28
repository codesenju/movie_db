FROM ibmcom/db2

RUN mkdir  /var/custom
COPY . /var/custom

RUN tar -zxvf /var/custom/data.tar.gz
RUN mv *.ixf /var/custom
RUN rm -rf /var/custom/data.tar.gz
RUN chmod a+x /var/custom/createschema.sh
