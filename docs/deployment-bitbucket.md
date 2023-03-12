# Golang Deployment - Deployment with Bitbucket Pipeline

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

## Example CI/CD Script `cicd-bitbucket.yml`

```
pipelines:
  default:
    - step:
        name: Build and Deploy
        image: golang:1.17
        script:
          - go build -o app
          - |
            if [[ "$BITBUCKET_BRANCH" == "features/"* ]]; then
              semver=1.0.0-${BITBUCKET_BRANCH#features/}.${BITBUCKET_COMMIT:0:8}
            elif [[ "$BITBUCKET_BRANCH" == "bugfix/"* ]]; then
              semver=1.1.0-${BITBUCKET_BRANCH#bugfix/}.${BITBUCKET_COMMIT:0:8}
            elif [[ "$BITBUCKET_BRANCH" == "hotfix/"* ]]; then
              semver=1.1.1-${BITBUCKET_BRANCH#hotfix/}.${BITBUCKET_COMMIT:0:8}
            fi
            echo "Semantic version: $semver"
            echo "imageTag=$semver" >> $BITBUCKET_CLONE_DIR/variables.env
            aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
            docker build -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:$semver .
            docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:$semver
            docker tag $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:$semver $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:latest
            docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:latest
          artifacts:
            - app
        services:
          - docker
        caches:
          - docker
          - go
        deployment: production
        trigger: manual
        environment:
          name: production
          url: $BITBUCKET_DEPLOYMENT_ENVIRONMENT_URL
```