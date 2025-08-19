package limiter

type LeakyBucket struct{}

func NewLeakyBucket() *LeakyBucket {
	return &LeakyBucket{}
}

func (lb *LeakyBucket) Allow(key string) bool {
	// placeholder logic
	return true
}
