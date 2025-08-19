package store

// Placeholder Redis store implementation
type RedisStore struct{}

func NewRedisStore() *RedisStore {
	return &RedisStore{}
}

func (rs *RedisStore) Increment(key string) (int, error) {
	// TODO: connect to Redis later
	return 1, nil
}

func (rs *RedisStore) Reset(key string) error {
	// TODO: implement Redis reset
	return nil
}
