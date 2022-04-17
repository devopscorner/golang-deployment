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
VERSION       ?= 1.3.0

BASE_IMAGE     = alpine
BASE_VERSION   = 3.15

GO_APP        ?= goapp
SOURCES        = $(shell find . -name '*.go' | grep -v /vendor/)
VERSION       ?= $(shell git describe --tags --always --dirty)
GOPKGS         = $(shell go list ./ | grep -v /vendor/)
BUILD_FLAGS   ?=
LDFLAGS       ?= -X github.com/devopscorner/golang-deployment/config.Version=$(VERSION) -w -s
TAG           ?= "v0.1.0"
GOARCH        ?= amd64
GOOS          ?= linux

export PATH_APP=`pwd`
export TF_PATH="terraform/environment/providers/aws/infra"
export TF_CORE="$(TF_PATH)/core"
export TF_RESOURCES="$(TF_PATH)/resources"
export TF_STATE="$(TF_PATH)/tfstate"
export TF_MODULES="terraform/modules/providers/aws"

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

# =============== #
#   GET MODULES   #
# =============== #
.PHONY: sub-officials sub-community sub-all
sub-officials:
	@echo "============================================"
	@echo " Task      : Get Official Submodules "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@mkdir -p $(TF_MODULES)/officials
	@cd $(PATH_APP) && ./get-officials.sh

sub-community:
	@echo "============================================"
	@echo " Task      : Get Community Submodules "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@mkdir -p $(TF_MODULES)/community
	@cd $(PATH_APP) && ./get-community.sh

sub-all:
	@make sub-officials
	@echo ''
	@make sub-community
	@echo ''
	@echo '---'
	@echo '- ALL DONE -'

# ========================= #
#   BUILD CONTAINER GOAPP   #
# ========================= #
.PHONY: ecr-build-app
ecr-build-app:
	@echo "================================================="
	@echo " Task      : Create Container GO Apps "
	@echo " Date/Time : `date`"
	@echo "================================================="
	@cd ${PATH_DOCKER} && ./ecr-build-alpine.sh $(ARGS)
	@echo '- DONE -'

# ======================== #
#   TAGS CONTAINER GOAPP   #
# ======================== #
.PHONY: ecr-tag-alpine
ecr-tag-alpine:
	@echo "================================================="
	@echo " Task      : Set Tags Image GO App to ECR"
	@echo " Date/Time : `date`"
	@echo "================================================="
	@cd ${PATH_DOCKER} && ./ecr-tag-alpine.sh $(ARGS)

# ======================== #
#   PUSH CONTAINER GOAPP   #
# ======================== #
.PHONY: ecr-push-alpine
ecr-push-alpine:
	@echo "================================================="
	@echo " Task      : Push Image GO App to ECR"
	@echo " Date/Time : `date`"
	@echo "================================================="
	@cd ${PATH_DOCKER} && ./ecr-push-alpine.sh $(ARGS)
