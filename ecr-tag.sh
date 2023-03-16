#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  Docker Tag Container (Elastic Container Registry - ECR)
# -----------------------------------------------------------------------------
#  Author     : Dwi Fahni Denni
#  License    : Apache v2
# -----------------------------------------------------------------------------
set -e

export AWS_ACCOUNT_ID=$1
export AWS_DEFAULT_REGION="us-west-2"
export CI_REGISTRY="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com"
export CI_ECR_PATH=$2

export IMAGE="$CI_REGISTRY/$CI_ECR_PATH"

set_tag() {
  export BASE_IMAGE=$3
  export TAGS_ID=$4
  export CUSTOM_TAGS=$5
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
  # set_tag 0987654321 devopscorner/bookstore alpine [version|latest|tags] [custom-tags]
  set_tag $1 $2 $3 $4 $5
  docker_tag
  echo ''
  echo '-- ALL DONE --'
}

### START HERE ###
main $1 $2 $3 $4 $5

### How to Execute ###
# ./ecr-tag.sh [AWS_ACCOUNT] [ECR_PATH] [alpine|codebuild] [version|latest|tags] [custom-tags]
