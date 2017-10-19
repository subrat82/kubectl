FROM alpine

MAINTAINER Adonys Maceo <adomaceo@yahoo.es>

ENV CONF=/srv/kubectl
ENV VERSION=v1.7.8

RUN apk add --no-cache curl ca-certificates && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/$VERSION/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    adduser kubectl -Du 1701 -h $CONF && \
    kubectl version --client

WORKDIR $CONF

USER kubectl

ENTRYPOINT ["kubectl"]
CMD ["help"]
