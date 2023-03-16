# Golang Deployment - Deployment with AWS Developer Tools

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

## Buildspec Build

```
version: 0.2

env:
  # ==================== #
  #  Ref: SECRET CONFIG  #
  # ==================== #
  parameter-store:
    BUILDNUMBER: /devopscorner/cicd/staging/repo/bookstore/buildnumber
    STORE_AWS_ACCOUNT: /devopscorner/cicd/staging/credentials/aws_account
    STORE_AWS_ACCESS_KEY: /devopscorner/cicd/staging/credentials/aws_access_key
    STORE_AWS_SECRET_KEY: /devopscorner/cicd/staging/credentials/aws_secret_key
    STORE_REPO_URL: /devopscorner/cicd/staging/repo/bookstore/url
    STORE_REPO_BRANCH: /devopscorner/cicd/staging/repo/bookstore/branch
    STORE_REPO_FOLDER: /devopscorner/cicd/staging/repo/bookstore/folder
    STORE_EKS_CLUSTER: /devopscorner/cicd/staging/eks_cluster
    STORE_BASE64_PUB_KEY: /devopscorner/cicd/staging/credentials/base64_pub_key
    STORE_BASE64_PRIV_KEY: /devopscorner/cicd/staging/credentials/base64_priv_key
    STORE_BASE64_PEM_KEY: /devopscorner/cicd/staging/credentials/base64_pem_key
    STORE_BASE64_SSH_CONFIG: /devopscorner/cicd/staging/credentials/base64_ssh_config
    STORE_BASE64_KNOWN_HOSTS: /devopscorner/cicd/staging/credentials/known_hosts
    STORE_BASE64_KUBECONFIG: /devopscorner/cicd/staging/credentials/base64_kube_config

  # ===================================== #
  #  Ref: Pipeline Environment Variables  #
  # ===================================== #
  variables:
    ENV_CICD: "dev"
    AWS_DEFAULT_REGION: "us-west-2"
    INFRA_CICD: "terraform/environment/providers/aws/infra/resources"
    INFRA_CICD_PATH: "bookstore"
    INFRA_ECR_PATH: "devopscorner/bookstore"

phases:
  pre_build:
    commands:
      # ======================= #
      #  Setup Auth Repository  #
      # ======================= #
      - mkdir -p ~/.ssh
      - echo "${STORE_BASE64_PUB_KEY}" | base64 -d > ~/.ssh/id_rsa.pub
      - echo "${STORE_BASE64_PRIV_KEY}" | base64 -d > ~/.ssh/id_rsa
      - echo "${STORE_BASE64_KNOWN_HOSTS}" | base64 -d > ~/.ssh/known_hosts
      - chmod 400 ~/.ssh/id_rsa*
      - chmod 644 ~/.ssh/known_hosts
      - eval "$(ssh-agent -s)"
      - ssh-add ~/.ssh/id_rsa
      - echo '- DONE -'
  build:
    commands:
      # ========================= #
      #  Refactoring AWS Account  #
      # ========================= #
      - cd ${CODEBUILD_SRC_DIR} && find ./ -type f -exec sed -i "s/YOUR_AWS_ACCOUNT/${STORE_AWS_ACCOUNT}/g" {} \;
      # ============= #
      #  Build Image  #
      # ============= #
      - make ecr-build-alpine ARGS=${STORE_AWS_ACCOUNT} CI_PATH=${INFRA_ECR_PATH}
      # ============== #
      #  Unit Testing  #
      # ============== #
      # - make unit-test
      # ============ #
      #  Tags Image  #
      # ============ #
      - make ecr-tag-alpine ARGS=${STORE_AWS_ACCOUNT} CI_PATH=${INFRA_ECR_PATH}
      - docker images --format "{{.Repository}}:{{.Tag}}" | grep ${INFRA_ECR_PATH}
      # ============ #
      #  Push Image  #
      # ============ #
      - make ecr-push-alpine ARGS=${STORE_AWS_ACCOUNT} TAGS=${INFRA_ECR_PATH}

artifacts:
  files:
    - _infra/*
    - .aws/*
    - docs/*
    - src/*
    - dockerhub-build.sh
    - dockerhub-push.sh
    - dockerhub-tag.sh
    - ecr-build.sh
    - ecr-push.sh
    - ecr-tag.sh
    - Makefile
  name: "artifact-$(date '+%Y%m%d-%H%M%S')"
```

## Buildspec Deploy

