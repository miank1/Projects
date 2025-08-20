package store

import (
	"context"
	"strconv"
	"time"

	"github.com/redis/go-redis/v9"
)

type RedisStore struct {
	client *redis.Client
	ctx    context.Context
}

func NewRedisStore(addr string) (*RedisStore, error) {
	client := redis.NewClient(&redis.Options{
		Addr: addr,
	})

	ctx := context.Background()

	// Test connection
	if err := client.Ping(ctx).Err(); err != nil {
		return nil, err
	}

	return &RedisStore{
		client: client,
		ctx:    ctx,
	}, nil
}

func (rs *RedisStore) Get(key string) (Entry, bool) {
	val, err := rs.client.HGetAll(rs.ctx, key).Result()
	if err != nil {
		return Entry{}, false
	}

	if len(val) == 0 {
		return Entry{}, false
	}

	count, _ := strconv.Atoi(val["count"])
	expiry, _ := strconv.ParseInt(val["expiry"], 10, 64)

	return Entry{
		Count:  count,
		Expiry: expiry,
	}, true
}

func (rs *RedisStore) Set(key string, entry Entry) {
	rs.client.HSet(rs.ctx, key, map[string]interface{}{
		"count":  entry.Count,
		"expiry": entry.Expiry,
	})
	// Set key expiration
	rs.client.ExpireAt(rs.ctx, key, time.Unix(entry.Expiry, 0))
}
