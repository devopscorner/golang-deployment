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
export AWS_DEFAULT_REGION="us-west-2"

export CI_REGISTRY     ?= $(ARGS).dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
export CI_PROJECT_PATH ?= devopscorner
export CI_PROJECT_NAME ?= bookstore

IMAGE          = $(CI_REGISTRY)/${CI_PROJECT_PATH}/${CI_PROJECT_NAME}
DIR            = $(shell pwd)
VERSION       ?= 1.7.0

export BASE_IMAGE=alpine
export BASE_VERSION=3.17
export ALPINE_VERSION=3.17

GO_APP        ?= bookstore
SOURCES        = $(shell find . -name '*.go' | grep -v /vendor/)
VERSION       ?= $(shell git describe --tags --always --dirty)
GOPKGS         = $(shell go list ./ | grep -v /vendor/)
BUILD_FLAGS   ?=
LDFLAGS       ?= -X github.com/devopscorner/golang-deployment/src/config.Version=$(VERSION) -w -s
TAG           ?= "v0.3.0"
GOARCH        ?= amd64
GOOS          ?= linux
GO111MODULE   ?= on

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
# 	GO111MODULE=$(GO111MODULE) GOOS=$(GOOS) GOARCH=$(GOARCH) CGO_ENABLED=0 go build -o build/$(BINARY) $(BUILD_FLAGS) -ldflags "$(LDFLAGS)" .

tag:
	git tag $(TAG)

build:
	@echo "============================================"
	@echo " Task      : Build Binary GO APP "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@echo ">> Build GO Apps... "
	@echo ">> GO111MODULE=$(GO111MODULE) GOOS=$(GOOS) GOARCH=$(GOARCH) CGO_ENABLED=0 go build -o build/$(GO_APP) $(BUILD_FLAGS) -ldflags "$(LDFLAGS)" ./main.go"
	@cd src && GO111MODULE=$(GO111MODULE) GOOS=$(GOOS) GOARCH=$(GOARCH) CGO_ENABLED=0 go build -o build/$(GO_APP) $(BUILD_FLAGS) -ldflags "$(LDFLAGS)" ./main.go
	@echo '- DONE -'

build-mac-amd:
	@echo "============================================"
	@echo " Task      : Build Binary GO APP "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@echo ">> Build GO Apps... "
	@echo ">> GO111MODULE=$(GO111MODULE) GOOS=darwin GOARCH=amd64 go build -o build/$(GO_APP) $(BUILD_FLAGS) -ldflags "$(LDFLAGS)" ./main.go"
	@cd src && GO111MODULE=$(GO111MODULE) GOOS=darwin GOARCH=amd64 go build -o build/$(GO_APP) $(BUILD_FLAGS) -ldflags "$(LDFLAGS)" ./main.go
	@echo '- DONE -'

build-mac-arm:
	@echo "============================================"
	@echo " Task      : Build Binary GO APP "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@echo ">> Build GO Apps... "
	@echo ">> GO111MODULE=$(GO111MODULE) GOOS=darwin GOARCH=arm64 go build -o build/$(GO_APP) $(BUILD_FLAGS) -ldflags "$(LDFLAGS)" ./main.go"
	@cd src && GO111MODULE=$(GO111MODULE) GOOS=darwin GOARCH=arm64 go build -o build/$(GO_APP) $(BUILD_FLAGS) -ldflags "$(LDFLAGS)" ./main.go
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
# ./dockerhub-build.sh Dockerfile [DOCKERHUB_IMAGE_PATH] [alpine] [version|latest|tags] [custom-tags]
dockerhub-build-alpine:
	@echo "========================================================"
	@echo " Task      : Create Container GO-APP Alpine Image "
	@echo " Date/Time : `date`"
	@echo "========================================================"
	@sh ./dockerhub-build.sh Dockerfile $(CI_PATH) alpine ${ALPINE_VERSION}

# ./ecr-build.sh [AWS_ACCOUNT] Dockerfile [ECR_PATH] [alpine] [version|latest|tags] [custom-tags]
ecr-build-alpine:
	@echo "========================================================"
	@echo " Task      : Create Container GO-APP Alpine Image "
	@echo " Date/Time : `date`"
	@echo "========================================================"
	@sh ./ecr-build.sh $(ARGS) Dockerfile $(CI_PATH) alpine ${ALPINE_VERSION}

# ========================= #
#   TAGS CONTAINER GO-APP   #
# ========================= #
.PHONY: tag-dockerhub-alpine tag-ecr-alpine
# ./dockerhub-tag.sh [DOCKERHUB_IMAGE_PATH] [alpine] [version|latest|tags] [custom-tags]
dockerhub-tag-alpine:
	@echo "========================================================"
	@echo " Task      : Set Tags Image Alpine to DockerHub"
	@echo " Date/Time : `date`"
	@echo "========================================================"
	@sh ./dockerhub-tag.sh $(CI_PATH) alpine ${ALPINE_VERSION}

# ./ecr-tag.sh [AWS_ACCOUNT] [ECR_PATH] [alpine|codebuild] [version|latest|tags] [custom-tags]
ecr-tag-alpine:
	@echo "========================================================"
	@echo " Task      : Set Tags Image Alpine to ECR"
	@echo " Date/Time : `date`"
	@echo "========================================================"
	@sh ./ecr-tag.sh $(ARGS) $(CI_PATH) alpine ${ALPINE_VERSION}

# ========================= #
#   PUSH CONTAINER GO-APP   #
# ========================= #
.PHONY: dockerhub-push-alpine ecr-push-alpine
# ./dockerhub-push.sh [DOCKERHUB_IMAGE_PATH] [alpine|version|latest|tags|custom-tags]
dockerhub-push-alpine:
	@echo "========================================================"
	@echo " Task      : Push Image Alpine to DockerHub"
	@echo " Date/Time : `date`"
	@echo "========================================================"
	@sh ./dockerhub-push.sh $(CI_PATH) alpine

ecr-push-alpine:
	@echo "========================================================"
	@echo " Task      : Push Image Alpine to ECR"
	@echo " Date/Time : `date`"
	@echo "========================================================"
	@sh ./ecr-push.sh $(ARGS) $(CI_PATH) alpine
