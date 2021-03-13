#!/bin/bash

docker exec -it megacoin-rpc megacoin-cli -datadir=/data -conf=/data/megacoin.conf -rpcconnect=172.21.0.11 -rpcuser=mec-rpc-user -rpcpassword=mec-rpc-pwd -rpcport=7952 mnsync status

