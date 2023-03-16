# Golang Deployment - CI/CD with AWS CloudFormation

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

## Example CI/CD Script `cicd-aws-cloudformation.yaml`

```
AWSTemplateFormatVersion: 2010-09-09
Description: A CloudFormation template for deploying a Golang app using AWS CodePipeline and AWS CodeBuild, sourced from GitHub.

Parameters:
  GitHubOwner:
    Type: String
    Description: The GitHub user or organization that owns the repository.
  GitHubRepoName:
    Type: String
    Description: The name of the GitHub repository.
  GitHubBranch:
    Type: String
    Description: The name of the branch to use as the source for the pipeline.
  ECRRepoName:
    Type: String
    Description: The name of the Elastic Container Registry (ECR) repository to use for storing the Docker image.
  S3Bucket:
    Type: String
    Description: The name of the S3 bucket to use for storing pipeline artifacts.
  KMSKeyArn:
    Type: String
    Description: The ARN of the KMS key to use for encrypting pipeline artifacts.
  StagingClusterName:
    Type: String
    Description: The name of the ECS cluster to use for the staging environment.
  StagingServiceName:
    Type: String
    Description: The name of the ECS service to use for the staging environment.
  ProductionClusterName:
    Type: String
    Description: The name of the ECS cluster to use for the production environment.
  ProductionServiceName:
    Type: String
    Description: The name of the ECS service to use for the production environment.

Resources:
  ECRRepo:
    Type: AWS::ECR::Repository
    Properties:
      RepositoryName: !Ref ECRRepoName

  SNSTopic:
    Type: AWS::SNS::Topic
    Properties:
      DisplayName: !Sub "${AWS::StackName}-SNSTopic"
      TopicName: !Sub "${AWS::StackName}-SNSTopic"

  SNSTopicSubscription:
    Type: AWS::SNS::Subscription
    Properties:
      Protocol: email
      TopicArn: !Ref SNSTopic
      Endpoint: support@devopscorner.id

  CodeBuildProject:
    Type: AWS::CodeBuild::Project
    Properties:
      Name: !Sub "${AWS::StackName}-CodeBuildProject"
      Description: My Golang app
      ServiceRole: !GetAtt CodeBuildServiceRole.Arn
      TimeoutInMinutes: 60
      Artifacts:
        Type: NO_ARTIFACTS
      Environment:
        ComputeType: BUILD_GENERAL1_SMALL
        ## Image: aws/codebuild/standard:5.0
        Image: devopscorner/cicd:codebuild-4.0
        Type: LINUX_CONTAINER
        EnvironmentVariables:
          - Name: AWS_REGION
            Value: your-aws-region
          - Name: ENVIRONMENT
            Value: !If [IsStaging, "staging", "production"]
          - Name: ECR_REPOSITORY_URI
            Value: !Join ['', [!GetAtt ECRRepo.RepositoryUri, ':', !Ref ImageTag]]
      Source:
        Type: GITHUB
        Location: !Sub "https://github.com/devopscorner/golang-deployment"
        GitCloneDepth: 1
        BuildSpec: !Sub "${S3ObjectUrl}"
        GitCloneDepth: 1
        ReportBuildStatus: true
        SourceVersion: !Ref GitHubBranch
      artifacts:
        files:
          - image_tag.txt
        name: build-artifact

  CodePipeline:
    Type: AWS::CodePipeline::Pipeline
    Properties:
      Name: !Sub "${AWS::StackName}-CodePipeline"
      RoleArn: !GetAtt CodePipelineServiceRole.Arn
      ArtifactStore:
        Type: S3
        Location: !Ref S3Bucket
        EncryptionKey:
          Type: KMS
          Id: !Ref KMSKeyArn
      Stages:
        - Name: Source
          Actions:
            - Name: Source
              ActionTypeId:
                Category: Source
                Owner: ThirdParty
                Provider: GitHub
                Version: '1'
              OutputArtifacts:
                - Name: SourceArtifact
              Configuration:
                Owner: !Ref GitHubOwner
                Repo: !Ref GitHubRepoName
                Branch: !Ref GitHubBranch
                OAuthToken: !Ref GitHubToken
                RunOrder: 1

        - Name: Build
          Actions:
            - Name: Build
              ActionTypeId:
                Category: Build
                Owner: AWS
                Provider: CodeBuild
                Version: '1'
                InputArtifacts:
                  - Name: SourceArtifact
                OutputArtifacts:
                  - Name: BuildArtifact
              Configuration:
                ProjectName: !Ref CodeBuildProject
                EnvironmentVariables:
                  - Name: IMAGE_TAG
                    Value: !Ref ImageTag
                RunOrder: 2

        - Name: ManualApproval
          Actions:
            - Name: ManualApproval
              Category: Approval
              Owner: AWS
              Provider: Manual
              Version: '1'
              InputArtifacts:
                - Name: BuildArtifact
              OutputArtifacts:
                - Name: ApproveArtifact
              Configuration:
                NotificationArn: !Ref SNSTopic
                CustomData: "Do you want to deploy the latest changes to production?"
              RunOrder: 3

        - Name: DeployStaging
          Actions:
            - Name: DeployStaging
              ActionTypeId:
                Category: Deploy
                Owner: AWS
                Provider: ECS
                Version: '1'
                InputArtifacts:
                  - Name: BuildArtifact
                  - Name: ApproveArtifact
              Configuration:
                ClusterName: !Ref StagingClusterName
                ServiceName: !Ref StagingServiceName
                FileName: imagedefinitions.json
                ImageUri: !Join ['', [!GetAtt ECRRepo.RepositoryUri, ':', !Ref ImageTag]]
              RunOrder: 4
              Condition:
                StringEquals:
                  - !Ref IsStaging
                  - "true"

        - Name: DeployProd
          Actions:
            - Name: DeployProd
              ActionTypeId:
                Category: Deploy
                Owner: AWS
                Provider: ECS
                Version: '1'
                InputArtifacts:
                  - Name: BuildArtifact
                  - Name: ApproveArtifact
              Configuration:
                ClusterName: !Ref ProductionClusterName
                ServiceName: !Ref ProductionServiceName
                FileName: imagedefinitions.json
                ImageUri: !Join ['', [!GetAtt ECRRepo.RepositoryUri, ':', !Ref ImageTag]]
                RunOrder: 4
              Condition:
                StringEquals:
                  - !Ref IsStaging
                  - "false"
                StartsWith:
                  ApprovalStatus: "Approved"

  CodePipelineServiceRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: 2012-10-17
        Statement:
          - Effect: Allow
        Principal:
          Service: codepipeline.amazonaws.com
          Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/AWSCodePipelineFullAccess
      Policies:
        - PolicyName: AllowECRWriteAccess
          PolicyDocument:
            Version: 2012-10-17
            Statement:
              - Effect: Allow
                Action:
                  - ecr:BatchCheckLayerAvailability
                  - ecr:GetDownloadUrlForLayer
                  - ecr:BatchGetImage
                  - ecr:PutImage
                Resource: !GetAtt ECRRepo.Arn

  CodeBuildServiceRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
      Version: 2012-10-17
      Statement:
        - Effect: Allow
      Principal:
        Service: codebuild.amazonaws.com
        Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess
        - arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser
        - arn:aws:iam::aws:policy/CloudWatchLogsFullAccess
      Policies:
      - PolicyName: AllowECRReadAccess

    PolicyDocument:
      Version: 2012-10-17
      Statement:
        - Effect: Allow
      Action:
        - ecr:GetAuthorizationToken
        - ecr:GetDownloadUrlForLayer
        - ecr:BatchGetImage
      Resource: '*'

  S3ArtifactStoreBucket:
    Type: AWS::S3::Bucket
    Properties:
    BucketName: !Ref S3Bucket

  S3Object:
  Type: AWS::S3::Object
  Properties:
  Bucket: !Ref S3Bucket
  Key: !Sub "${AWS::StackName}/buildspec.yml"
  ContentType: text/x-yaml
  Body: |-
  version: 0.2
      phases:
        install:
          commands:
            - echo "Install phase"
        build:
          commands:
            - echo "Build phase"
            - export IMAGE_TAG=$CODEBUILD_RESOLVED_SOURCE_VERSION
            - echo $IMAGE_TAG > image_tag.txt
            - echo "IMAGE_TAG=$IMAGE_TAG" >> build.env
        post_build:
          commands:
            - echo "Post build phase"
            - echo "Pushing Docker image to ECR..."
            - $(aws ecr get-login --no-include-email --region your-aws-region)
            - docker push !Join ['', [!GetAtt ECRRepo.RepositoryUri, ':', !Ref ImageTag]]
            - echo "Pushed Docker image to ECR successfully."

Outputs:
  CodePipelineUrl:
    Description: The URL of the AWS CodePipeline.
    Value: !Sub "https://${AWS::Region}.console.aws.amazon.com/codesuite/codepipeline/pipelines/${AWS::StackName}-CodePipeline/view?region=${AWS::Region}"
  ECRRepositoryUrl:
    Description: URL of the Elastic Container Registry (ECR) repository.
    Value: !GetAtt ECRRepo.RepositoryUri
  SNSTopicArn:
    Description: ARN of the SNS topic.
    Value: !Ref SNSTopic
  PipelineName:
    Description: Name of the CodePipeline.
    Value: !Ref CodePipeline
  CodeBuildProjectName:
    Description: Name of the CodeBuild project.
    Value: !Ref CodeBuildProject
```
