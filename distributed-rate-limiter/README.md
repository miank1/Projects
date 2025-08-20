The Token Bucket algorithm works like this:

Each user has a "bucket" with tokens.

Every request consumes 1 token.

Tokens refill at a fixed rate (e.g., 1 token/sec).

If bucket is empty → reject request.