#!/bin/bash

usermod -aG docker gitlab-runner

# Ensure Docker daemon runs properly
RUN service docker start || true

while [ $# -gt 0 ]; do
  case "$1" in
    --url=*)
      URL="${1#*=}"
      ;;
    --registration-token=*)
      TOKEN="${1#*=}"
      ;;
    --docker-image=*)
      DOCKER_IMAGE="${1#*=}"
      ;;
    --description=*)
      DESCRIPTION="${1#*=}"
      ;;
    --tag-list=*)
      TAGS="${1#*=}"
      ;;
    --run-untagged=*)
      RUN_UNTAGGED="${1#*=}"
      ;;
    --locked=*)
      LOCKED="${1#*=}"
      ;;
    --access-level=*)
      ACCESS_LEVEL="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done



# Register the GitLab Runner with privileged mode
gitlab-runner register --non-interactive \
  --url "https://gitlab.com/" \
  --registration-token "${TOKEN}" \
  --tag-list ${TAGS} \
  --executor "shell" \
  --docker-image "docker:latest" \
  --docker-privileged

cat /etc/gitlab-runner/config.toml


# Dummy HTTP server to prevent Render from shutting down
echo "Starting dummy HTTP server..."
exec python3 -m http.server 8080
