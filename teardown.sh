#!/bin/sh

mage KindTeardown

docker compose -f ../scripts-armada/dev/docker-compose.yaml down

docker volume prune -f
