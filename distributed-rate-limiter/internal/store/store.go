package store

type Store interface {
	Increment(key string) (int, error)
	Reset(key string) error
}
