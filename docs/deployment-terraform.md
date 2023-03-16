# Golang Deployment - CI/CD with Terraform AWS CodeBuild, AWS CodePipeline & Amazon SNS

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

## Example CI/CD Terraform Script `cicd-terraform.tf`

### This script includes:

- ECR repository creation
- SNS topic creation and subscription
- CodeBuild project creation for production and staging environments
- CodePipeline creation with four stages: Source, Build, ManualApproval, and Deploy (two times)
- ECS task definition and service creation for staging environment
- CloudWatch Event rule and target for manual approval notification
- Outputs for the staging and production URLs, build number, and semantic versions for staging and production.
- Using custom image AWS CodeBuild `devopscorner/cicd:codebuild-4.0`

```
### Golang Terraform Pipeline (GitHub, AWS CodeBuild, AWS Pipeline, Amazon SNS) ###

# This script includes:
#  - ECR repository creation
#  - SNS topic creation and subscription
#  - CodeBuild project creation for production and staging environments
#  - CodePipeline creation with four stages: Source, Build, ManualApproval, and Deploy (two times)
#  - ECS task definition and service creation for staging environment
#  - CloudWatch Event rule and target for manual approval notification
#  - Outputs for the staging and production URLs, build number, and semantic versions for staging and production.
#  - Using custom image AWS CodeBuild `devopscorner/cicd:codebuild-4.0`

terraform {
  required_version = ">= 1.0.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63.0, < 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "bookstore" {
  name = "devopscorner/bookstore"
}

resource "aws_sns_topic" "bookstore-topic" {
  name = "bookstore-topic"
}

resource "aws_sns_topic_subscription" "bookstore-subscription" {
  topic_arn = aws_sns_topic.bookstore-topic.arn
  protocol  = "email"
  endpoint  = "support@devopscorner.id"
}

resource "aws_codebuild_project" "bookstore-prod" {
  name          = "bookstore-prod"
  description   = "My Golang app for production"
  service_role  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/CodeBuildServiceRole"
  build_timeout = "60"
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    # image      = "aws/codebuild/standard:5.0"
    image = "devopscorner/cicd:codebuild-4.0"
    type  = "LINUX_CONTAINER"
    environment_variable {
      name  = "AWS_REGION"
      value = "us-west-2"
    }
    environment_variable {
      name  = "ENVIRONMENT"
      value = "prod"
    }
    environment_variable {
      name  = "ECR_REPOSITORY_URI"
      value = aws_ecr_repository.bookstore.repository_url
    }
  }
  source {
    type            = "GITHUB"
    location        = "https://github.com/devopscorner/golang-deployment"
    git_clone_depth = 1
    buildspec       = file("${path.module}/buildspec.yaml")
    auth {
      type = "OAUTH"
    }
  }
}

resource "aws_codebuild_project" "bookstore-staging" {
  name          = "bookstore-staging"
  description   = "My Golang app for staging"
  service_role  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/CodeBuildServiceRole"
  build_timeout = "60"
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    # image      = "aws/codebuild/standard:5.0"
    image = "devopscorner/cicd:codebuild-4.0"
    type  = "LINUX_CONTAINER"
    environment_variable {
      name  = "AWS_REGION"
      value = "us-west-2"
    }
    environment_variable {
      name  = "ENVIRONMENT"
      value = "staging"
    }
    environment_variable {
      name  = "ECR_REPOSITORY_URI"
      value = aws_ecr_repository.bookstore.repository_url
    }
  }
  source {
    type            = "GITHUB"
    location        = "https://github.com/devopscorner/golang-deployment"
    git_clone_depth = 1
    buildspec       = file("${path.module}/buildspec.yaml")
    auth {
      type = "OAUTH"
    }
  }
}

resource "aws_codepipeline" "bookstore" {
  name     = "bookstore"
  role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/CodePipelineServiceRole"
  artifact_store {
    type     = "S3"
    location = "your-artifact-store-bucket"
    encryption_key {
      type = "KMS"
      id   = "your-kms-key-id"
    }
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["SourceArtifact"]
      configuration = {
        Owner      = "your-username"
        Repo       = "your-repo"
        Branch     = "main"
        OAuthToken = "your-github-token"
      }
    }
  }

  stage {
    name = "Build"
    actions {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      configuration = {
        ProjectName = aws_codebuild_project.bookstore-staging.name
      }
    }
  }

  stage {
    name = "ManualApproval"
    actions {
      name            = "ManualApproval"
      category        = "Approval"
      owner           = "AWS"
      provider        = "Manual"
      version         = "1"
      input_artifacts = ["BuildArtifact"]
      configuration = {
        NotificationArn = aws_sns_topic.bookstore-topic.arn
        CustomData      = "Do you want to deploy the latest changes to production?"
      }
    }
  }

  stage {
    name = "Deploy-Staging"
    actions {
      name            = "Deploy-Staging"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["BuildArtifact"]
      configuration = {
        ClusterName = "bookstore-cluster"
        ServiceName = "bookstore-staging"
        FileName    = "imagedefinitions.json"
        ImageUri    = "${aws_ecr_repository.bookstore.repository_url}:${var.semver_staging}"
      }
    }
  }

  stage {
    name = "Deploy-Prod"
    actions {
      name            = "Deploy-Prod"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["BuildArtifact"]
      configuration = {
        ClusterName = "bookstore-cluster"
        ServiceName = "bookstore-prod"
        FileName    = "imagedefinitions.json"
        ImageUri    = "${aws_ecr_repository.bookstore.repository_url}:${var.semver_prod}"
      }
      condition {
        type     = "StartsWith"
        variable = "ApprovalStatus"
        value    = "Approved"
      }
    }
  }
}

resource "aws_ecs_task_definition" "bookstore" {
  family = "bookstore"
  container_definitions = jsonencode([{
    name               = "bookstore"
    image              = "${aws_ecr_repository.bookstore.repository_url}:${var.semver_staging}"
    cpu                = 512
    memory_reservation = 512
    port_mappings = {
      container_port = 8080
      host_port      = 0
    }
  }])
}

resource "aws_ecs_service" "bookstore-staging" {
  name            = "bookstore-staging"
  cluster         = "bookstore-cluster"
  task_definition = aws_ecs_task_definition.bookstore.arn
  desired_count   = 2
  launch_type     = "EC2"
  load_balancer {
    target_group_arn = "your-target-group-arn"
    container_name   = "bookstore"
    container_port   = 8080
  }
}

resource "aws_cloudwatch_event_rule" "bookstore-manual-approval" {
  name        = "bookstore-manual-approval"
  description = "Manual approval rule for my Golang app"
  event_pattern = jsonencode({
    source      = ["aws.codepipeline"]
    detail_type = ["CodePipeline Action Execution State Change"]
    detail = {
      pipeline = ["${aws_codepipeline.bookstore.name}"]
      stage    = ["ManualApproval"]
      action   = ["ManualApproval"]
      state    = ["STARTED", "SUCCEEDED", "FAILED"]
    }
  })
}

resource "aws_cloudwatch_event_target" "bookstore-manual-approval" {
  rule = aws_cloudwatch_event_rule.bookstore-manual-approval.name
  arn  = aws_sns_topic.bookstore-topic.arn
}

output "bookstore-staging-url" {
  value = aws_alb.bookstore-staging.dns_name
}

output "bookstore-prod-url" {
  value = aws_alb.bookstore-prod.dns_name
}

output "bookstore-build-number" {
  value = aws_codebuild_project.bookstore-staging.build_number
}

output "bookstore-semver-staging" {
  value = var.semver_staging
}

output "bookstore-semver-prod" {
  value = var.semver_prod
}
```