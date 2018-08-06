#!/bin/bash

name=mqu31/mattermost-docker-team-edition
version=5.1.0

docker build -t ${name}:${version} -t ${name}:latest .
