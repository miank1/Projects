package limiter

type Limiter interface {
	Allow(key string) (bool, error)
}
