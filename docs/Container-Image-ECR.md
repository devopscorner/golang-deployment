# Golang Deployment - Amazon ECR (Elastic Container Registry)

Kubernetes Deployment for Simple Golang API

## Build Container Image

- Clone this repository

  ```
  git clone https://github.com/devopscorner/golang-deployment.git
  ```

- Replace "YOUR_AWS_ACCOUNT" with your AWS ACCOUNT ID

  ```
  find ./ -type f -exec sed -i 's/YOUR_AWS_ACCOUNT/123456789012/g' {} \;
  ```

- Set Environment Variable

  ```
  export ALPINE_VERSION=3.16   # 3.15 | 3.16
  export BASE_IMAGE="alpine"
  export IMAGE="YOUR_AWS_ACCOUNT.dkr.ecr.ap-southeast-1.amazonaws.com/devopscorner/bookstore"
  export TAG="latest"
  ```

- Execute Build Image

  ```
  # Golang 1.18 - Alpine 3.15
  docker build -f Dockerfile -t ${IMAGE}:alpine .
  docker build -f Dockerfile.alpine-3.15 -t ${IMAGE}:alpine-3.15 .
  docker build -f Dockerfile.alpine-3.15 -t ${IMAGE}:golang1.18-alpine3.15 .

  # Golang 1.18 - Alpine 3.16
  docker build -f Dockerfile -t ${IMAGE}:alpine .
  docker build -f Dockerfile.alpine-3.16 -t ${IMAGE}:alpine-3.16 .
  docker build -f Dockerfile.alpine-3.16 -t ${IMAGE}:golang1.18-alpine3.16 .

  -- or --

  dockerhub-build.sh alpine Dockerfile ${ALPINE_VERSION}
  dockerhub-build.sh alpine Dockerfile.alpine-3.15 ${ALPINE_VERSION}
  dockerhub-build.sh alpine Dockerfile.alpine-3.16 ${ALPINE_VERSION}

  -- or --

  # default: 3.16
  make ecr-build-alpine ARGS=YOUR_AWS_ACCOUNT
  ```

## Push Image to Amazon ECR (Elastic Container Registry)

- Create Tags Image
  - Example:

    ```
    # Alpine
    docker tag YOUR_AWS_ACCOUNT.dkr.ecr.ap-southeast-1.amazonaws.com/devopscorner/bookstore:alpine YOUR_AWS_ACCOUNT.dkr.ecr.ap-southeast-1.amazonaws.com/devopscorner/bookstore:latest

    docker tag YOUR_AWS_ACCOUNT.dkr.ecr.ap-southeast-1.amazonaws.com/devopscorner/bookstore:alpine YOUR_AWS_ACCOUNT.dkr.ecr.ap-southeast-1.amazonaws.com/devopscorner/bookstore:alpine-latest

    docker tag YOUR_AWS_ACCOUNT.dkr.ecr.ap-southeast-1.amazonaws.com/devopscorner/bookstore:alpine YOUR_AWS_ACCOUNT.dkr.ecr.ap-southeast-1.amazonaws.com/devopscorner/bookstore:alpine-3.16
    ```

  - With Script:

    ```
    # default: 3.16
    docker tag ${IMAGE}:${ALPINE_VERSION}

    -- or --

    # default: 3.16
    ./ecr-tag.sh ARGS=YOUR_AWS_ACCOUNT alpine ${ALPINE_VERSION} CI_PATH=devopscorner/bookstore

    -- or --

    make ecr-tag-alpine ARGS=YOUR_AWS_ACCOUNT CI_PATH=devopscorner/bookstore
    ```

 Push Image to **Amazon ECR** with Tags

- Example:

    ```
    # Alpine
    docker push YOUR_AWS_ACCOUNT.dkr.ecr.ap-southeast-1.amazonaws.com/devopscorner/bookstore:alpine

    docker push YOUR_AWS_ACCOUNT.dkr.ecr.ap-southeast-1.amazonaws.com/devopscorner/bookstore:alpine-latest

    docker push YOUR_AWS_ACCOUNT.dkr.ecr.ap-southeast-1.amazonaws.com/devopscorner/bookstore:alpine-3.16
    ```

- With Script:

    ```
    ./ecr-push.sh ARGS=YOUR_AWS_ACCOUNT alpine CI_PATH="devopscorner/bookstore"

    -- or --

    make ecr-push-alpine ARGS=YOUR_AWS_ACCOUNT CI_PATH="devopscorner/bookstore"
    ```
