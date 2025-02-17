FROM gitlab/gitlab-runner
LABEL maintainer="Johann Lange <johannlange@yahoo.de>"

COPY register.sh /register.sh

# Register the gitlab-runner if not exist
CMD ./register.sh
