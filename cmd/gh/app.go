package main

import (
	"bytes"
	"context"
	"fmt"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/google/go-github/v32/github"
)

func app(ctx context.Context, pem bytes.Buffer, clientID int64, installationID int64, client *github.Client) (string, error) {
	privateKey, err := jwt.ParseRSAPrivateKeyFromPEM(pem.Bytes())
	if err != nil {
		return "", err
	}

	now := time.Now()
	token := jwt.New(jwt.SigningMethodRS256)
	token.Claims = &jwt.StandardClaims{
		IssuedAt:  now.Unix(),
		ExpiresAt: now.Add(10 * time.Minute).Unix(),
		Issuer:    fmt.Sprintf("%s", clientID),
	}

	str, err := token.SignedString(privateKey)
	if err != nil {
		return "", err
	}

	// req.AddHeader("Authorization", "Bearer "+str)
	installationToken, _, err := client.Apps.CreateInstallationToken(ctx, installationID, nil)
	if err != nil {
		return "", err
	}

	return installationToken.GetToken(), err
}
