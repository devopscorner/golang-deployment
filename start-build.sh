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

build_alpine_315() {
    # DEPRECIATED for Alpine-3.15 ##
    TAGS="alpine-3.15 \
        3.15 \
        go1.19.3-alpine3.15 \
        go1.19-alpine3.15 "

    for TAG in $TAGS; do
        echo " Build Image => $IMAGE:$TAG"
        docker build \
            -f Dockerfile.alpine-3.15 \
            -t $IMAGE:$TAG .
        echo ''
    done
}

build_alpine_316() {
    TAGS="alpine-3.16 \
        3.16 \
        go1.19.5-alpine3.16 \
        go1.19-alpine3.16 "

    for TAG in $TAGS; do
        echo " Build Image => $IMAGE:$TAG"
        docker build \
            -f Dockerfile.alpine-3.16 \
            -t $IMAGE:$TAG .
        echo ''
    done
}

build_alpine_317() {
    TAGS="alpine-3.17 \
        3.17 \
        go1.19.5-alpine3.17 \
        go1.19-alpine3.17 "

    for TAG in $TAGS; do
        echo " Build Image => $IMAGE:$TAG"
        docker build \
            -f Dockerfile.alpine-3.17 \
            -t $IMAGE:$TAG .
        echo ''
    done
}

build_alpine_latest() {
    TAGS="latest \
        alpine-latest \
        alpine
        4.1 \
        4.2 "

    for TAG in $TAGS; do
        echo " Build Image => $IMAGE:$TAG"
        docker build \
            -f Dockerfile \
            -t $IMAGE:$TAG .
        echo ''
    done
}

docker_build() {
    # Depreciated Alpine-3.15
    # build_alpine_315
    build_alpine_316
    build_alpine_317
    build_alpine_latest
}

docker_clean() {
    echo "Cleanup Unknown Tags"
    echo "docker images -a | grep none | awk '{ print $3; }' | xargs docker rmi"
    docker images -a | grep none | awk '{ print $3; }' | xargs docker rmi
    echo ''
}

main() {
  docker_build
  docker_clean
  echo ''
  echo '-- ALL DONE --'
}

### START HERE ###
main