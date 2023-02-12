#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  Docker Build Container (DockerHub)
# -----------------------------------------------------------------------------
#  Author     : Dwi Fahni Denni
#  License    : Apache v2
# -----------------------------------------------------------------------------
set -e

# export CI_PROJECT_PATH="devopscorner"
# export CI_PROJECT_NAME="bookstore"

# export IMAGE="$CI_PROJECT_PATH/$CI_PROJECT_NAME"
export IMAGE=$2

docker_build() {
  export FILE=$1
  export BASE_IMAGE=$3
  export TAGS_ID=$4
  export CUSTOM_TAGS=$5

  if [ "$CUSTOM_TAGS" = "" ]; then
    echo "Build Image => $IMAGE:$BASE_IMAGE"
    echo ">> docker build -t $IMAGE:$BASE_IMAGE -f $FILE ."
    docker build -t $IMAGE:$BASE_IMAGE -f $FILE .
    echo '---'

    echo "Build Image => $IMAGE:$TAGS_ID"
    echo ">> docker build -t $IMAGE:$TAGS_ID -f $FILE ."
    docker build -t $IMAGE:$TAGS_ID -f $FILE .
    echo '---'

    echo "Build Image => $IMAGE:$BASE_IMAGE-$TAGS_ID"
    echo ">> docker build -t $IMAGE:$BASE_IMAGE-$TAGS_ID -f $FILE ."
    docker build -t $IMAGE:$BASE_IMAGE-$TAGS_ID -f $FILE .
    echo '---'
  else
    echo "Build Image => $IMAGE:$BASE_IMAGE"
    echo ">> docker build -t $IMAGE:$BASE_IMAGE -f $FILE ."
    docker build -t $IMAGE:$BASE_IMAGE -f $FILE .
    echo '---'

    echo "Build Image => $IMAGE:$TAGS_ID"
    echo "docker build -t $IMAGE:$TAGS_ID -f $FILE ."
    docker build -t $IMAGE:$TAGS_ID -f $FILE .
    echo '---'

    echo "Build Image => $IMAGE:$BASE_IMAGE-$TAGS_ID"
    echo ">> docker build -t $IMAGE:$BASE_IMAGE-$TAGS_ID -f $FILE ."
    docker build -t $IMAGE:$BASE_IMAGE-$TAGS_ID -f $FILE .
    echo '---'

    echo "Build Image => $IMAGE:$TAGS_ID-$CUSTOM_TAGS"
    docker build -t $IMAGE:$TAGS_ID-$CUSTOM_TAGS -f $FILE .
    echo ">> docker build -t $IMAGE:$TAGS_ID-$CUSTOM_TAGS -f $FILE ."
    echo '---'

    echo "Build Image => $IMAGE:$BASE_IMAGE-$TAGS_ID-$CUSTOM_TAGS"
    echo ">> docker build -t $IMAGE:$BASE_IMAGE-$TAGS_ID-$CUSTOM_TAGS -f $FILE ."
    docker build -t $IMAGE:$BASE_IMAGE-$TAGS_ID-$CUSTOM_TAGS -f $FILE .
    echo '---'
  fi
}

main() {
  # docker_build Dockerfile devopscorner/bookstore alpine [version|latest|tags] [custom-tags]
  docker_build $1 $2 $3 $4 $5
  echo ''
  echo '-- ALL DONE --'
}

### START HERE ###
main $1 $2 $3 $4 $5

### How to Execute ###
# ./dockerhub-build.sh Dockerfile [DOCKERHUB_IMAGE_PATH] [alpine] [version|latest|tags] [custom-tags]
