package main

import (
	"math/rand"
	"net/http"
	"sort"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis/v8"
)

var (
	urlStore = make(map[string]string)
	randSrc  = rand.NewSource(time.Now().UnixNano())
	client   *redis.Client
)

func init() {
	client = redis.NewClient(&redis.Options{
		Addr: "localhost:6379", // Update with your Redis server address
	})
}

func generateShortURL() string {
	const letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	b := make([]byte, 6)
	for i := range b {
		b[i] = letters[randSrc.Int63()%int64(len(letters))]
	}
	return string(b)
}

func shortenURL(c *gin.Context) {
	originalURL := c.PostForm("url")

	if shortURL, found := urlStore[originalURL]; found {
		c.JSON(http.StatusOK, gin.H{"shortened_url": shortURL})
		return
	}

	shortURL := generateShortURL()
	urlStore[originalURL] = shortURL

	// Store in Redis
	err := client.Set(c, originalURL, shortURL, 0).Err()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not store URL in Redis"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"shortened_url": shortURL})
}

func redirectToOriginalURL(c *gin.Context) {
	shortURL := c.Param("shortURL")

	originalURL, found := urlStore[shortURL]
	if !found {
		// Check Redis
		val, err := client.Get(c, shortURL).Result()
		if err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "shortened URL not found"})
			return
		}
		originalURL = val
	}

	c.Redirect(http.StatusMovedPermanently, originalURL)
}

func main() {
	router := gin.Default()

	router.POST("/shorten", shortenURL)
	router.GET("/:shortURL", redirectToOriginalURL)
	router.GET("/metrics/top-domains", getTopDomains)

	router.Run(":8080")
}

func getTopDomains(c *gin.Context) {
	domainCount := make(map[string]int)

	for _, url := range urlStore {
		// Extract the domain
		// This is a simple implementation and might not cover all cases
		// You should use a proper URL parsing library
		// Assumes URLs are in the format "http(s)://domain/path"
		domain := strings.Split(url, "/")[2]
		domainCount[domain]++
	}

	// Sort by count
	type DomainCount struct {
		Domain string
		Count  int
	}
	var domainCounts []DomainCount
	for domain, count := range domainCount {
		domainCounts = append(domainCounts, DomainCount{Domain: domain, Count: count})
	}
	sort.Slice(domainCounts, func(i, j int) bool {
		return domainCounts[i].Count > domainCounts[j].Count
	})

	// Output top 3 domains
	topDomains := domainCounts[:3]
	c.JSON(http.StatusOK, topDomains)
}
