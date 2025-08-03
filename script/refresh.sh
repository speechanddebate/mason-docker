#!/bin/bash
cd /www/tabroom
git pull

cd /www/mason-docker
git pull
/usr/bin/docker compose -f docker-compose.staging.yml up --build --detach

