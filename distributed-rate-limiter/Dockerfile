# Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy go.mod and go.sum first for caching
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the Go binary
RUN go build -o rate-limiter ./cmd/main.go

# Final stage
FROM alpine:latest

WORKDIR /app

# Copy the binary from builder
COPY --from=builder /app/rate-limiter .

# Expose the HTTP port
EXPOSE 8080

# Set environment variables if needed
ENV REDIS_ADDR=redis:6379

# Run the service
CMD ["./rate-limiter"]