#!/bin/bash

usermod -aG docker gitlab-runner

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


gitlab-runner register \
  --non-interactive \
  --url ${URL} \
  --registration-token ${TOKEN} \
  --executor docker \
  --docker-image "docker:24.0.5" \
  --description ${DESCRIPTION} \
  --tag-list ${TAGS} \
  --docker-privileged

echo "Starting GitLab Runner..."
gitlab-runner run --docker-privileged &  # Run in the background


# Dummy HTTP server to prevent Render from shutting down
echo "Starting dummy HTTP server..."
exec python3 -m http.server 8080
