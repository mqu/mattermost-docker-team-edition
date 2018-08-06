#!/bin/bash

# local volumes for mattermost and mysql database
mkdir -p ./volumes/app/mattermost/{data,logs,config}
mkdir -p ./volumes/srv/backup

docker-compose up -d
