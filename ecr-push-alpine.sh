#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  Docker Push Container (ECR)
# -----------------------------------------------------------------------------
#  Author     : Dwi Fahni Denni
#  License    : Apache v2
# -----------------------------------------------------------------------------
set -e

export AWS_ACCOUNT_ID=$1

echo "============="
echo "  Login ECR  "
echo "============="
PASSWORD=`aws ecr get-login-password --region ap-southeast-1`
echo $PASSWORD | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.ap-southeast-1.amazonaws.com
echo '- DONE -'
echo ''

docker images --format "{{.Repository}}:{{.Tag}}" > list_images.txt
IMAGES=`cat list_images.txt`
for IMG in $IMAGES; do
  echo "Docker Push => $IMG"
  echo ">> docker push $IMG"
  docker push $IMG
  echo '- DONE -'
  echo ''
done

echo ''
echo '-- ALL DONE --'
