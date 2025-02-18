FROM gitlab/gitlab-runner:latest

ARG TOKEN

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    python3 \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install Docker
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh && \
    rm get-docker.sh

RUN usermod -aG docker gitlab-runner

# Create directory for GitLab Runner configuration
RUN mkdir -p /etc/gitlab-runner

# Create registration script
RUN gitlab-runner register \
  --non-interactive \
  --url "https://gitlab.com" \
  --registration-token $TOKEN \
  --executor docker \
  --description "My Docker Runner" \
  --docker-image "docker:24.0.6" \
  --docker-privileged \
  --docker-volumes "/certs/client"

RUN gitlab-runner run &


# Default command
CMD ["python3", "-m", "http.server", "8080"]
