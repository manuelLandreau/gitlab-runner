FROM gitlab/gitlab-runner
LABEL maintainer="Johann Lange <johannlange@yahoo.de>"

# Copy the entrypoint script into the container
COPY entrypoint.sh /entrypoint.sh

# Ensure the script has execution permissions
RUN chmod +x /entrypoint.sh

# Use the custom entrypoint script
CMD ["sh /entrypoint.sh"]
