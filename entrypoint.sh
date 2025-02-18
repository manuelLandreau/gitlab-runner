#!/usr/bin/env sh
set -e

# 1) Start the Docker daemon in the background
dockerd --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375 &

# 2) Wait for Docker to become available
echo "Starting Docker daemon..."
while ! docker info >/dev/null 2>&1; do
  echo "Waiting for Docker to be up..."
  sleep 1
done
echo "Docker daemon is running!"

if [ -z "$TOKEN" ]; then
  echo "ERROR: TOKEN is not set."
  exit 1
fi

# Register the runner (non-interactive)
gitlab-runner register --non-interactive \
    --url "https://gitlab.com" \
    --registration-token "$TOKEN" \
    --executor "docker" \
    --docker-privileged \
    --docker-image docker:latest \
    --description "render runner" \
    --tag-list "docker,dind" \
    --run-untagged="true" \
    --locked="false"

# Start the GitLab Runner service
gitlab-runner run --user=gitlab-runner --privileged &


# Dummy HTTP server to prevent Render from shutting down
echo "Starting dummy HTTP server..."
exec python3 -m http.server 8080
