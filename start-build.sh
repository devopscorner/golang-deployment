#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  Docker Build Container
# -----------------------------------------------------------------------------
#  Author     : Dwi Fahni Denni
#  License    : Apache v2
# -----------------------------------------------------------------------------
set -e

export CI_PROJECT_PATH="devopscorner"
export CI_PROJECT_NAME="bookstore"

export IMAGE="$CI_PROJECT_PATH/$CI_PROJECT_NAME"

TAG="alpine-3.15"
echo " Build Image => $IMAGE:$TAG"
docker build --no-cache -f Dockerfile.alpine-3.15 -t $IMAGE:$TAG .
echo ""

TAG="go1.19.3-alpine3.15"
echo " Build Image => $IMAGE:$TAG"
docker build --no-cache -f Dockerfile.alpine-3.15 -t $IMAGE:$TAG .
echo ""

TAG="alpine-3.16"
echo " Build Image => $IMAGE:$TAG"
docker build --no-cache -f Dockerfile.alpine-3.16 -t $IMAGE:$TAG .
echo ""

TAG="go1.19.5-alpine3.16"
echo " Build Image => $IMAGE:$TAG"
docker build --no-cache -f Dockerfile.alpine-3.16 -t $IMAGE:$TAG .
echo ""

TAG="alpine-3.17"
echo " Build Image => $IMAGE:$TAG"
docker build --no-cache -f Dockerfile.alpine-3.17 -t $IMAGE:$TAG .
echo ""

TAG="go1.19.5-alpine3.17"
echo " Build Image => $IMAGE:$TAG"
docker build --no-cache -f Dockerfile.alpine-3.17 -t $IMAGE:$TAG .
echo ""

TAG="alpine"
echo " Build Image => $IMAGE:$TAG"
docker build --no-cache -f Dockerfile -t $IMAGE:$TAG .
echo ""

TAG="alpine-latest"
echo " Build Image => $IMAGE:$TAG"
docker build --no-cache -f Dockerfile -t $IMAGE:$TAG .
echo ""

echo "Cleanup Unknown Tags"
echo "docker images -a | grep none | awk '{ print $3; }' | xargs docker rmi"
docker images -a | grep none | awk '{ print $3; }' | xargs docker rmi
echo ""

echo "-- ALL DONE --"
