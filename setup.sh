#!/bin/sh

stream_backend="$1"

if [ -z "$stream_backend" ] || (echo "stan jetstream pulsar" | grep -v -q "$stream_backend"); then
  stream_backend="pulsar"
fi
echo "Using $stream_backend"

mage Kind || exit 1
# kind create cluster --name demo-a --config ../scripts-armada/dev/kind.yaml
docker compose -f ../scripts-armada/dev/docker-compose.yaml up -d

sleep 20

go run ./cmd/lookout/main.go --migrateDatabase --config ../scripts-armada/dev/config/lookout/base.yaml
go run ./cmd/lookoutv2/main.go --migrateDatabase --config ../scripts-armada/dev/config/lookoutv2/base.yaml

if [ "$stream_backend" = "pulsar" ]; then
  docker exec pulsar /bin/sh -c '/scripts/pulsar-setup.sh'
fi

if [ "$stream_backend" = "pulsar" ]; then
  echo "go run ./cmd/armada/main.go --config ../scripts-armada/dev/config/armada/base.yaml --config ../scripts-armada/dev/config/armada/stan.yaml --config ../scripts-armada/dev/config/armada/$stream_backend.yaml"
  echo "go run ./cmd/lookoutingester/main.go --config ../scripts-armada/dev/config/lookoutingester/$stream_backend.yaml"
else
  echo "go run ./cmd/armada/main.go --config ../scripts-armada/dev/config/armada/base.yaml --config ../scripts-armada/dev/config/armada/$stream_backend.yaml"
fi
echo "go run ./cmd/lookout/main.go --config ../scripts-armada/dev/config/lookout/base.yaml --config ../scripts-armada/dev/config/lookout/$stream_backend.yaml"

echo 'ARMADA_APPLICATION_CLUSTERID=demo-a ARMADA_METRIC_PORT=9001 go run ./cmd/executor/main.go --config ../scripts-armada/dev/config/executor/base.yaml'
echo "go run ./cmd/binoculars/main.go --config ../scripts-armada/dev/config/binoculars/base.yaml"

echo "go run ./cmd/lookoutingesterv2/main.go"
echo "go run ./cmd/lookoutv2/main.go"
