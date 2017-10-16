FROM alpine

ENV HOME=/.kube
ENV VERSION=v1.7.4

WORKDIR $HOME

RUN set -x && \
    apk add --no-cache curl ca-certificates && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$VERSION/bin/linux/amd64/kubectl && \
    mv kubectl /usr/local/bin/ && \
    chmod +x /usr/local/bin/kubectl && \
    adduser kubectl -Du 1701 -h $HOME && \
    kubectl version --client

USER kubectl

ENTRYPOINT ["/bin/sh"]
