FROM gitlab/gitlab-runner
LABEL maintainer="Johann Lange <johannlange@yahoo.de>"

# Set working directory
WORKDIR /app

# Copy the entrypoint script into the container
COPY entrypoint.sh /app/entrypoint.sh

# Ensure the script has execution permissions
RUN chmod +x /app/entrypoint.sh

# Use the custom entrypoint script
CMD ["/app/entrypoint.sh"]
