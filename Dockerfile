# Step 1: Modules
FROM golang:1.21.0 as modules
COPY go.mod go.sum /modules/
WORKDIR /modules
RUN go mod download & go mod verify

# Step 2: Builder
FROM golang:1.21.0 as builder
COPY --from=modules /go/pkg /go/pkg
COPY . /build
WORKDIR /build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /bin/app .

# Step 3: Final
FROM alpine:3.18
COPY --from=builder /bin/app /app

CMD ["/app"]