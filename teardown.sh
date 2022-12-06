#!/bin/sh

kind delete cluster --name demo-a

docker compose -f ../scripts-armada/dev/docker-compose.yaml down

docker volume prune -f
