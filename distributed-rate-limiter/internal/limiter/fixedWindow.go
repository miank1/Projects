package limiter

type FixedWindow struct{}

func NewFixedWindow() *FixedWindow {
	return &FixedWindow{}
}

func (fw *FixedWindow) Allow(key string) bool {
	// placeholder logic
	return true
}
