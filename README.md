## Easy use of MySQL on OSX machines

The shell commands in this repo allow you to easily fire up a MySQL instance on OSX.

A first database can be set up in a few minutes (while you wait for the download), and subsequent databases can be created in a few seconds. With a few scripts, databases can be instantly fired up or shut down for testing purposes or during application development. It is intended that these scripts along with relevant data files will be checked into our project repositories.

They work by using [Docker](https://www.docker.com), a highly efficient virtualization technology. Docker allows MySQL to be run with out the complications of installing it on OSX. It also allows multiple project-specific databases to run concurrently.

The commands here also run PhpMyAdmin, a great web interface for administering MySQL, and are based on the Docker image [wnameless/mysql-phpmyadmin](https://registry.hub.docker.com/u/wnameless/mysql-phpmyadmin/). (kudos to @wnameless)



#### A problem solved
On OSX we run Docker using [Boot2Docker](https://github.com/boot2docker/boot2docker). This is required because Docker is Linux, not OSX. To get around this Boot2Docker installs VirtualBox, and runs Docker inside a virtual machine.

A Docker container normally has all it's file system destroyed when it is shut down. For a database Docker container, this means that the contents of the database are lost.

To allow persistence, Docker allows a Docker container (a small Linux 'container', running inside Docker Linux virtual machine, which runs on OSX via VirtualBox) to create _volumes_. With a volume, a directory inside the container is actually a directory on the host machine. Unfortunately with Boot2Docker the volumes are created on the Virtual machine running in Virtual Box, not on the OSX desktop filesystem.

The scripts in the repo make it easy to start and stop a MySql database, and to load and dump it's contents from an OSX project directory. The Docker image also has PhpMyAdmin installed, a great web interface for administering MySQL databases.


#### Installation

1. Make sure you have [Boot2Docker](http://docs.docker.com/installation/mac/) installed on your machine.

    $ git clone https://github.com/twistresources/docker-mysql-phpmyadmin.git
    
2. Place the downloaded files into a nicer location and tidy up.

    $ mv docker-mysql-phpmyadmin db  
    $ rm -rf db/.git

3. Update the configuration file `db/dbenv.sh`:

  DB_NAME - This name of a database you wish to create for your application.

  DOCKER_IP - This probably doesn't need to be this changed, but check it matches the output of `boot2docker ip`.


#### Commands

To start the database run:

    $ db/dbrun
    
First time in this will download the Docker image, which takes a while, but it's much faster subsequently. Once it starts it tails the database log to the console. You can then access PhpMyAdmin from your browser, at

    http://192.168.59.103:49161/phpmyadmin.

or you can jump to this page using:

    $ db/dbadmin

__Note__: After the first login you will need to use the web interface to create a database with the name you specified for the `DB_NAME` config variable.

If you wish to log into the MySQL container, you can use the following command. This and the other commands below use the default password 'admin'. If you will be using the database a lot it's a good idea to set up SSH keys for password-less login.

    $ db/dbssh
    

You can back up the database at any time using:

    $ db/dbdump
    
This command creates sequentially named data files. Note though that whenever you shut down the database it will run this data dump before shutting the server down.

    $ db/dbstop
    
After each restart the database will be empty, but can be reloaded with the most recently dumped contents using

    $ db/dbload
    
    
#### Multiple Projects
The `db/dbenv.sh` config file contains three port numbers (`SSH_PORT`, `HTTP_PORT` and `DB_PORT`) and a name for the Docker container (`CONTAINER_NAME`). These don't normally need to be changed, but if you wish to run multiple instances of MySQL database - one for each development project - simply set unique values for these variables in the config of each project.

--
