package auth

import (
	"context"
	"fmt"
	"net/http"
	"strings"

	"github.com/coreos/go-oidc/v3/oidc"
	"github.com/gin-gonic/gin"
)

type contextKey string

const UserClaimsKey contextKey = "user_claims"

// UserClaims merepresentasikan struktur klaim JWT dari Keycloak
type UserClaims struct {
	Subject           string   `json:"sub"`
	Email             string   `json:"email"`
	EmailVerified     bool     `json:"email_verified"`
	Name              string   `json:"name"`
	PreferredUsername string   `json:"preferred_username"`
	RealmAccess       struct {
		Roles []string `json:"roles"`
	} `json:"realm_access"`
}

// HasRole memeriksa apakah user memiliki role tertentu di dalam realm_access.roles
func (u *UserClaims) HasRole(targetRole string) bool {
	for _, r := range u.RealmAccess.Roles {
		if r == targetRole {
			return true
		}
	}
	return false
}

// OIDCValidator mengelola provider OIDC dan verifier JWKS dengan auto-caching
type OIDCValidator struct {
	Provider *oidc.Provider
	Verifier *oidc.IDTokenVerifier
}

// NewOIDCValidator menginisialisasi koneksi ke Keycloak OIDC Discovery endpoint
// issuerURL contoh: "http://localhost:8080/realms/my-realm"
func NewOIDCValidator(ctx context.Context, issuerURL string, expectedClientID string) (*OIDCValidator, error) {
	provider, err := oidc.NewProvider(ctx, issuerURL)
	if err != nil {
		return nil, fmt.Errorf("gagal inisialisasi OIDC provider dari %s: %w", issuerURL, err)
	}

	// Konfigurasi verifier:
	// SkipClientIDCheck diset true karena Access Token dari Keycloak umumnya memiliki
	// audience ("aud") berupa "account" atau list service, sedangkan "azp" adalah "flutter-mobile-app".
	// Validasi signature (RS256 via JWKS), Issuer, dan Expiry tetap dijalankan penuh oleh go-oidc.
	oidcConfig := &oidc.Config{
		SkipClientIDCheck: true,
	}

	verifier := provider.Verifier(oidcConfig)

	return &OIDCValidator{
		Provider: provider,
		Verifier: verifier,
	}, nil
}

// AuthMiddleware memvalidasi header Authorization: Bearer <access_token>
func (v *OIDCValidator) AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
				"error":   "unauthorized",
				"message": "Header Authorization tidak ditemukan",
			})
			return
		}

		parts := strings.SplitN(authHeader, " ", 2)
		if len(parts) != 2 || !strings.EqualFold(parts[0], "Bearer") {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
				"error":   "unauthorized",
				"message": "Format Authorization harus 'Bearer <token>'",
			})
			return
		}

		rawToken := parts[1]

		// Verifikasi signature JWT via JWKS Keycloak, validasi exp & iss
		idToken, err := v.Verifier.Verify(c.Request.Context(), rawToken)
		if err != nil {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
				"error":   "invalid_token",
				"message": fmt.Sprintf("Token tidak valid atau kadaluarsa: %v", err),
			})
			return
		}

		// Ekstraksi custom claims (sub, email, realm_access.roles)
		var claims UserClaims
		if err := idToken.Claims(&claims); err != nil {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{
				"error":   "claims_extraction_failed",
				"message": "Gagal mengekstrak klaim dari token",
			})
			return
		}

		// Injeksi klaim user ke dalam standard context.Context dan gin.Context
		ctxWithClaims := context.WithValue(c.Request.Context(), UserClaimsKey, &claims)
		c.Request = c.Request.WithContext(ctxWithClaims)
		c.Set(string(UserClaimsKey), &claims)

		c.Next()
	}
}

// RequireRole adalah middleware RBAC untuk memastikan user memiliki role tertentu (misal: "app-admin")
func RequireRole(role string) gin.HandlerFunc {
	return func(c *gin.Context) {
		claims, ok := GetUserFromContext(c.Request.Context())
		if !ok || claims == nil {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
				"error":   "unauthorized",
				"message": "Identitas user tidak ditemukan di dalam context",
			})
			return
		}

		if !claims.HasRole(role) {
			c.AbortWithStatusJSON(http.StatusForbidden, gin.H{
				"error":   "forbidden",
				"message": fmt.Sprintf("Akses ditolak: membutuhkan role '%s'", role),
			})
			return
		}

		c.Next()
	}
}

// GetUserFromContext mengambil UserClaims dari standard context.Context
func GetUserFromContext(ctx context.Context) (*UserClaims, bool) {
	claims, ok := ctx.Value(UserClaimsKey).(*UserClaims)
	return claims, ok
}

