package config

import (
	"encoding/json"
	"os"
)

// Config holds all configuration for the rate limiter service
type Config struct {
	RedisAddr  string // Redis server address
	Port       int    // HTTP server port
	RateLimit  int    // Number of requests allowed
	WindowSize int    // Time window in seconds
	Algorithm  string // Rate limiting algorithm (token/leaky)
}

// DefaultConfig returns a configuration with sensible default values
func DefaultConfig() *Config {
	return &Config{
		RedisAddr:  "localhost:6379",
		Port:       8080,
		RateLimit:  100,     // 100 requests
		WindowSize: 60,      // per 60 seconds
		Algorithm:  "token", // default to token bucket
	}
}

func LoadConfig(path string) (*Config, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	decoder := json.NewDecoder(file)
	cfg := &Config{}
	if err := decoder.Decode(cfg); err != nil {
		return nil, err
	}
	return cfg, nil
}
