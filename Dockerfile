# Use the official GitLab Runner image
FROM gitlab/gitlab-runner:latest

# Set working directory
WORKDIR /app

ENV TOKEN $TOKEN

# Ensure Docker is installed
RUN apt-get update && apt-get install -y docker.io

# Register the GitLab Runner with privileged mode
RUN gitlab-runner register --non-interactive \
  --url "https://gitlab.com/" \
  --registration-token "${TOKEN}" \
  --tag-list ${TAGS} \
  --executor "docker" \
  --docker-image "docker:latest" \
  --docker-privileged

# Modify config.toml to enable privileged mode and set Docker host
RUN sed -i '/^\[runners.docker\]/a \
    privileged = true \
    DOCKER_HOST = "tcp://docker:2375"' /etc/gitlab-runner/config.toml

# Ensure Docker daemon runs properly
RUN service docker start || true

# Run GitLab Runner in privileged mode
CMD ["gitlab-runner", "run", "--docker-privileged"]
