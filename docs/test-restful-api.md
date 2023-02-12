# Golang Deployment - Test RESTful API

Kubernetes Deployment for Simple Golang API

![goreport](https://goreportcard.com/badge/github.com/devopscorner/golang-deployment)
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

## Development

### Prequests

- Install jq libraries

  ```
  apt-get install -y jq
  ```

- Install golang dependencies

  ```
  cd src
  go mod init
  go mod tidy
  ```

### Runnning

```
go run main.go
```

### Runnning Test

```
go run main_test.go
```

## API Test

- Get Books

```
GET    : /books
         curl --request GET \
            --url 'http://localhost:8080/books' \
            --header 'Content-Type: application/json' | jq
```

- Add Book 1

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

- Add Book 2

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

- Add Book 3

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

- Edit Book 3

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

- Delete Book 3

```
DELETE   : /books/3
         curl --request DELETE \
            --url 'http://localhost:8080/books/3' \
            --header 'Content-Type: application/json' | jq
```
