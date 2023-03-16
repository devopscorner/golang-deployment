# Golang Deployment - Deployment with Azure DevOps Pipeline

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

## Example CI/CD Script `cicd-azure-devops.yml`

```
trigger:
  branches:
    include:
    - features/*
    - bugfix/*
    - hotfix/*

pool:
  vmImage: 'ubuntu-latest'

variables:
  imageName: 'devopcorner/bookstore'
  ecrRegistry: '0987612345.dkr.ecr.us-west-2.amazonaws.com'
  helmReleaseName: 'bookstore'

steps:
- script: |
    go build -o app
  displayName: 'Build Go Application'

- script: |
    if [[ "$(Build.SourceBranch)" == "refs/heads/features/"* ]]; then
      semver=1.0.0-$(Build.SourceBranchName).$(Build.SourceVersion)
    elif [[ "$(Build.SourceBranch)" == "refs/heads/bugfix/"* ]]; then
      semver=1.1.0-$(Build.SourceBranchName).$(Build.SourceVersion)
    elif [[ "$(Build.SourceBranch)" == "refs/heads/hotfix/"* ]]; then
      semver=1.1.1-$(Build.SourceBranchName).$(Build.SourceVersion)
    fi
    echo "Semantic version: $semver"
    echo "##vso[task.setvariable variable=imageTag]$semver"
  displayName: 'Set Semantic Version'

- task: Docker@2
  inputs:
    containerRegistry: 'ECR'
    repository: $(imageName)
    command: 'build'
    Dockerfile: '$(System.DefaultWorkingDirectory)/Dockerfile'
    tags: |
      $(imageTag)
      $(Build.SourceBranchName)-latest
      latest
  displayName: 'Build and Push Docker Image'

- task: HelmInstaller@1
  inputs:
    helmVersionToInstall: 'v3.7.0'
  displayName: 'Install Helm'

- script: |
    helmfile sync
  workingDirectory: '$(System.DefaultWorkingDirectory)/helm'
  displayName: 'Deploy to EKS using Helmfile'
```