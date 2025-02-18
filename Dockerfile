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

# Create directory for GitLab Runner configuration
RUN mkdir -p /etc/gitlab-runner

RUN echo "$TOKEN"

ENV GITLAB_RUNNER_TOKEN="$TOKEN"

# Create registration script
RUN gitlab-runner register \
  --non-interactive \
  --url "https://gitlab.com" \
  --registration-token "${GITLAB_RUNNER_TOKEN}" \
  --executor docker \
  --docker-image docker:stable \
  --docker-privileged \
  --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" \
  --docker-volumes "/cache" \
  --description "Docker Runner with Render.com support" \
  --tag-list "docker,render,dind,shared" \
  --run-untagged="true" \
  --locked="false"

# Example config.toml content
RUN exec gitlab-runner run --user=gitlab-runner --working-directory=/home/gitlab-runner &

# Default command
CMD ["python3", "-m", "http.server", "8080"]
