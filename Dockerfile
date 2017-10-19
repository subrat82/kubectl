FROM alpine

MAINTAINER Adonys Maceo <adomaceo@yahoo.es>

ENV HOME_CONFIG=/.kube
ENV VERSION=v1.7.8

WORKDIR $HOME_CONFIG

RUN apk add --update ca-certificates && \
    apk add --update -t deps curl && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/$VERSION/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    apk del --purge deps && \
    rm /var/cache/apk/* && \
    adduser kubectl -Du 1701 -h $HOME_CONFIG && \
    kubectl version --client

USER kubectl

ENTRYPOINT ["kubectl"]
CMD ["help"]
