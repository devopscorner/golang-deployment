#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  Docker Tag Container (DockerHub)
# -----------------------------------------------------------------------------
#  Author     : Dwi Fahni Denni
#  License    : Apache v2
# -----------------------------------------------------------------------------
set -e

export AWS_ACCOUNT_ID=$1
export CI_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.ap-southeast-1.amazonaws.com"
export CI_ECR_PATH=$4

export IMAGE="$CI_REGISTRY/$CI_ECR_PATH"

# export CICD_VERSION="1.0.5"
# export ALPINE_VERSION="3.16"
# export UBUNTU_VERSION="22.04"
# export CODEBUILD_VERSION="4.0"

set_tag() {
  export TAGS_ID=$2
  export CUSTOM_TAGS=$3
  export BASE_IMAGE="$IMAGE:${TAGS_ID}"
  export COMMIT_HASH=`git log -1 --format=format:"%H"`

  if [ "$CUSTOM_TAGS" = "" ]; then
    export TAGS="${TAGS_ID} \
    ${TAGS_ID}-latest \
    ${TAGS_ID}-${COMMIT_HASH}"
  else
    export TAGS="${TAGS_ID} \
    ${TAGS_ID}-latest \
    ${TAGS_ID}-${CUSTOM_TAGS} \
    ${TAGS_ID}-${COMMIT_HASH}"
  fi
}

docker_tag() {
  for TAG in $TAGS; do
    echo "Docker Tags => $IMAGE:$TAG"
    echo ">> docker tag $BASE_IMAGE $IMAGE:$TAG"
    docker tag $BASE_IMAGE $IMAGE:$TAG
    echo '- DONE -'
    echo ''
  done
}

main() {
  # set_tag 0987654321 alpine 3.15 devopscorner/bookstore
  # set_tag 0987654321 alpine 3.16 devopscorner/bookstore
  set_tag ${AWS_ACCOUNT_ID} $2 $3 $4
  docker_tag
  echo ''
  echo '-- ALL DONE --'
}

### START HERE ###
main $1 $2 $3 $4
