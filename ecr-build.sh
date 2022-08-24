#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  Docker Push Container (DockerHub)
# -----------------------------------------------------------------------------
#  Author     : Dwi Fahni Denni
#  License    : Apache v2
# -----------------------------------------------------------------------------
set -e

export AWS_ACCOUNT_ID=$1
export CI_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.ap-southeast-1.amazonaws.com"
export CI_ECR_PATH=$4

export IMAGE="$CI_REGISTRY/$CI_ECR_PATH"

login_ecr() {
  echo "============="
  echo "  Login ECR  "
  echo "============="
  PASSWORD=`aws ecr get-login-password --region ap-southeast-1`
  echo $PASSWORD | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.ap-southeast-1.amazonaws.com
  echo '- DONE -'
  echo ''
}

docker_build() {
  export TAGS_ID=$2
  export FILE=$3
  export CUSTOM_TAGS=$4

  if [ "$CUSTOM_TAGS" = "" ]; then
    echo "Build Image => $IMAGE:${TAGS_ID}"
    echo ">> docker build -t $IMAGE:${TAGS_ID} -f $FILE ."
    docker build -t $IMAGE:${TAGS_ID} -f $FILE .
  else
    echo "Build Image => $IMAGE:${TAGS_ID}"
    echo "docker build -t $IMAGE:${TAGS_ID} -f $FILE ."
    docker build -t $IMAGE:${TAGS_ID} -f $FILE .

    echo "Build Image => $IMAGE:${TAGS_ID}-${CUSTOM_TAGS}"
    docker build -t $IMAGE:${TAGS_ID}-${CUSTOM_TAGS} -f $FILE .
    echo ">> docker build -t $IMAGE:${TAGS_ID}-${CUSTOM_TAGS} -f $FILE ."
  fi
}

main() {
  # login_ecr
  # docker_build 0987654321 alpine Dockerfile devopscorner/bookstore
  # docker_build 0987654321 alpine Dockerfile.alpine-3.15 devopscorner/bookstore
  # docker_build 0987654321 alpine Dockerfile.alpine-3.16 devopscorner/bookstore
  docker_build $1 $2 $3 $4
  echo ''
  echo '-- ALL DONE --'
}

### START HERE ###
main $1 $2 $3 $4
