# Golang Deployment - DockerHub

Kubernetes Deployment for Simple Golang API

![goreport](https://goreportcard.com/badge/github.com/devopscorner/golang-deployment/src)
![all contributors](https://img.shields.io/github/contributors/devopscorner/golang-deployment)
![tags](https://img.shields.io/github/v/tag/devopscorner/golang-deployment?sort=semver)
[![docker pulls](https://img.shields.io/docker/pulls/devopscorner/bookstore.svg)](https://hub.docker.com/r/devopscorner/bookstore/)
![download all](https://img.shields.io/github/downloads/devopscorner/golang-deployment/total.svg)
![view](https://views.whatilearened.today/views/github/devopscorner/golang-deployment.svg)
![clone](https://img.shields.io/badge/dynamic/json?color=success&label=clone&query=count&url=https://github.com/devopscorner/golang-deployment/blob/master/clone.json?raw=True&logo=github)
![issues](https://img.shields.io/github/issues/devopscorner/golang-deployment)
![pull requests](https://img.shields.io/github/issues-pr/devopscorner/golang-deployment)
![forks](https://img.shields.io/github/forks/devopscorner/golang-deployment)
![stars](https://img.shields.io/github/stars/devopscorner/golang-deployment)
[![license](https://img.shields.io/github/license/devopscorner/golang-deployment)](https://img.shields.io/github/license/devopscorner/golang-deployment)

---

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
  export ALPINE_VERSION=3.17   # 3.15 | 3.16 | 3.17
  export BASE_IMAGE="alpine"
  export IMAGE="devopscorner/bookstore"
  export TAG="latest"
  ```

- Execute Build Image

  ```
  # Golang 1.19.3 - Alpine 3.15
  docker build -f Dockerfile -t ${IMAGE}:alpine .
  docker build -f Dockerfile.alpine-3.15 -t ${IMAGE}:alpine-3.15 .
  docker build -f Dockerfile.alpine-3.15 -t ${IMAGE}:golang1.19.3-alpine3.15 .

  # Golang 1.19.5 - Alpine 3.16
  docker build -f Dockerfile -t ${IMAGE}:alpine .
  docker build -f Dockerfile.alpine-3.16 -t ${IMAGE}:alpine-3.16 .
  docker build -f Dockerfile.alpine-3.16 -t ${IMAGE}:golang1.19.5-alpine3.16 .

  # Golang 1.19.5 - Alpine 3.17
  docker build -f Dockerfile -t ${IMAGE}:alpine .
  docker build -f Dockerfile.alpine-3.17 -t ${IMAGE}:alpine-3.17 .
  docker build -f Dockerfile.alpine-3.17 -t ${IMAGE}:golang1.19.5-alpine3.17 .

  -- or --

  dockerhub-build.sh alpine Dockerfile ${ALPINE_VERSION}
  dockerhub-build.sh alpine Dockerfile.alpine-3.15 ${ALPINE_VERSION}
  dockerhub-build.sh alpine Dockerfile.alpine-3.16 ${ALPINE_VERSION}
  dockerhub-build.sh alpine Dockerfile.alpine-3.17 ${ALPINE_VERSION}

  -- or --

  # default: 3.17
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
