#!/bin/sh

docker compose -f ../scripts-armada/dev/docker-compose.yaml run -d --service-ports postgres
docker compose -f ../scripts-armada/dev/docker-compose.yaml run -d --service-ports redis

go test $(go list ./internal/... | grep -v /jobservice/)

docker compose -f ../scripts-armada/dev/docker-compose.yaml down
