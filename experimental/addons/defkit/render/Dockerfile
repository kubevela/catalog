# The render Job's image: defkit-render plus Go, since loading a DefKit module
# runs `go mod download` and `go run` in the Job.
FROM golang:1.23.8-alpine AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY main.go ./
ARG TARGETOS TARGETARCH
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -trimpath -ldflags "-s -w" -o /defkit-render .

FROM golang:1.23.8-alpine
RUN apk add --no-cache git ca-certificates
ENV GOTOOLCHAIN=auto GOFLAGS=-mod=mod HOME=/tmp GOPATH=/tmp/go GOCACHE=/tmp/go-cache
COPY --from=build /defkit-render /usr/local/bin/defkit-render
USER 65532:65532
ENTRYPOINT ["/usr/local/bin/defkit-render"]
