# Golang Deployment - Deployment with CircleCI Pipeline

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

## Example CI/CD Script `cicd-circleci.yml`

```
version: 2.1
jobs:
  build-and-deploy:
    docker:
      - image: circleci/golang:1.19.5

    environment:
      AWS_REGION: us-west-2
      AWS_ACCOUNT_ID: 0987612345
      IMAGE_NAME: devopscorner/bookstore

    steps:
      - checkout
      - run:
          name: Build and push Docker image
          command: |
            go build -o app
            if [[ "$CIRCLE_BRANCH" == "main" ]]; then
              semver=1.0.0-${CIRCLE_SHA1:0:8}
            elif [[ "$CIRCLE_BRANCH" == "features/"* ]]; then
              semver=1.0.0-${CIRCLE_BRANCH#features/}.${CIRCLE_SHA1:0:8}
            elif [[ "$CIRCLE_BRANCH" == "bugfix/"* ]]; then
              semver=1.1.0-${CIRCLE_BRANCH#bugfix/}.${CIRCLE_SHA1:0:8}
            elif [[ "$CIRCLE_BRANCH" == "hotfix/"* ]]; then
              semver=1.1.1-${CIRCLE_BRANCH#hotfix/}.${CIRCLE_SHA1:0:8}
            fi
            echo "Semantic version: $semver"
            echo "imageTag=$semver" >> $HOME/variables.env
            aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
            docker build -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:$semver .
            docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:$semver
            docker tag $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:$semver $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:latest
            docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:latest

      - run:
          name: Deploy to Kubernetes using Helmfile
          command: |
            curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
            helmfile sync

      - store_artifacts:
          path: app

workflows:
  build-and-deploy:
    jobs:
      - build-and-deploy:
          requires:
            - checkout
          filters:
            branches:
              only:
                - main
                - /^features\/.*$/
                - /^bugfix\/.*$/
                - /^hotfix\/.*$/
```