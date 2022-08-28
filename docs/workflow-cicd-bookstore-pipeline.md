## Workflow CI/CD Pipeline

- Create Container Image CI/CD CodeBuild, refer to this repository: [DevOpsCorner CI/CD CodeBuild](https://github.com/devopscorner/devopscorner-container/tree/main/compose/docker/cicd-codebuild)

- Create HelmChart Template Global, go to [this](https://github.com/devopscorner/devopscorner-helm) section
  - `api`
  - `backend`
  - `frontend`
  - `stateful`
  - `secretref`
  - `svcrole`
- Deploy HelmChart Template Global to S3
  - `AWS_REGION=ap-southeast-1 helm repo add devopscorner-lab s3://devopscorner-helm-chart/lab`
  - `AWS_REGION=ap-southeast-1 helm repo add devopscorner-staging s3://devopscorner-helm-chart/staging`
  - `AWS_REGION=ap-southeast-1 helm repo add devopscorner-prod s3://devopscorner-helm-chart/prod`
- Create HelmChart Template for GO App
  - Helm template GO App (`_infra/{env}/helm-template.yml`)
  - Helm value GO App (`_infra/{env}/helm-value.yml`)

- Create `Dockerfile` for Container GO App CI/CD
- Create Script CI/CD
  - `ecr-build-alpine.sh`
  - `ecr-push-alpine.sh`
  - `ecr-tag-alpine.sh`
  - `git-clone.sh`
  - `Makefile`

- Register Container Image GO App to Amazon ECR (Container Registry)
- Create script for Building Container Image GO App (`_infra/buildspec-build.yml`)
- Create script for Deployment Container Image GO App to EKS (`_infra/buildspec-deploy.yml`)
- Setup Variable Environment / Using Config Secret with **AWS Systems Manager (Parameter Store)**

- Create Pipeline with AWS CodePipeline
  - **Source**: Reference from CodeCommit and/or 3rd Party Repository (GitHub, GitLab, BitBucket, Azure DevOps)
  - **Build**: Building Container GO App
    - Golang Unit Test
    - Code Quality and Code Security
    - Build Container GO App
    - Tagging Container GO App
    - Push Container GO App to Container Registry (ECR / Dockerhub)
  - **Deploy**: Deploy Container GO App
    - **Static Application Security Testing (SAST)**, or static analysis
    - Manual Approval
    - **Deploy-DEV**
    - Manual Approval
    - **Deploy-UAT**
    - **Dynamic Application Security Testing (DAST)**
    - Manual Approval
    - **Deploy-PROD**

- Running Deployment: Commit -> Push -> Webhook (CodeCommit)

- CodeBuild Process
  - Build Container
    - Environment Image: `aws/codebuild/amazonlinux2-x86_64-standard:4.0`
    - Environment Type: `Linux`
    - Buildspec: `_infra/buildspec-build.yml`
  - Deploy Container
    - Environment Image: `devopscorner/cicd:codebuild-4.0` or `YOUR_AWS_ACCOUNT.dkr.ecr.ap-southeast-1.amazonaws.com/devopscorner/cicd:codebuild-4.0`
    - Environment Type: `Linux`
    - Buildspec: `_infra/buildspec-deploy.yml`
