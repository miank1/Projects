package limiter

type TokenBucket struct{}

func NewTokenBucket() *TokenBucket {
	return &TokenBucket{}
}

func (tb *TokenBucket) Allow(key string) bool {
	// placeholder logic
	return true
}
