package main

import (
	"context"
	"log"
	"os"
	"time"

	"github.com/example/loginkeycloak-backend/internal/auth"
	"github.com/example/loginkeycloak-backend/internal/handler"
	"github.com/gin-gonic/gin"
)

func main() {
	issuerURL := os.Getenv("KEYCLOAK_ISSUER_URL")
	if issuerURL == "" {
		issuerURL = "http://localhost:8080/realms/flutter-realm"
	}

	clientID := os.Getenv("KEYCLOAK_CLIENT_ID")
	if clientID == "" {
		clientID = "go-backend"
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "8081"
	}

	ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()

	// Inisialisasi OIDC Validator (otomatis mengambil & mem-cache JWKS dari Keycloak)
	oidcValidator, err := auth.NewOIDCValidator(ctx, issuerURL, clientID)
	if err != nil {
		log.Fatalf("Gagal menginisialisasi OIDC Validator: %v", err)
	}

	r := gin.Default()
	apiHandler := handler.NewAPIHandler()

	v1 := r.Group("/api/v1")
	{
		// 1. Endpoint Publik
		v1.GET("/public/ping", apiHandler.Ping)

		// 2. Endpoint Terproteksi (Membutuhkan Valid Bearer Token)
		protected := v1.Group("")
		protected.Use(oidcValidator.AuthMiddleware())
		{
			protected.GET("/profile", apiHandler.GetProfile)

			// 3. Endpoint RBAC (Membutuhkan Role 'app-admin')
			admin := protected.Group("/admin")
			admin.Use(auth.RequireRole("app-admin"))
			{
				admin.GET("/dashboard", apiHandler.GetAdminDashboard)
			}
		}
	}

	log.Printf("Server Golang berjalan di port :%s (Keycloak Issuer: %s)", port, issuerURL)
	if err := r.Run(":" + port); err != nil {
		log.Fatalf("Gagal menjalankan server: %v", err)
	}
}

