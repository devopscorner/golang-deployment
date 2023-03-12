# Golang Deployment - Deployment with OpenShift Pipeline

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

## Example CI/CD Script `cicd-openshift.yml`

```
apiVersion: build.openshift.io/v1
kind: BuildConfig
metadata:
  name: bookstore-build
  labels:
    app: bookstore
spec:
  source:
    git:
      uri: https://github.com/devopscorner/golang-deployment.git
    contextDir: app
  strategy:
    dockerStrategy:
      dockerfilePath: Dockerfile
    type: Docker
  output:
    to:
      kind: ImageStreamTag
      name: devopscorner/bookstore:${IS_TAG}
  triggers:
    - type: ConfigChange
    - type: GitHub
      github:
        secret: my-secret
    - type: Generic
      generic:
        secret: my-secret
    - type: ImageChange
      imageChange:
        from:
          kind: ImageStreamTag
          name: devopscorner/bookstore:latest
  resources:
    limits:
      cpu: 1
      memory: 1Gi
    requests:
      cpu: 500m
      memory: 500Mi

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: bookstore-deployment
  labels:
    app: bookstore
spec:
  replicas: 1
  selector:
    matchLabels:
      app: bookstore
  template:
    metadata:
      labels:
        app: bookstore
    spec:
      containers:
        - name: bookstore
          image: devopscorner/bookstore:${IS_TAG}
          imagePullPolicy: Always
          ports:
            - containerPort: 8080
      imagePullSecrets:
        - name: my-registry-credentials

---

apiVersion: v1
kind: Service
metadata:
  name: bookstore-service
  labels:
    app: bookstore
spec:
  ports:
    - name: http
      port: 80
      targetPort: 8080
  selector:
    app: bookstore
  type: ClusterIP
```