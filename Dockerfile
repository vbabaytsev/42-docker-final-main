# Шаг 1: Билдер
FROM golang:latest as builder
WORKDIR /build
COPY . .
RUN go mod download && go mod verify
ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64
RUN go build -o /bin/app .

# Шаг 2: Упаковка
FROM alpine:3.18
COPY --from=builder /bin/app /app
COPY --from=builder /build/tracker.db /tracker.db
CMD ["/app"]