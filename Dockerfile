FROM alpine

MAINTAINER Adonys Maceo <adomaceo@yahoo.es>

ENV VERSION=v1.7.8

RUN apk add --update ca-certificates && \
    apk add --update -t deps curl && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/$VERSION/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    apk del --purge deps && \
    rm /var/cache/apk/* && \
    kubectl version --client

ENTRYPOINT ["kubectl"]
CMD ["help"]
