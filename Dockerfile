# Use Docker's official docker-in-docker (dind) image
FROM docker:23.0.1-dind

# Set the GitLab Runner version you want to install
ARG TOKEN

# Install GitLab Runner
RUN apk add --no-cache curl bash python3 && \
    curl -L "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64" \
         -o /usr/local/bin/gitlab-runner && \
    chmod +x /usr/local/bin/gitlab-runner

# Copy the custom entrypoint script into the container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# By default, run Docker in Docker alongside GitLab Runner
ENTRYPOINT ["/entrypoint.sh"]