```
version: 0.2

env:
  # ==================== #
  #  Ref: SECRET CONFIG  #
  # ==================== #
  parameter-store:
    BUILDNUMBER: /devopscorner/cicd/staging/repo/bookstore/buildnumber
    STORE_AWS_ACCOUNT: /devopscorner/cicd/staging/credentials/aws_account
    STORE_AWS_ACCESS_KEY: /devopscorner/cicd/staging/credentials/aws_access_key
    STORE_AWS_SECRET_KEY: /devopscorner/cicd/staging/credentials/aws_secret_key
    STORE_REPO_URL: /devopscorner/cicd/staging/repo/bookstore/url
    STORE_REPO_BRANCH: /devopscorner/cicd/staging/repo/bookstore/branch
    STORE_REPO_FOLDER: /devopscorner/cicd/staging/repo/bookstore/folder
    STORE_EKS_CLUSTER: /devopscorner/cicd/staging/eks_cluster
    STORE_BASE64_PUB_KEY: /devopscorner/cicd/staging/credentials/base64_pub_key
    STORE_BASE64_PRIV_KEY: /devopscorner/cicd/staging/credentials/base64_priv_key
    STORE_BASE64_PEM_KEY: /devopscorner/cicd/staging/credentials/base64_pem_key
    STORE_BASE64_SSH_CONFIG: /devopscorner/cicd/staging/credentials/base64_ssh_config
    STORE_BASE64_KNOWN_HOSTS: /devopscorner/cicd/staging/credentials/known_hosts
    STORE_BASE64_KUBECONFIG: /devopscorner/cicd/staging/credentials/base64_kube_config

  # ===================================== #
  #  Ref: Pipeline Environment Variables  #
  # ===================================== #
  variables:
    ENV_CICD: "dev"
    AWS_DEFAULT_REGION: "us-west-2"
    INFRA_CICD: "terraform/environment/providers/aws/infra/resources"
    INFRA_CICD_PATH: "bookstore"
    INFRA_ECR_PATH: "devopscorner/bookstore"

phases:
  pre_build:
    commands:
      # ======================= #
      #  Setup Auth Repository  #
      # ======================= #
      - mkdir -p ~/.ssh
      - mkdir -p ~/.kube
      - echo "${STORE_BASE64_PUB_KEY}" | base64 -d > ~/.ssh/id_rsa.pub
      - echo "${STORE_BASE64_PRIV_KEY}" | base64 -d > ~/.ssh/id_rsa
      - echo "${STORE_BASE64_KNOWN_HOSTS}" | base64 -d > ~/.ssh/known_hosts
      - echo "${STORE_BASE64_KUBECONFIG}" | base64 -d > ~/.kube/config
      - chmod 400 ~/.ssh/id_rsa*
      - chmod 400 ~/.kube/config*
      - chmod 644 ~/.ssh/known_hosts
      - eval "$(ssh-agent -s)"
      - ssh-add ~/.ssh/id_rsa
      - echo '- DONE -'
  build:
    commands:
      # ========================= #
      #  Refactoring AWS Account  #
      # ========================= #
      - cd ${CODEBUILD_SRC_DIR} && find ./ -type f -exec sed -i "s/YOUR_AWS_ACCOUNT/${STORE_AWS_ACCOUNT}/g" {} \;
      # ================== #
      #  Helm Repo Update  #
      # ================== #
      - AWS_REGION=${AWS_DEFAULT_REGION} helm repo add devopscorner-staging s3://devopscorner-helm-chart/staging
      - AWS_REGION=${AWS_DEFAULT_REGION} helm repo add devopscorner-prod s3://devopscorner-helm-chart/prod
      - helm repo update
      # ============ #
      #  Deploy K8S  #
      # ============ #
      - cd _infra/${ENV_CICD}
      - aws eks update-kubeconfig --region ${AWS_DEFAULT_REGION} --name ${STORE_EKS_CLUSTER}
      - kubectl version
      - kubectl config use-context arn:aws:eks:${AWS_DEFAULT_REGION}:${STORE_AWS_ACCOUNT}:cluster/${STORE_EKS_CLUSTER}
      - kubectl get ns -A
      - helmfile --version
      - helmfile -f helm-template.yml apply
      - echo '-- ALL DONE --'

artifacts:
  files:
    - _infra/*
    - .aws/*
    - docs/*
    - src/*
    - dockerhub-build.sh
    - dockerhub-push.sh
    - dockerhub-tag.sh
    - ecr-build.sh
    - ecr-push.sh
    - ecr-tag.sh
    - Makefile
  name: "artifact-$(date '+%Y%m%d-%H%M%S')"
```

## Example CI/CD Script `cicd-aws-codepipeline.yml`

```
version: 0.2

phases:
  install:
    runtime-versions:
      docker: 19
  build:
    commands:
      - go build -o app
      - |
        if [[ "$CODEBUILD_WEBHOOK_TRIGGER" == "branch/main" ]]; then
          semver=1.0.0-${CODEBUILD_SOURCE_VERSION}
        elif [[ "$CODEBUILD_WEBHOOK_TRIGGER" == "branch/features/"* ]]; then
          semver=1.0.0-${CODEBUILD_WEBHOOK_TRIGGER#branch/features/}.${CODEBUILD_SOURCE_VERSION}
        elif [[ "$CODEBUILD_WEBHOOK_TRIGGER" == "branch/bugfix/"* ]]; then
          semver=1.1.0-${CODEBUILD_WEBHOOK_TRIGGER#branch/bugfix/}.${CODEBUILD_SOURCE_VERSION}
        elif [[ "$CODEBUILD_WEBHOOK_TRIGGER" == "branch/hotfix/"* ]]; then
          semver=1.1.1-${CODEBUILD_WEBHOOK_TRIGGER#branch/hotfix/}.${CODEBUILD_SOURCE_VERSION}
        fi
        echo "Semantic version: $semver"
        echo "imageTag=$semver" >> $CODEBUILD_SRC_DIR/variables.env
        $(aws ecr get-login --no-include-email --region $AWS_REGION)
        docker build -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:$semver .
        docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:$semver
        docker tag $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:$semver $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:latest
        docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:latest
  post_build:
    commands:
      - |
        echo "Deploying to Kubernetes using Helm"
        curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
        helmfile sync

artifacts:
  files:
    - _infra/*
    - .aws/*
    - docs/*
    - src/*
    - dockerhub-build.sh
    - dockerhub-push.sh
    - dockerhub-tag.sh
    - ecr-build.sh
    - ecr-push.sh
    - ecr-tag.sh
    - Makefile
  name: "artifact-$(date '+%Y%m%d-%H%M%S')"
  discard-paths: yes
```
