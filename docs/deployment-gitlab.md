# Golang Deployment - Deployment with GitLab CI/CD

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

## Example CI/CD Script `cicd-gitlab.yml`

```
stages:
  - build
  - deploy

variables:
  imageName: 'devopcorner/bookstore'
  ecrRegistry: '0987612345.dkr.ecr.us-west-2.amazonaws.com'
  helmReleaseName: 'bookstore'

build:
  stage: build
  image: golang:1.17
  script:
    - go build -o app
    - |
      if [[ "$CI_COMMIT_REF_NAME" == "features/"* ]]; then
        semver=1.0.0-${CI_COMMIT_REF_NAME#features/}.${CI_COMMIT_SHORT_SHA}
      elif [[ "$CI_COMMIT_REF_NAME" == "bugfix/"* ]]; then
        semver=1.1.0-${CI_COMMIT_REF_NAME#bugfix/}.${CI_COMMIT_SHORT_SHA}
      elif [[ "$CI_COMMIT_REF_NAME" == "hotfix/"* ]]; then
        semver=1.1.1-${CI_COMMIT_REF_NAME#hotfix/}.${CI_COMMIT_SHORT_SHA}
      fi
      echo "Semantic version: $semver"
      echo "imageTag=$semver" >> $CI_ENVIRONMENT_URL/variables.env
      docker build -t $ecrRegistry/$imageName:$semver .
      docker push $ecrRegistry/$imageName:$semver
      docker tag $ecrRegistry/$imageName:$semver $ecrRegistry/$imageName:latest
      docker push $ecrRegistry/$imageName:latest
  artifacts:
    paths:
      - app

deploy:
  stage: deploy
  image: alpine/helm:3.7.0
  script:
    - apk add --update openssh-client
    - ssh-keyscan $EKS_HOST >> ~/.ssh/known_hosts
    - ssh -i $EKS_PRIVATE_KEY $EKS_USERNAME@$EKS_HOST "curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash"
    - ssh -i $EKS_PRIVATE_KEY $EKS_USERNAME@$EKS_HOST "helmfile sync"
  environment:
    name: production
    url: $CI_ENVIRONMENT_URL
  dependencies:
    - build
  only:
    - main
  when: manual
```