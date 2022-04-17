### Builder ###
FROM golang:1.17-alpine3.15 as builder

WORKDIR /go/src/app
ENV GIN_MODE=release
ENV GOPATH=/go

RUN apk add --no-cache \
        build-base \
        git \
        curl \
        make \
        bash

COPY . /go/src/app

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 \
    cd /go/src/app && \
        go build -mod=readonly -ldflags="-s -w" -o goapp

### Binary ###
FROM golang:1.17-alpine3.15

ARG BUILD_DATE
ARG BUILD_VERSION
ARG GIT_COMMIT
ARG GIT_URL

ENV VENDOR="DevOpsCornerId"
ENV AUTHOR="DevOpsCorner.id <support@devopscorner.id>"
ENV IMG_NAME="alpine"
ENV IMG_VERSION="3.15"
ENV IMG_DESC="Docker Image Alpine 3.15"
ENV IMG_ARCH="amd64/x86_64"

ENV ALPINE_VERSION="3.15"

LABEL maintainer="$AUTHOR" \
        architecture="$IMG_ARCH" \
        ubuntu-version="$ALPINE_VERSION" \
        org.label-schema.build-date="$BUILD_DATE" \
        org.label-schema.name="$IMG_NAME" \
        org.label-schema.description="$IMG_DESC" \
        org.label-schema.vcs-ref="$GIT_COMMIT" \
        org.label-schema.vcs-url="$GIT_URL" \
        org.label-schema.vendor="$VENDOR" \
        org.label-schema.version="$BUILD_VERSION" \
        org.label-schema.schema-version="$IMG_VERSION" \
        org.opencontainers.image.authors="$AUTHOR" \
        org.opencontainers.image.description="$IMG_DESC" \
        org.opencontainers.image.vendor="$VENDOR" \
        org.opencontainers.image.version="$IMG_VERSION" \
        org.opencontainers.image.revision="$GIT_COMMIT" \
        org.opencontainers.image.created="$BUILD_DATE" \
        fr.hbis.docker.base.build-date="$BUILD_DATE" \
        fr.hbis.docker.base.name="$IMG_NAME" \
        fr.hbis.docker.base.vendor="$VENDOR" \
        fr.hbis.docker.base.version="$BUILD_VERSION"

ENV GIN_MODE=release
COPY --from=builder /go/src/app/goapp /usr/local/bin/goapp

ENTRYPOINT ["/usr/local/bin/goapp"]
EXPOSE 8080
