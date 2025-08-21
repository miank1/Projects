# Distributed Rate Limiter

A distributed rate limiter implementation using Redis for backend storage.

## Features
- Token Bucket and Leaky Bucket algorithms
- Redis-backed storage with memory fallback
- Configurable rate limits
- HTTP API for rate limiting requests

## Usage

1. Start Redis:
```bash
redis-server
```

2. Run the server:
```bash
go run cmd/main.go
```

3. Test rate limiting:
```bash
curl -H "X-Client-ID: test123" http://localhost:8080/ratelimit
```

## Configuration
- Default rate limit: 100 requests per minute
- Redis address: localhost:6379
- Server port: 8080

## Testing
Run all tests:
```bash
go test ./... -v
```

// Acquire API
curl -X POST http://localhost:8080/acquire \
     -H "X-Client-ID: test123" \
     -d '{"data":"example"}'

// Status API





docker build -t distributed-rate-limiter .

docker run -p 8080:8080 --env REDIS_ADDR=host.docker.internal:6379 distributed-rate-limiter


Here’s a simple flow of your distributed rate limiter project:

1. Client Request
A client sends an HTTP request to your API endpoint (e.g., /ratelimit).
The request includes a unique identifier (e.g., X-Client-ID header).
2. HTTP Handler
The handler receives the request.
It extracts the client key (user ID, API key, etc.).
3. Rate Limiter Selection
The handler uses the configured rate limiting algorithm (Token Bucket or Leaky Bucket).
The rate limiter is initialized with a backing store (Redis for distributed, Memory for local).
4. Store Interaction
The rate limiter checks the store for the current state (Entry) for the client key.
If Redis is available, it uses Redis.
If Redis is unavailable, it falls back to in-memory store.
5. Algorithm Logic
Token Bucket: Refills tokens based on elapsed time, checks if enough tokens are available, decrements tokens if allowed.
Leaky Bucket: Calculates leaked tokens since last request, checks if bucket has space, increments count if allowed.
6. Decision
If the request is allowed, the store is updated and the handler responds with success.
If not allowed, the handler responds with a rate limit error (HTTP 429).
7. Response
The handler sends a JSON response indicating whether the request was allowed or rate limited.
8. Graceful Shutdown
On server shutdown, resources (Redis connections, etc.) are cleaned up.
9. Configuration
All settings (rate, window, Redis address, algorithm) are managed via a config file or defaults.
10. Testing
Unit tests verify the logic of each algorithm and store.
Integration tests verify Redis-backed distributed behavior.
Summary:
Client → HTTP Handler → Rate Limiter → Store (Redis/Memory) → Algorithm → Decision → Response

This flow ensures scalable, distributed, and configurable rate limiting for your API.