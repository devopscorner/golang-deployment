# Golang Deployment - Test RESTful API

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

## Folder Structure

```
.
├── config
│   ├── config.go
│   └── config_test.go
├── controller
│   ├── book_controller.go
│   ├── book_controller_test.go
│   ├── login_controller.go
│   └── login_controller_test.go
├── driver
│   ├── db.go
│   ├── dynamo.go
│   ├── mysql.go
│   ├── psql.go
│   └── sqlite.go
├── go-bookstore.db
├── go.mod
├── go.sum
├── main.go
├── main_test.go
├── middleware
│   ├── auth_middleware.go
│   └── auth_middleware_test.go
├── migrate_book.go.example
├── migrate_book_dynamo.go.example
├── model
│   └── book.go
├── repository
│   └── book_repository.go
└── routes
    └── book_routes.go

8 directories, 23 files
```

## Environment Variables (Default)

```
GIN_MODE=release
APP_URL=http://localhost
APP_PORT=8080
DB_CONNECTION=sqlite
DB_REGION=ap-southeast-1
DB_HOST=localhost
DB_PORT=
DB_DATABASE=go-bookstore.db
DB_USERNAME=root
DB_PASSWORD=
JWT_AUTH_USERNAME=devopscorner
JWT_AUTH_PASSWORD=DevOpsCorner@2023
JWT_SECRET=s3cr3t
```

## Multi Driver Connection

```
DB_CONNECTION=sqlite
---
Available for:
- sqlite
- mysql
- postgres
- dynamo
```

## DynamoDB Connection

```
DB_CONNECTION=dynamo
---
DB_DATABASE --> Dynamo Table
DB_REGION   --> Dynamo Region
```

## API Test

- Generate JWT Token

```
POST    : /login
          curl --location '0.0.0.0:8080/login' \
              --header 'Content-Type: application/json' \
              --data-raw '{
                  "username": "devopscorner",
                  "password": "DevOpsCorner@2023"
              }' | jq
---
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2Nzg2MTc5MzN9.p92DDMXVJPA8VTRDzDb-0NtzyfpdOtm5o6cJHMuZv44"
}

TOKEN=$(curl --request POST \
              --location '0.0.0.0:8080/login' \
              --header 'Content-Type: application/json' \
              --data-raw '{
                  "username": "devopscorner",
                  "password": "DevOpsCorner@2023"
              }' | jq -r '.token' )
---
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2Nzg2MTc5MzN9.p92DDMXVJPA8VTRDzDb-0NtzyfpdOtm5o6cJHMuZv44
```

- List Books

```
GET     : /v1/books
          curl --request GET \
              --location '0.0.0.0:8080/v1/books' \
              --header 'Content-Type: application/json' \
              --header 'Authorization: Bearer ${TOKEN}'  | jq
```

- Find Book ID

```
GET     : /v1/books/${id}
          curl --request GET \
              --location '0.0.0.0:8080/v1/books/${id}' \
              --header 'Content-Type: application/json' \
              --header 'Authorization: Bearer ${TOKEN}'  | jq
```

- Add Book 1

```
POST    : /v1/books
          curl --request POST \
              --location '0.0.0.0:8080/v1/books' \
              --header 'Content-Type: application/json' \
              --header 'Authorization: Bearer ${TOKEN}' \
              --data-raw '{
                  "title": "Mastering Go: Create Golang production applications using network libraries, concurrency, and advanced Go data structures",
                  "author": "Mihalis Tsoukalos",
                  "year": "2023"
              }' | jq
```

- Add Book 2

```
POST    : /v1/books
          curl --request POST \
              --location '0.0.0.0:8080/v1/books' \
              --header 'Content-Type: application/json' \
              --header 'Authorization: Bearer ${TOKEN}' \
              --data-raw '{
                  "title": "Introducing Go: Build Reliable, Scalable Programs",
                  "author": "Caleb Doxsey",
                  "year": "2023"
              }' | jq
```

- Add Book 3

```
POST    : /v1/books
          curl --request POST \
              --location '0.0.0.0:8080/v1/books' \
              --header 'Content-Type: application/json' \
              --header 'Authorization: Bearer ${TOKEN}' \
              --data-raw '{
                  "title": "Learning Functional Programming in Go: Change the way you approach your applications using functional programming in Go",
                  "author": "Lex Sheehan",
                  "year": "2023"
              }' | jq
```

- Edit Book 3

```
PATCH   : /v1/books/3
          curl --request PATCH \
              --location '0.0.0.0:8080/v1/books/3' \
              --header 'Content-Type: application/json' \
              --header 'Authorization: Bearer ${TOKEN}' \
              --data-raw '{
                  "title": "DevOpsCorner",
                  "author": "DevOpsCorner Indonesia",
                  "year": "2023"
              }' | jq
```

- Delete Book 3

```
DELETE  : /v1/books/3
          curl --request DELETE \
              --location '0.0.0.0:8080/v1/books/3' \
              --header 'Content-Type: application/json' \
              --header 'Authorization: Bearer ${TOKEN}' | jq
```
