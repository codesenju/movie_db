# Part 1 - Prerequisites
Register at LinuxOne Community Cloud for a trial account. We will be using a RHEL base image for this journey, so be sure to choose the 'Request your trial' button on the left side of this page.
Install git: https://git-scm.com/downloads 
Install docker:
```shell
$ sudo su
cd ~
$ yum -y install wget
$ wget ftp://ftp.unicamp.br/pub/linuxpatch/s390x/redhat/rhel7.3/docker-17.05.0-ce-rhel7.3-20170523.tar.gz
ar -xzvf docker-17.05.0-ce-rhel7.3-20170523.tar.gz
$ cp docker-17.05.0-ce-rhel7.3-20170523/docker* /usr/bin/
$ docker daemon -g /local/docker/lib &
```
# Part 2 – Build a IBM db2 Database Container
```shell
$ git clone https://github.com/codesenju/imdb_lite.git
$ cd imdb_lite 
```

Download data.tar.gz file [here](https://mega.nz/#!BF0BRYAY!9vIGSwVtLU_FYtJf87WaxnAcrcaBHgJzDiGSInP359k) which has the records for the movie database.

Copy the data.tar.gz into your folder /imdb_lite
Run the command $ `` ls -alh ``and your folder /imdb_lite should be looking like this below:
 
If your directory looks similar to the above image now you can move on to the next step to build your db2 image.
```shell
$ docker build -t codesenju/imdb_lite .
```

Create a container network that will be used by your two micro services.
```shell 
docker network create mynet
```
Run your db2 image as a container
```shell
docker run -itd --net mynet --name micro_db2 --privileged=true -p 50000:50000 -e LICENSE=accept -e DB2INST1_PASSWORD=db2admin -e DBNAME=MOVIE -v /usr/src/app:/database codesenju/imdb_lite
```
After successfully running the last command you can check if you have a container instance of db2 running by executing the following `` docker ps ``
 

Now we going to login into the db2 container and configure the database schema
```shell
docker exec -ti <CONTAINER-ID> bash -c “su - db2inst1”
``` 
Run the script `` ./createschema.sh `` to create the database schema and import table records.
When you're done exit the container with ``$ exit ``

# Part 3 – Node.Js Middleware API 
```shell
$ cd ~
$ git clone https://github.com/codesenju/nodejs_api4db2.git
$ cd nodejs_api4db2
$ docker build -t codesenju/nodejs_api4db2 .
$ docker run --net mynet -p 49160:8081 -d codesenju/nodejs_api4db2
```
# Part 4 - Test
```shell
curl localhost:49160
```

 
 
