FROM ibmcom/db2
WORKDIR  /var/custom
ADD data.tar.gz .
COPY createschema.sh .
COPY sql_script.txt .
RUN chmod a+x createschema.sh
