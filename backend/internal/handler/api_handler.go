package handler

import (
	"net/http"
	"time"

	"github.com/example/loginkeycloak-backend/internal/auth"
	"github.com/gin-gonic/gin"
)

type APIHandler struct{}

func NewAPIHandler() *APIHandler {
	return &APIHandler{}
}

// Ping adalah endpoint publik: GET /api/v1/public/ping
func (h *APIHandler) Ping(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status":    "ok",
		"message":   "pong - public endpoint accessible",
		"timestamp": time.Now().Format(time.RFC3339),
	})
}

// GetProfile adalah endpoint terproteksi: GET /api/v1/profile
func (h *APIHandler) GetProfile(c *gin.Context) {
	claims, ok := auth.GetUserFromContext(c.Request.Context())
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "user context not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status": "success",
		"data": gin.H{
			"sub":                claims.Subject,
			"email":              claims.Email,
			"email_verified":     claims.EmailVerified,
			"name":               claims.Name,
			"preferred_username": claims.PreferredUsername,
			"roles":              claims.RealmAccess.Roles,
		},
	})
}

// GetAdminDashboard adalah endpoint khusus role app-admin: GET /api/v1/admin/dashboard
func (h *APIHandler) GetAdminDashboard(c *gin.Context) {
	claims, _ := auth.GetUserFromContext(c.Request.Context())

	c.JSON(http.StatusOK, gin.H{
		"status":  "success",
		"message": "Selamat datang di Dashboard Admin",
		"admin":   claims.Email,
		"metrics": gin.H{
			"active_sessions": 42,
			"system_health":   "99.98%",
			"realm_roles":     claims.RealmAccess.Roles,
		},
	})
}

