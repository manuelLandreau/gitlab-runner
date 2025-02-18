#!/usr/bin/env sh
set -e

sudo groupadd docker
sudo gpasswd -a gitlab-runner docker
sudo service docker restart

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
gitlab-runner run --user=gitlab-runner &


# Dummy HTTP server to prevent Render from shutting down
echo "Starting dummy HTTP server..."
exec python3 -m http.server 8080
