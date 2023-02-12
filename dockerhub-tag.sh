#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  Docker Tag Container (DockerHub)
# -----------------------------------------------------------------------------
#  Author     : Dwi Fahni Denni
#  License    : Apache v2
# -----------------------------------------------------------------------------
set -e

# export CI_PROJECT_PATH="devopscorner"
# export CI_PROJECT_NAME="bookstore"

# export IMAGE="$CI_PROJECT_PATH/$CI_PROJECT_NAME"
export IMAGE=$1

set_tag() {
  export BASE_IMAGE=$2
  export TAGS_ID=$3
  export CUSTOM_TAGS=$4
  export COMMIT_HASH=$(git log -1 --format=format:"%H")

  if [ "$CUSTOM_TAGS" = "" ]; then
    export TAGS="$TAGS_ID \
    $BASE_IMAGE-$TAGS_ID \
    $TAGS_ID-$COMMIT_HASH \
    $BASE_IMAGE-$COMMIT_HASH "
  else
    export TAGS="$TAGS_ID \
    $BASE_IMAGE-$TAGS_ID \
    $TAGS_ID-$COMMIT_HASH \
    $BASE_IMAGE-$COMMIT_HASH \
    $TAGS_ID-$CUSTOM_TAGS"
  fi
}

docker_tag() {
  for TAG in $TAGS; do
    echo "Docker Tags => $IMAGE:$TAG"
    echo ">> docker tag $IMAGE:$BASE_IMAGE $IMAGE:$TAG"
    docker tag $IMAGE:$BASE_IMAGE $IMAGE:$TAG
    echo '- DONE -'
    echo ''
  done
}

main() {
  # set_tag devopscorner/bookstore alpine [version|latest|tags] [custom-tags]
  set_tag $1 $2 $3 $4
  docker_tag
  echo ''
  echo '-- ALL DONE --'
}

### START HERE ###
main $1 $2 $3 $4

### How to Execute ###
# ./dockerhub-tag.sh [DOCKERHUB_IMAGE_PATH] [alpine] [version|latest|tags] [custom-tags]
