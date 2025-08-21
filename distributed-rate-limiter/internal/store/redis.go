package store

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/go-redis/redis/v8"
)

type RedisStore struct {
	client  *redis.Client
	ctx     context.Context
	timeout time.Duration
}

type RedisConfig struct {
	Addr     string
	Password string
	DB       int
	Timeout  time.Duration
}

func NewRedisStore(config RedisConfig) (*RedisStore, error) {
	if config.Timeout == 0 {
		config.Timeout = 5 * time.Second
	}

	client := redis.NewClient(&redis.Options{
		Addr:     config.Addr,
		Password: config.Password,
		DB:       config.DB,
	})

	ctx := context.Background()

	// Test connection
	if err := client.Ping(ctx).Err(); err != nil {
		return nil, errors.New("failed to connect to Redis: " + err.Error())
	}

	return &RedisStore{
		client:  client,
		ctx:     ctx,
		timeout: config.Timeout,
	}, nil
}

func (rs *RedisStore) Get(key string) (*Entry, error) {
	ctx, cancel := context.WithTimeout(rs.ctx, rs.timeout)
	defer cancel()

	val, err := rs.client.Get(ctx, key).Result()
	if err == redis.Nil {
		return nil, ErrKeyNotFound
	}
	if err != nil {
		return nil, errors.New("redis get error: " + err.Error())
	}

	var entry Entry
	if err := json.Unmarshal([]byte(val), &entry); err != nil {
		return nil, errors.New("failed to unmarshal entry: " + err.Error())
	}

	// Check if entry has expired
	if time.Now().Unix() > entry.Expiry {
		rs.Delete(key)
		return nil, ErrKeyNotFound
	}

	return &entry, nil
}

func (rs *RedisStore) Set(key string, entry *Entry) error {
	if entry == nil {
		return errors.New("entry cannot be nil")
	}

	ctx, cancel := context.WithTimeout(rs.ctx, rs.timeout)
	defer cancel()

	data, err := json.Marshal(entry)
	if err != nil {
		return errors.New("failed to marshal entry: " + err.Error())
	}

	expiration := time.Until(time.Unix(entry.Expiry, 0))
	if expiration <= 0 {
		return errors.New("invalid expiration time")
	}

	err = rs.client.Set(ctx, key, data, expiration).Err()
	if err != nil {
		return errors.New("redis set error: " + err.Error())
	}

	return nil
}

func (rs *RedisStore) Delete(key string) error {
	ctx, cancel := context.WithTimeout(rs.ctx, rs.timeout)
	defer cancel()

	err := rs.client.Del(ctx, key).Err()
	if err != nil {
		return errors.New("redis delete error: " + err.Error())
	}

	return nil
}

func (rs *RedisStore) Close() error {
	return rs.client.Close()
}
