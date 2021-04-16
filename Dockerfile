FROM alpine:3.12

LABEL maintainer="wrpota <wrpota@gmail.com>"

ENV HUGO_VERSION=0.82.0 \
    HUGO_USER=hugo \
    HUGO_SITE=/hugo \
    HUGO_PORT=1313

ENV HUGO_DOWNURL=https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz

RUN set -eux; \
    apk update && \
    apk upgrade && \
    apk add --no-cache \
        git \
        curl && \
    curl -SL ${HUGO_DOWNURL} -o /tmp/hugo.tar.gz && \
    tar -xzf /tmp/hugo.tar.gz -C /tmp && \
    mv /tmp/hugo /usr/local/bin/ && \
    rm -rf /tmp/* && \
    adduser ${HUGO_USER} -D && \
    apk del curl

USER ${HUGO_USER}

VOLUME ${HUGO_SITE}

WORKDIR ${HUGO_SITE}

EXPOSE ${HUGO_PORT}

# CMD ["top"]
# CMD ["hugo", "server", "--bind", "0.0.0.0", "--port", ${HUGO_PORT}]
CMD hugo server \
    --bind 0.0.0.0 \
    --port ${HUGO_PORT}\
    --navigateToChanged \
    --templateMetrics \
    --buildDrafts