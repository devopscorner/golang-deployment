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

BASE_IMAGE     = alpine
BASE_VERSION   = 3.16

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
	@./git-clone.sh $(SOURCE) $(TARGET)
	@echo '- DONE -'

# ========================= #
#   BUILD CONTAINER CI/CD   #
# ========================= #
.PHONY: ecr-build-alpine
ecr-build-alpine:
	@echo "================================================="
	@echo " Task      : Create Container CI/CD Alpine Image "
	@echo " Date/Time : `date`"
	@echo "================================================="
	@cd ${PATH_DOCKER} && ./ecr-build-alpine.sh $(ARGS) $(CI_PATH)
	@echo '- DONE -'

# ======================== #
#   TAGS CONTAINER CI/CD   #
# ======================== #
.PHONY: ecr-tag-alpine
ecr-tag-alpine:
	@echo "================================================="
	@echo " Task      : Set Tags Image Alpine to ECR"
	@echo " Date/Time : `date`"
	@echo "================================================="
	@cd ${PATH_DOCKER} && ./ecr-tag-alpine.sh $(ARGS) $(CI_PATH)
	@echo '- DONE -'

# ======================== #
#   PUSH CONTAINER CI/CD   #
# ======================== #
.PHONY: ecr-push-alpine
ecr-push-alpine:
	@echo "================================================="
	@echo " Task      : Push Image Alpine to ECR"
	@echo " Date/Time : `date`"
	@echo "================================================="
	@cd ${PATH_DOCKER} && ./ecr-push-alpine.sh $(ARGS) $(TAGS)
	@echo '- DONE -'
