# Compile stage
FROM golang:1.10.1-alpine3.7 AS build-env
ENV CGO_ENABLED 0
RUN apk update && apk upgrade && apk add --no-cache \
    git \
    openssh

ADD ./src /go/src/server
RUN go get github.com/johnnadratowski/golang-neo4j-bolt-driver \
 && go build -o /server server

# Final stage
FROM alpine:3.7
EXPOSE 8080
WORKDIR /
COPY --from=build-env /go/src/server/public /public
COPY --from=build-env /server /
CMD ["/server"]