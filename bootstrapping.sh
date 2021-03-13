#!/bin/bash
set -x
VERSION=1.9.9.6

#Install needed packages
dpkg-query -l unzip > /dev/null
if [ $? -ne 0 ] ; then
        apt-get install -y unzip
fi

if [ ! -d ./bootstrap ]; then
   mkdir ./bootstrap
fi
cd ./bootstrap

if [ ! -f ./bootstrap.zip ]; then
   wget https://github.com/LIMXTEC/Megacoin/releases/download/${VERSION}/bootstrap-09-2020.zip -O bootstrap.zip
fi
if [ ! -d ./blocks ]; then
   unzip bootstrap.zip
fi

cd ..

#./stop-electrumx.sh
docker-compose -f docker-compose-rpc.yml down 
rm -rf /home/megacoin/blocks
rm -rf /home/megacoin/chainstate
cp -r ./bootstrap/blocks/ ./bootstrap/chainstate/ /home/megacoin
#./start-electrumx.sh
docker-compose -f docker-compose-rpc.yml up -d
