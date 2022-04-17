# Golang Deployment

Kubernetes Deployment for Simple Golang API

![all contributors](https://img.shields.io/github/contributors/devopscorner/golang-deployment)
![tags](https://img.shields.io/github/v/tag/devopscorner/golang-deployment?sort=semver)
[![docker pulls](https://img.shields.io/docker/pulls/devopscorner/cicd.svg)](https://hub.docker.com/r/devopscorner/cicd/)
[![docker image size](https://img.shields.io/docker/image-size/devopscorner/cicd.svg?sort=date)](https://hub.docker.com/r/devopscorner/cicd/)
![download all](https://img.shields.io/github/downloads/devopscorner/golang-deployment/total.svg)
![download latest](https://img.shields.io/github/downloads/devopscorner/golang-deployment/1.0/total)
![view](https://views.whatilearened.today/views/github/devopscorner/golang-deployment.svg)
![clone](https://img.shields.io/badge/dynamic/json?color=success&label=clone&query=count&url=https://github.com/devopscorner/golang-deployment/blob/master/clone.json?raw=True&logo=github)
![issues](https://img.shields.io/github/issues/devopscorner/golang-deployment)
![pull requests](https://img.shields.io/github/issues-pr/devopscorner/golang-deployment)
![forks](https://img.shields.io/github/forks/devopscorner/golang-deployment)
![stars](https://img.shields.io/github/stars/devopscorner/golang-deployment)
[![license](https://img.shields.io/github/license/devopscorner/golang-deployment)](https://img.shields.io/github/license/devopscorner/golang-deployment)

## Development
### Prequests
* Install jq libraries
  ```
  apt-get install -y jq
  ```
* Install golang dependencies
  ```
  go mod init
  go mod tidy
  ```

### Runnning
```
go run main.go
```

## API Test
* Get Books
```
GET    : /books
         curl --request GET \
            --url 'http://localhost:8080/books' \
            --header 'Content-Type: application/json' | jq
```

* Add Book 1
```
POST   : /books
         curl --request POST \
            --url 'http://localhost:8080/books' \
            --header 'Content-Type: application/json' \
            --data '{
                "title": "Mastering Go: Create Golang production applications using network libraries, concurrency, and advanced Go data structures",
                "author": "Mihalis Tsoukalos"
            }' | jq
```

* Add Book 2
```
POST   : /books
         curl --request POST \
            --url 'http://localhost:8080/books' \
            --header 'Content-Type: application/json' \
            --data '{
                "title": "Introducing Go: Build Reliable, Scalable Programs",
                "author": "Caleb Doxsey"
            }' | jq
```

* Add Book 3
```
POST   : /books
         curl --request POST \
            --url 'http://localhost:8080/books' \
            --header 'Content-Type: application/json' \
            --data '{
                "title": "Learning Functional Programming in Go: Change the way you approach your applications using functional programming in Go",
                "author": "Lex Sheehan"
            }' | jq
```

* Edit Book 3
```
PATCH   : /books/3
         curl --request PATCH \
            --url 'http://localhost:8080/books/3' \
            --header 'Content-Type: application/json' \
            --data '{
                "title": "Test Golang",
                "author": "ZeroC0D3Lab"
            }' | jq
```

* Delete Book 3
```
DELETE   : /books/3
         curl --request DELETE \
            --url 'http://localhost:8080/books/3' \
            --header 'Content-Type: application/json' | jq
```

## Tested Environment

### Versioning

* Docker version

  ```
  docker version

  Client:
  Cloud integration: v1.0.22
  Version:           20.10.12
  API version:       1.41
  Go version:        go1.16.12
  Git commit:        e91ed57
  Built:             Mon Dec 13 11:46:56 2021
  OS/Arch:           darwin/amd64
  Context:           default
  Experimental:      true
  ```

* Docker-Compose version

  ```
  docker-compose -v
  ---
  Docker Compose version v2.2.3
  ```

* AWS Cli

  ```
  aws -v
  ---
  Note: AWS CLI version 2, the latest major version of the AWS CLI, is now stable and recommended for general use. For more information, see the AWS CLI version 2 installation instructions at: <https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html>
  ```

* Terraform Cli

  ```
  terraform version
  ---
  Terraform v1.1.6
  on darwin_amd64
  - provider registry.terraform.io/hashicorp/aws v3.74.3
  - provider registry.terraform.io/hashicorp/local v2.1.0
  - provider registry.terraform.io/hashicorp/null v3.1.0
  - provider registry.terraform.io/hashicorp/random v3.1.0
  - provider registry.terraform.io/hashicorp/time v0.7.2
  ```

* Terraform Environment Cli

  ```
  tfenv -v
  ---
  tfenv 2.2.2
  ```

## Security Check

Make sure that you didn't push sensitive information in this repository

* [ ] AWS Credentials (AWS_ACCESS_KEY, AWS_SECRET_KEY)
* [ ] AWS Account ID
* [ ] AWS Resources ARN
* [ ] Username & Password
* [ ] Private (id_rsa) & Public Key (id_rsa.pub)
* [ ] DNS Zone ID
* [ ] APP & API Key

## Copyright

* Author: **Dwi Fahni Denni (@zeroc0d3)**
* Vendor: **DevOps Corner Indonesia (devopscorner.id)**
* License: **Apache v2**
