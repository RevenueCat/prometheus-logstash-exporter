ARG BUILDPLATFORM
FROM --platform=$BUILDPLATFORM golang:1.23-alpine AS builder
ARG TARGETOS
ARG TARGETARCH
WORKDIR /src/
COPY go.mod go.sum main.go ./
RUN target_os="${TARGETOS:-$(go env GOOS)}" && \
    target_arch="${TARGETARCH:-$(go env GOARCH)}" && \
    CGO_ENABLED=0 GOOS="$target_os" GOARCH="$target_arch" \
    go build -ldflags="-s -w" -o prometheus-logstash-exporter

FROM alpine
WORKDIR /
COPY --from=builder /src/prometheus-logstash-exporter /
EXPOSE 9100
ENTRYPOINT ["/prometheus-logstash-exporter"]
