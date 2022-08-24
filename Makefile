# -----------------------------------------------------------------------------
#  MAKEFILE RUNNING COMMAND
# -----------------------------------------------------------------------------
#  Author     : DevOps Engineer (support@devopscorner.id)
#  License    : Apache v2
# -----------------------------------------------------------------------------
# Notes:
# use [TAB] instead [SPACE]

export PATH_DOCKER="."
export PROJECT_NAME="bookstore"

export CI_REGISTRY     ?= $(ARGS).dkr.ecr.ap-southeast-1.amazonaws.com
export CI_PROJECT_PATH ?= devopscorner
export CI_PROJECT_NAME ?= bookstore

IMAGE          = $(CI_REGISTRY)/${CI_PROJECT_PATH}/${CI_PROJECT_NAME}
DIR            = $(shell pwd)
VERSION       ?= 1.5.0

export BASE_IMAGE=alpine
export BASE_VERSION=3.16
export ALPINE_VERSION=3.16

GO_APP        ?= bookstore
SOURCES        = $(shell find . -name '*.go' | grep -v /vendor/)
VERSION       ?= $(shell git describe --tags --always --dirty)
GOPKGS         = $(shell go list ./ | grep -v /vendor/)
BUILD_FLAGS   ?=
LDFLAGS       ?= -X github.com/devopscorner/golang-deployment/config.Version=$(VERSION) -w -s
TAG           ?= "v0.1.0"
GOARCH        ?= amd64
GOOS          ?= linux

export PATH_APP=`pwd`

# ========================= #
#   BUILD GO APP (Binary)   #
# ========================= #
.PHONY: build

default: build

test.race:
	go test -v -race -count=1 `go list ./...`

test:
	go test -v -count=1 `go list ./...`

fmt:
	go fmt $(GOPKGS)

check:
	golint $(GOPKGS)
	go vet $(GOPKGS)

# build: build/$(BINARY)

# build/$(BINARY): $(SOURCES)
# 	GOOS=$(GOOS) GOARCH=$(GOARCH) CGO_ENABLED=0 go build -o build/$(BINARY) $(BUILD_FLAGS) -ldflags "$(LDFLAGS)" .

tag:
	git tag $(TAG)

build:
	@echo "============================================"
	@echo " Task      : Build Binary GO APP "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@echo ">> Build GO Apps... "
	@GOOS=$(GOOS) GOARCH=$(GOARCH) CGO_ENABLED=0 go build -o build/$(GO_APP) $(BUILD_FLAGS) ./main.go
	@echo '- DONE -'

# ==================== #
#   CLONE REPOSITORY   #
# ==================== #
.PHONY: git-clone
git-clone:
	@echo "================================================="
	@echo " Task      : Clone Repository Sources "
	@echo " Date/Time : `date`"
	@echo "================================================="
	@sh ./git-clone.sh $(SOURCE) $(TARGET)
	@echo '- DONE -'

# ========================== #
#   BUILD CONTAINER GO-APP   #
# ========================== #
.PHONY: dockerhub-build-alpine ecr-build-alpine
dockerhub-build-alpine:
	@echo "========================================================"
	@echo " Task      : Create Container GO-APP Alpine Image "
	@echo " Date/Time : `date`"
	@echo "========================================================"
	@sh ./dockerhub-build.sh alpine Dockerfile ${ALPINE_VERSION}

ecr-build-alpine:
	@echo "========================================================"
	@echo " Task      : Create Container GO-APP Alpine Image "
	@echo " Date/Time : `date`"
	@echo "========================================================"
	@sh ./ecr-build.sh $(ARGS) alpine Dockerfile ${ALPINE_VERSION}

# ========================= #
#   TAGS CONTAINER GO-APP   #
# ========================= #
.PHONY: tag-dockerhub-alpine tag-ecr-alpine
dockerhub-tag-alpine:
	@echo "========================================================"
	@echo " Task      : Set Tags Image Alpine to DockerHub"
	@echo " Date/Time : `date`"
	@echo "========================================================"
	@sh ./dockerhub-tag.sh alpine ${ALPINE_VERSION}

ecr-tag-alpine:
	@echo "========================================================"
	@echo " Task      : Set Tags Image Alpine to ECR"
	@echo " Date/Time : `date`"
	@echo "========================================================"
	@sh ./ecr-tag.sh $(ARGS) alpine ${ALPINE_VERSION} $(CI_PATH)

# ========================= #
#   PUSH CONTAINER GO-APP   #
# ========================= #
.PHONY: dockerhub-push-alpine ecr-push-alpine
dockerhub-push-alpine:
	@echo "========================================================"
	@echo " Task      : Push Image Alpine to DockerHub"
	@echo " Date/Time : `date`"
	@echo "========================================================"
	@sh ./dockerhub-push.sh alpine $(CI_PATH)

ecr-push-alpine:
	@echo "========================================================"
	@echo " Task      : Push Image Alpine to ECR"
	@echo " Date/Time : `date`"
	@echo "========================================================"
	@sh ./ecr-push.sh $(ARGS) alpine $(CI_PATH)
