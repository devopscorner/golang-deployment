# Golang Deployment - DockerHub

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
  export IMAGE="devopscorner/bookstore"
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
  make dockerhub-build-alpine
  ```

## Push Image to DockerHub

- Login to your DockerHub Account

- Add Environment Variable
  ```
  export DOCKERHUB_USERNAME=[YOUR_DOCKERHUB_USERNAME]
  export DOCKERHUB_PASSWORD=[YOUR_DOCKERHUB_PASSWORD_OR_PERSONAL_TOKEN]
  ```

- Create Tags Image
  - Example:

    ```
    # Alpine
    docker tag ${IMAGE}:alpine ${IMAGE}:latest

    docker tag ${IMAGE}:alpine ${IMAGE}:alpine-latest

    docker tag ${IMAGE}:alpine ${IMAGE}:alpine-3.16
    ```

  - With Script:

    ```
    # default: 3.16
    ./dockerhub-tag.sh alpine ${ALPINE_VERSION}

    -- or --

    # default: 3.16
    make dockerhub-tag-alpine
    ```

- Push Image to **DockerHub** with Tags

  - Example:

    ```
    # Alpine
    docker push devopscorner-bookstore:alpine

    docker push devopscorner-bookstore:latest

    docker push devopscorner-bookstore:alpine-latest
    ```

  - With Script:

    ```
    ./dockerhub-push.sh alpine CI_PATH="devopscorner/bookstore"

    -- or --

    make dockerhub-push-alpine
    ```
