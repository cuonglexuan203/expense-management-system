# Stage 1: Build environment
# Use a specific Go version matching your development environment
FROM golang:1.24.2-alpine AS builder

# Install necessary build tools: git (for go modules), gcc (for CGO if needed)
RUN apk update && apk add --no-cache git build-base

WORKDIR /app

# Copy go module files and download dependencies first to leverage Docker cache
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go application
# - CGO_ENABLED=0 produces a static binary (no external C dependencies)
# - -ldflags="-w -s" strips debug symbols and reduces binary size
# - -o /app/server specifies the output binary path
# Ensure the main package path is correct
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o /app/server cmd/api/main.go


# Stage 2: Runtime environment
# Use a minimal Alpine image for the final stage
FROM alpine:3.21

# Install CA certificates for making HTTPS calls (e.g., to Firebase, Backend API)
RUN apk update && apk add --no-cache ca-certificates tzdata

WORKDIR /app

# Copy the compiled application binary from the builder stage
COPY --from=builder /app/server /app/server

# Copy the Firebase service account key into the image
# IMPORTANT: Adjust the source path relative to your Docker build context (the Go service root)
# Example: if your key is in 'config/serviceAccountKey.json' within the Go project:
COPY ./firebase-account-key.json /app/firebase-account-key.json
# If it's outside the project, you might need to adjust the build context or copy it there first.

# Copy config.yaml if you are using it alongside environment variables
# COPY config.yaml /app/config.yaml

# Set the default port the application listens on (can be overridden by APP_PORT env var)
EXPOSE 8081

# Command to run the application
CMD ["/app/server"]
