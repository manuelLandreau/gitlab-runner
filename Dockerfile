FROM gitlab/gitlab-runner:latest

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install Docker
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh && \
    rm get-docker.sh

# Create directory for GitLab Runner configuration
RUN mkdir -p /etc/gitlab-runner

RUN echo "$TOKEN"

ENV GITLAB_RUNNER_TOKEN="$TOKEN"
ENV GITLAB_URL="https://gitlab.com"

# Create registration script
RUN echo '#!/bin/bash \n\
gitlab-runner register \
  --non-interactive \
  --url "${GITLAB_URL}" \
  --registration-token "${GITLAB_RUNNER_TOKEN}" \
  --executor docker \
  --docker-image docker:stable \
  --docker-privileged \
  --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" \
  --docker-volumes "/cache" \
  --description "Docker Runner with Render.com support" \
  --tag-list "docker,render,dind,shared" \
  --run-untagged="true" \
  --locked="false"' > /entrypoint.sh && \
  chmod +x /entrypoint.sh

# Example config.toml content
RUN echo 'concurrent = 1 \n\
check_interval = 0 \n\
\n\
[session_server] \n\
  session_timeout = 1800 \n\
\n\
[[runners]] \n\
  name = "Docker Runner with Render.com" \n\
  url = "${GITLAB_URL}" \n\
  token = "${GITLAB_RUNNER_TOKEN}" \n\
  executor = "docker" \n\
  [runners.docker] \n\
    tls_verify = false \n\
    image = "docker:stable" \n\
    privileged = true \n\
    disable_cache = false \n\
    volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache"] \n\
    shm_size = 0 \n\
  [runners.cache] \n\
    [runners.cache.s3] \n\
    [runners.cache.gcs]' > /etc/gitlab-runner/config.toml

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
