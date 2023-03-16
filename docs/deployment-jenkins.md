# Golang Deployment - CI/CD with Jenkins

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

## Jenkins CI/CD

- [Jenkins CI/CD](../.jenkins/jenkins-cicd.jenkinsfile)

## Example CI/CD Script `cicd-jenkins.jenkinsfile`

```
pipeline {
  agent any

  environment {
    AWS_REGION = 'us-west-2'
    AWS_ACCOUNT_ID = '0987612345'
    IMAGE_NAME = 'devopscorner/bookstore'
  }

  stages {
    stage('Build') {
      steps {
        sh 'go build -o app'
        script {
          if (env.BRANCH_NAME ==~ /features\/.*/) {
            def semver = "1.0.0-${env.BRANCH_NAME.replace('features/', '')}.${env.GIT_COMMIT}"
            echo "Semantic version: ${semver}"
            sh "echo imageTag=${semver} >> variables.env"
          } else if (env.BRANCH_NAME ==~ /bugfix\/.*/) {
            def semver = "1.1.0-${env.BRANCH_NAME.replace('bugfix/', '')}.${env.GIT_COMMIT}"
            echo "Semantic version: ${semver}"
            sh "echo imageTag=${semver} >> variables.env"
          } else if (env.BRANCH_NAME ==~ /hotfix\/.*/) {
            def semver = "1.1.1-${env.BRANCH_NAME.replace('hotfix/', '')}.${env.GIT_COMMIT}"
            echo "Semantic version: ${semver}"
            sh "echo imageTag=${semver} >> variables.env"
          } else if (env.BRANCH_NAME == 'main') {
            def semver = "1.0.0-${env.GIT_COMMIT}"
            echo "Semantic version: ${semver}"
            sh "echo imageTag=${semver} >> variables.env"
          }
        }
        withCredentials([usernamePassword(credentialsId: 'aws-ecr-login', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          sh "aws ecr get-login-password --region ${env.AWS_REGION} | docker login --username AWS --password-stdin ${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com"
          sh "docker build -t ${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com/${env.IMAGE_NAME}:${imageTag} ."
          sh "docker push ${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com/${env.IMAGE_NAME}:${imageTag}"
          sh "docker tag ${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com/${env.IMAGE_NAME}:${imageTag} ${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com/${env.IMAGE_NAME}:latest"
          sh "docker push ${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com/${env.IMAGE_NAME}:latest"
        }
        stash includes: 'app', name: 'app'
      }
    }
    stage('Deploy') {
      steps {
        unstash 'app'
        withAWS(region: env.AWS_REGION, roleAccount: "${env.AWS_ACCOUNT_ID}") {
          sh "curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash"
          sh "helmfile sync"
        }
      }
      environment {
        DEPLOYMENT_ENVIRONMENT_URL = "http://your-deployment-environment-url"
      }
      post {
        success {
          script {
            currentBuild.description = "Deployment completed successfully. Visit ${env.DEPLOYMENT_ENVIRONMENT_URL} for details."
          }
        }
        failure {
          script {
            currentBuild.description = "Deployment failed. Visit ${env.DEPLOYMENT_ENVIRONMENT_URL} for details."
          }
        }
      }
    }
  }
}
```