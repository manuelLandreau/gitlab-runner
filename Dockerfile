FROM gitlab/gitlab-runner
LABEL maintainer="Johann Lange <johannlange@yahoo.de>"

COPY register.bash /register.bash


EXPOSE 80/tcp

# Register the gitlab-runner if not exist
ENTRYPOINT /register.bash \
  --url=$URL \
  --registration-token=$TOKEN \
  --docker-image=DOCKER_IMAGE \
  --description=$DESCRIPTION \
  --tag-list=$TAGS \
  --run-untagged=$RUN_UNTAGGED \
  --locked=$LOCKED \
  --access-level=$ACCESS_LEVEL
