FROM gitlab/gitlab-runner
LABEL maintainer="Johann Lange <johannlange@yahoo.de>"

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

CMD ["./entrypoint.sh"]
