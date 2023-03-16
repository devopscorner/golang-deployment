# Golang Deployment - Deployment with DroneCI Pipeline

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

## Example CI/CD Script `cicd-droneci.yml`

```
kind: pipeline
type: docker
name: bookstore

platform:
  os: linux
  arch: amd64

steps:
  - name: build
    image: golang:1.19.5
    commands:
      - go mod download
      - if [ "${DRONE_BRANCH}" = "main" ]; then
          semver=1.0.0-${DRONE_COMMIT_SHA:0:8};
        elif [[ "${DRONE_BRANCH}" == "features/"* ]]; then
          semver=1.0.0-${DRONE_BRANCH#features/}.${DRONE_COMMIT_SHA:0:8};
        elif [[ "${DRONE_BRANCH}" == "bugfix/"* ]]; then
          semver=1.1.0-${DRONE_BRANCH#bugfix/}.${DRONE_COMMIT_SHA:0:8};
        elif [[ "${DRONE_BRANCH}" == "hotfix/"* ]]; then
          semver=1.1.1-${DRONE_BRANCH#hotfix/}.${DRONE_COMMIT_SHA:0:8};
        fi
      - echo "Semantic version: $semver"
      - docker build -t ${PLUGIN_REGISTRY}/${PLUGIN_REPO}:${semver} .
      - docker tag ${PLUGIN_REGISTRY}/${PLUGIN_REPO}:${semver} ${PLUGIN_REGISTRY}/${PLUGIN_REPO}:latest
    environment:
      - PLUGIN_REGISTRY=your-registry-url
      - PLUGIN_REPO=bookstore
    when:
      event:
        - push
        - tag

  - name: publish
    image: plugins/ecr
    settings:
      region: us-west-2
      access_key:
        from_secret: aws_access_key
      secret_key:
        from_secret: aws_secret_key
      repo: ${PLUGIN_REGISTRY}/${PLUGIN_REPO}
      tags: latest,${semver}
    when:
      event:
        - push
        - tag

  - name: deploy
    image: dtzar/helm-kubectl
    settings:
      kubernetes_server: your-kubernetes-server
      kubernetes_cert:
        from_secret: kubernetes_cert
      kubernetes_token:
        from_secret: kubernetes_token
      kubernetes_namespace: bookstore
      command: helmfile sync
    when:
      event:
        - push
        - tag
```