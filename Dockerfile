FROM gitlab/gitlab-runner
LABEL maintainer="Johann Lange <johannlange@yahoo.de>"

# Install Python (needed for dummy server)
RUN apt-get update && apt-get install -y python3

# Copy the entrypoint script into the container
COPY entrypoint.sh /entrypoint.sh

# Ensure the script has execution permissions
RUN chmod +x /entrypoint.sh

