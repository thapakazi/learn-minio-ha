#!/bin/bash 

set -xeu

apk update
apk add wget

wget http://192.168.1.67:8000/minio -O /bin/minio \
    || wget https://dl.minio.io/server/minio/release/linux-amd64/minio -O /bin/minio
