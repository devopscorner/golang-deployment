#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  Docker Build Container
# -----------------------------------------------------------------------------
#  Author     : Dwi Fahni Denni
#  License    : Apache v2
# -----------------------------------------------------------------------------
set -e

export AWS_ACCOUNT_ID=$1
export AWS_DEFAULT_REGION="ap-southeast-1"
export CI_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
export CI_ECR_PATH=$2

export IMAGE="$CI_REGISTRY/$CI_ECR_PATH"
export TAG="alpine"

echo "============="
echo "  Login ECR  "
echo "============="
PASSWORD=`aws ecr get-login-password --region ${AWS_DEFAULT_REGION}`
echo $PASSWORD | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
echo '- DONE -'
echo ''

echo " Build Image => $IMAGE:$TAG"
docker build -f Dockerfile -t $IMAGE:$TAG .
