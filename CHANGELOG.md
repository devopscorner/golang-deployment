## Changelog GO App

### version 2.1
- Add Configuration Pipeline Synchronize for Mirroring Repository into AWS CodeCommit
  - [GitHub Repository](.github/workflows/synchronize.yml)
  - [GitLab Repository](.gitlab-ci.yml)
  - [BitBucket Repository](bitbucket-pipelines.yml)
  - [Azure DevOps Repository](azure-pipelines.yml)
- GitOps Flow
  - Azure DevOps Pipeline
    ![Azure DevOps Pipeline](docs/assets/gitops-flow-azure.png)
- GitOps DevSecOps Flow
  - Azure DevSecOps Pipeline
    ![Azure DevSecOps Pipeline](docs/assets/gitops-devsecops-azure.png)

### version 2.0
- IAM Role sample for CodeBuild & CodePipeline
- Buildspec CodePipeline for Build Container Image inside CodeBuild using Spesific CodeCommit
- Buildspec CodePipeline for Deploy EKS Cluster inside CodeBuild using Spesific CodeCommit
- Buildspec without CodePipeline for Build Container Image inside CodeBuild using 3rd party repository (GitHub, GitLab, BitBucket, Azure DevOps)
- Buildspec without CodePipeline for Deploy EKS Cluster inside CodeBuild using 3rd party repository (GitHub, GitLab, BitBucket, Azure DevOps)
- Setup `~/.ssh/known_hosts` for authorization host 3rd party repository
- Setup `~/.ssh/config` for authorization config ssh key 3rd party repository
- Dynamic Tags with COMMIT_HASH

### version 1.0
- Golang API Rest (bookstore)
- Postman Collection
- Container Builder GO
- Push Container to ECR
- Deploy Kubernetes with Helm Values
- Buildspec for AWS CodeBuild & AWS CodePipeline

### version 0.1
- First deployment GO Apps
- Script build image
- Script ecr-tag & ecr-push
- Helm deployment values
- Upgrade gomod, using GO `1.17`
- Dockerfile using `golang:1.17-alpine3.15`
