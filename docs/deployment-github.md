# Golang Deployment - Deployment with GitHub Action

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

## Example CI/CD Script `cicd-github.yml`

```
name: CI/CD Pipeline

on:
  push:
    branches:
    - features/*
    - bugfix/*
    - hotfix/*

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    env:
      imageName: 'devopcorner/bookstore'
      ecrRegistry: '0987612345.dkr.ecr.us-west-2.amazonaws.com'
      helmReleaseName: 'bookstore'

    steps:
    - name: Checkout Code
      uses: actions/checkout@v2
      with:
        fetch-depth: 0

    - name: Set up Go
      uses: actions/setup-go@v2
      with:
        go-version: 1.17

    - name: Build Go Application
      run: go build -o app

    - name: Set Semantic Version
      run: |
        if [[ "$GITHUB_REF" == "refs/heads/features/"* ]]; then
          semver=1.0.0-${GITHUB_REF#refs/heads/features/}.${GITHUB_SHA::8}
        elif [[ "$GITHUB_REF" == "refs/heads/bugfix/"* ]]; then
          semver=1.1.0-${GITHUB_REF#refs/heads/bugfix/}.${GITHUB_SHA::8}
        elif [[ "$GITHUB_REF" == "refs/heads/hotfix/"* ]]; then
          semver=1.1.1-${GITHUB_REF#refs/heads/hotfix/}.${GITHUB_SHA::8}
        fi
        echo "::set-env name=imageTag::$semver"

    - name: Build and Push Docker Image
      uses: docker/build-push-action@v2
      with:
        context: .
        push: true
        tags: |
          ${{ env.imageName }}:${{ env.imageTag }}
          ${{ env.imageName }}:${{ github.ref }}-latest
          ${{ env.imageName }}:latest
        registry: ${{ env.ecrRegistry }}
        username: ${{ secrets.ECR_USERNAME }}
        password: ${{ secrets.ECR_PASSWORD }}

    - name: Install Helm
      uses: appleboy/ssh-action@master
      with:
        host: ${{ secrets.EKS_HOST }}
        username: ${{ secrets.EKS_USERNAME }}
        key: ${{ secrets.EKS_PRIVATE_KEY }}
        script: |
          curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

    - name: Deploy to EKS using Helmfile
      uses: appleboy/ssh-action@master
      with:
        host: ${{ secrets.EKS_HOST }}
        username: ${{ secrets.EKS_USERNAME }}
        key: ${{ secrets.EKS_PRIVATE_KEY }}
        script: |
          helmfile sync
```
