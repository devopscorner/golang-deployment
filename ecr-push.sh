#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  Docker Push Container (Elastic Container Registry - ECR)
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

login_ecr() {
  echo "============="
  echo "  Login ECR  "
  echo "============="
  PASSWORD=$(aws ecr get-login-password --region $AWS_DEFAULT_REGION)
  echo $PASSWORD | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
  echo '- DONE -'
  echo ''
}

docker_push() {
  export TAGS_ID=$3
  IMAGES=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep $IMAGE:${TAGS_ID})
  for IMG in $IMAGES; do
    echo "Docker Push => $IMG"
    echo ">> docker push $IMG"
    docker push $IMG
    echo '- DONE -'
    echo ''
  done
}

main() {
  login_ecr
  # docker_push 0987654321 devopscorner/bookstore [alpine|version|latest|tags|custom-tags]
  docker_push $1 $2 $3
  echo ''
  echo '-- ALL DONE --'
}

### START HERE ###
main $1 $2 $3

### How to Execute ###
# ./ecr-push.sh [AWS_ACCOUNT] [ECR_PATH] [alpine|latest|tags|custom-tags]
