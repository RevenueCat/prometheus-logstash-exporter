FROM golang:1.23-alpine AS builder
WORKDIR /src/
COPY go.mod go.sum main.go ./
RUN apk -U add binutils && CGO_ENABLED=0 go build -o prometheus-logstash-exporter && strip prometheus-logstash-exporter

FROM alpine
WORKDIR /
COPY --from=builder /src/prometheus-logstash-exporter /
EXPOSE 9100
ENTRYPOINT ["/prometheus-logstash-exporter"]
