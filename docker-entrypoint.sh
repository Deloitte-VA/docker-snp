#!/bin/bash
set -e

ADDR=${MONGO_PORT_27017_TCP_ADDR?Error address is not defined.  Please link to mongodb server or set environment variable.}
sed -i "s/\(mongodb.host\w*=\w*.*\)\(?:$|\n|\r\)*/mongodb.host=$ADDR/g" $CATALINA_HOME/lib/config.properties

PORT=${MONGO_PORT_27017_TCP_PORT?Error port is not defined.  Please link to mongodb server or set environment variable.}
sed -i "s/\(mongodb.port\w*=\w*.*\)\(?:$|\n|\r\)*/mongodb.port=$PORT/g" $CATALINA_HOME/lib/config.properties

exec "$@"
