#!/bin/sh
#
#	Set varibles used by the database accessing commands.
#	This is not normally calle directly.
#
DOCKER_IP=192.168.59.103
SSH_PORT=49160
HTTP_PORT=49161
DB_PORT=49162
export DOCKER_HOST=tcp://${DOCKER_IP}:2375

# And the most project specific variable...
DB_NAME=myjunk
