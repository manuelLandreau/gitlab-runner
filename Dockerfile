FROM gitlab/gitlab-runner:latest

ARG TOKEN

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    python3 \
    jq \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

RUN usermod -aG docker root

# Create directory for GitLab Runner configuration
RUN mkdir -p /etc/gitlab-runner

RUN dockerd &

COPY entrypoint.sh /entrypoint.sh

# Create registration script
RUN gitlab-runner register \
  --non-interactive \
  --url "https://gitlab.com" \
  --registration-token $TOKEN \
  --executor docker \
  --description "My Docker Runner" \
  --docker-image "docker:24.0.6" \
  --docker-privileged \
  --docker-volumes "/runner/services/docker"

# Default command
CMD ["/entrypoint.sh"]
