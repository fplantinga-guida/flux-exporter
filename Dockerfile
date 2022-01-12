# build stage
FROM golang:1.17.6-alpine AS build-env
RUN apk add --no-cache ca-certificates git

ENV GO111MODULE=on CGO_ENABLED=0 GOOS=linux GOARCH=amd64

WORKDIR /go/src/app
COPY go.mod .

RUN go mod download

COPY main.go .

RUN go build -a -installsuffix cgo -o /go/bin/flux-exporter

# final stage
FROM scratch
WORKDIR /app
COPY --from=build-env /go/bin/flux-exporter /app/flux-exporter
ENTRYPOINT ["/app/flux-exporter"]
EXPOSE 8080