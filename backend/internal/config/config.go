package config

import (
	"os"
)

type Config struct {
	Port              string
	FirebaseProjectID string
	Environment       string
}

func Load() (*Config, error) {
	cfg := &Config{
		Port:              getEnv("PORT", "8080"),
		FirebaseProjectID: getEnv("FIREBASE_PROJECT_ID", ""),
		Environment:       getEnv("ENVIRONMENT", "development"),
	}

	return cfg, nil
}

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}

func (c *Config) IsDevelopment() bool {
	return c.Environment == "development"
}

func (c *Config) IsProduction() bool {
	return c.Environment == "production"
}
