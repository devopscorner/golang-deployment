#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  Docker Build Container (Elastic Container Registry - ECR)
# -----------------------------------------------------------------------------
#  Author     : Dwi Fahni Denni
#  License    : Apache v2
# -----------------------------------------------------------------------------
set -e

export AWS_ACCOUNT_ID=$1
export AWS_DEFAULT_REGION="us-west-2"
export CI_REGISTRY="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com"
export CI_ECR_PATH=$3

export IMAGE="$CI_REGISTRY/$CI_ECR_PATH"

docker_build() {
  export FILE=$2
  export BASE_IMAGE=$4
  export TAGS_ID=$5
  export CUSTOM_TAGS=$6

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

    echo "Build Image => $IMAGE:$TAGS_ID-${CUSTOM_TAGS}"
    docker build -t $IMAGE:$TAGS_ID-${CUSTOM_TAGS} -f $FILE .
    echo ">> docker build -t $IMAGE:$TAGS_ID-${CUSTOM_TAGS} -f $FILE ."
    echo '---'

    echo "Build Image => $IMAGE:$BASE_IMAGE-$TAGS_ID-${CUSTOM_TAGS}"
    echo ">> docker build -t $IMAGE:$BASE_IMAGE-$TAGS_ID-${CUSTOM_TAGS} -f $FILE ."
    docker build -t $IMAGE:$BASE_IMAGE-$TAGS_ID-${CUSTOM_TAGS} -f $FILE .
    echo '---'
  fi
}

main() {
  # docker_build 0987654321 Dockerfile devopscorner/bookstore alpine [version|latest|tags] [custom-tags]
  # docker_build 0987654321 Dockerfile.alpine-3.15 devopscorner/bookstore alpine [version|latest|tags] [custom-tags]
  # docker_build 0987654321 Dockerfile.alpine-3.16 devopscorner/bookstore alpine [version|latest|tags] [custom-tags]
  docker_build $1 $2 $3 $4 $5 $6
  echo ''
  echo '-- ALL DONE --'
}

### START HERE ###
main $1 $2 $3 $4 $5 $6

### How to Execute ###
# ./ecr-build.sh [AWS_ACCOUNT] Dockerfile [ECR_PATH] [alpine] [version|latest|tags] [custom-tags]
