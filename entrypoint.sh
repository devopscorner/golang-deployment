#!/usr/bin/env ash

export ALPINE_VERSION=${ALPINE_VERSION:-3.17}
export GIN_MODE=release
export PORT=${PORT:-8080}
export DBNAME=${DBNAME:-go-bookstore.db}
export AUTH_USERNAME=${AUTH_USERNAME:-devopscorner}
export AUTH_PASSWORD=${AUTH_PASSWORD:-DevOpsCorner@2023}
export JWT_SECRET=${JWT_SECRET:-s3cr3t}

exec /usr/local/bin/goapp