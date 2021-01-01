# Build the manager binary
FROM golang:1.15.5-alpine3.12 as builder

# Copy in the go src
WORKDIR /app
COPY go.mod* .
COPY pkg/    pkg/
COPY cmd/    cmd/

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64
# Build
RUN go mod tidy
RUN cd cmd/manager && go build -o ../..

# Copy the controller-manager into a thin image
FROM alpine:3.12.1
RUN apk add --no-cache ca-certificates

WORKDIR /root/
COPY --from=builder /app/manager .
ENTRYPOINT ["./manager"]
