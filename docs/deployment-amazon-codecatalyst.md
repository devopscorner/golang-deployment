# Golang Deployment - Deployment with Amazon CodeCatalyst

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

## Workflow Action

```
Name: Workflow_GitHubActions_Deployment
SchemaVersion: "1.0"

# Optional - Set automatic triggers.
Triggers:
  - Type: PUSH
    Branches:
      - master
      - "release/*"
  - Type: PULLREQUEST
    Branches:
      - "features/*"
      - "bugfix/*"
      - "hotfix/*"
    Events:
      - OPEN
      - REVISION

# Required - Define action configurations.
Actions:
  GitHubActions_Deployment:
    Identifier: aws/github-actions-runner@v1
    Inputs:
      Sources:
        - WorkflowSource
    Configuration:
      Steps:
        - name: Build Container GO Apps
          run: |
            GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
            COMMIT_HASH=$(git log -1 --format=format:"%H")

            latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
            if [[ -z "$latestTag" ]]; then
              latestTag=1.0.0
            fi

            if [[ "$GIT_BRANCH" == "features/"* ]]; then
              semver="$latestTag-features.${COMMIT_HASH}"
            elif [[ "$GIT_BRANCH" == "bugfix/"* ]]; then
              semver="$latestTag-bugfix.${COMMIT_HASH}"
            elif [[ "$GIT_BRANCH" == "hotfix/"* ]]; then
              semver="$latestTag-beta.${COMMIT_HASH}"
            else
              semver="$latestTag.${COMMIT_HASH}"
            fi

            if [[ -z "$semver" ]]; then
              ## DockerHub
              ## ./dockerhub-build.sh Dockerfile devopscorner/bookstore alpine $COMMIT_HASH
              ./ecr-build.sh "${Secrets.AWS_ACCOUNT_ID}" Dockerfile devopscorner/bookstore alpine $COMMIT_HASH
            else
              ## DockerHub
              ## ./dockerhub-build.sh Dockerfile devopscorner/bookstore alpine $semver
              ## ECR
              ./ecr-build.sh "${Secrets.AWS_ACCOUNT_ID}" Dockerfile devopscorner/bookstore alpine $semver
            fi
        - name: List Container Images
          run: |
            docker images | grep "devopscorner/bookstore"
        - name: Push to ECR (Container Registry)
          run: |
            ./ecr-push.sh "${Secrets.AWS_ACCOUNT_ID}" devopscorner/bookstore alpine
        - name: Deploy to ECS
          run: |
            echo "Deploy to ECS cluster..."
    Outputs:
      Artifacts:
      - Name: "MyArtifact"
        Files:
          - "_infra/**"
          - ".aws/**"
          - ".codecatalyst/workflows/**"
          - "docs/**"
          - "docker-compose.yml"
          - "Dockerfile"
          - "Dockerfile.alpine-3.15"
          - "Dockerfile.alpine-3.16"
          - "Dockerfile.alpine-3.17"
          - "dockerhub-build.sh"
          - "dockerhub-push.sh"
          - "dockerhub-tag.sh"
          - "ecr-build.sh"
          - "ecr-push.sh"
          - "ecr-pull.sh"
          - "ecr-tag.sh"
          - "entrypoint.sh"
          - "git-clone.sh"
          - "Makefile"
          - "run-docker.sh"
          - "start-build.sh"
          - "src/**"
    Compute:
      Type: EC2
      Fleet: Linux.x86-64.Large
    Environment:
      Connections:
        - Role: CodeCatalystPreviewDevelopmentAdministrator-5nxysr
          Name: "YOUR_AWS_ACCOUNT"
      Name: staging-dev
  DeployToECS:
    DependsOn:
      - GitHubActions_Deployment
    Identifier: aws/ecs-deploy@v1
    Environment:
      Connections:
        - Role: CodeCatalystPreviewDevelopmentAdministrator-5nxysr
          Name: "YOUR_AWS_ACCOUNT"
      Name: staging-dev
    Inputs:
      Sources:
        - WorkflowSource
      Artifacts:
        - MyArtifact
    Configuration:
      region: us-west-2
      cluster: codecatalyst-ecs-cluster
      service: bookstore-ecs-service
      task-definition: .codecatalyst/workflows/taskdef.json
```

## Task Definition

```
{
    "executionRoleArn": "arn:aws:iam::YOUR_AWS_ACCOUNT:role/codecatalyst-ecs-task-execution-role",
    "containerDefinitions": [
        {
            "name": "codecatalyst-ecs-container",
            "image": "YOUR_AWS_ACCOUNT.dkr.ecr.us-west-2.amazonaws.com/devopscorner/bookstore-codecatalyst:alpine",
            "essential": true,
            "portMappings": [
                {
                    "hostPort": 8080,
                    "protocol": "tcp",
                    "containerPort": 8080
                }
            ]
        }
    ],
    "requiresCompatibilities": [
        "FARGATE"
    ],
    "cpu": "256",
    "family": "bookstore-ecs-task-def",
    "memory": "512",
    "networkMode": "awsvpc"
}
```
