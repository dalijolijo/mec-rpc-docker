#!/bin/bash

docker-compose -f docker-compose-electrumx.yml down
docker system prune -f
