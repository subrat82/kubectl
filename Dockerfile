FROM alpine

ENV HOME=/.kube
ENV VERSION=v1.7.8

WORKDIR $HOME

RUN set -x && \
    apk add --no-cache curl ca-certificates && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/$VERSION/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    adduser kubectl -Du 1701 -h $HOME && \
    kubectl version --client

USER kubectl

ENTRYPOINT ["kubectl"]
CMD ["help"]
