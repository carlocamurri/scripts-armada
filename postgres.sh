#!/bin/sh

docker compose -f ../scripts-armada/dev/docker-compose.yaml run -d --service-ports postgres
