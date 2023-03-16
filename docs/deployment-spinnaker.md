# Golang Deployment - Deployment with SemaphoreCI Pipeline

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

## Example CI/CD Script `cicd-semaphoreci.yml`

```
version: v1.0

agent:
  machine:
    type: e1-standard-2

blocks:
  - name: Build and Deploy
    task:
      jobs:
        - name: Build and Push Docker Image
          commands:
            - checkout
            - sem-version set
            - if [[ "$SEMAPHORE_BRANCH_NAME" == "main" ]]; then
                semver=1.0.0-${SEMAPHORE_GIT_SHA:0:8}
              elif [[ "$SEMAPHORE_BRANCH_NAME" == "features/"* ]]; then
                semver=1.0.0-${SEMAPHORE_BRANCH_NAME#features/}.${SEMAPHORE_GIT_SHA:0:8}
              elif [[ "$SEMAPHORE_BRANCH_NAME" == "bugfix/"* ]]; then
                semver=1.1.0-${SEMAPHORE_BRANCH_NAME#bugfix/}.${SEMAPHORE_GIT_SHA:0:8}
              elif [[ "$SEMAPHORE_BRANCH_NAME" == "hotfix/"* ]]; then
                semver=1.1.1-${SEMAPHORE_BRANCH_NAME#hotfix/}.${SEMAPHORE_GIT_SHA:0:8}
              fi
            - echo "Semantic version: $semver"
            - echo "imageTag=$semver" >> $SEMAPHORE_WORKSPACE/variables.env
            - sem-service aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
            - docker build -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:$semver .
            - docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:$semver
            - docker tag $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:$semver $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:latest
            - docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:latest
        - name: Deploy to Kubernetes using Helmfile
          commands:
            - curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
            - helmfile sync
      environment:
        AWS_REGION: us-west-2
        AWS_ACCOUNT_ID: 0987612345
        IMAGE_NAME: devopscorner/bookstore
```