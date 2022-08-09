## Changelog GO App

### version 0.1
- First deployment GO Apps
- script build image
- script ecr-tag & ecr-push
- Helm deployment values
- Upgrade gomod, using GO `1.17`
- Dockerfile using `golang:1.17-alpine3.15`

### version 1.0
- Golang API Rest (bookstore)
- Postman Collection
- Container Builder GO
- Push Container to ECR
- Deploy Kubernetes with Helm Values
- Buildspec for AWS CodeBuild & AWS CodePipeline

### version 2.0
- IAM Role sample for CodeBuild & CodePipeline
- Buildspec CodePipeline for Build Container Image inside CodeBuild using Spesific CodeCommit
- Buildspec CodePipeline for Deploy EKS Cluster inside CodeBuild using Spesific CodeCommit
- Buildspec without CodePipeline for Build Container Image inside CodeBuild using 3rd party repository (GitHub, GitLab, BitBucket, Azure DevOps)
- Buildspec without CodePipeline for Deploy EKS Cluster inside CodeBuild using 3rd party repository (GitHub, GitLab, BitBucket, Azure DevOps)
- Setup `~/.ssh/known_hosts` for authorization host 3rd party repository
- Setup `~/.ssh/config` for authorization config ssh key 3rd party repository
- Dynamic Tags with COMMIT_HASH
