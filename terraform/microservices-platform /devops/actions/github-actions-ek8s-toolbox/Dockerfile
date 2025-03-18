FROM python:3.7-alpine

ENV HOME "/root"
ENV HELM_VERSION 3.2.4
ENV HELMFILE_VERSION 0.120.0
ENV ISTIOCTL_VERSION 1.5.7
ENV KUBECTL_VERSION 1.18.5
ENV KUBEVAL_VERSION 0.15.0

RUN apk add --update --no-cache bash git curl build-base
RUN pip3 install --upgrade awscli

RUN wget -qO helm-v${HELM_VERSION}-linux-amd64.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar xzf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
helm plugin install https://github.com/databus23/helm-diff --version master 1>/dev/null 2>&1

RUN wget -qO helmfile https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 && \
    mv helmfile /usr/local/bin/helmfile && \ 
    chmod +x /usr/local/bin/helmfile

RUN wget -qO istio-${ISTIOCTL_VERSION}-linux.tar.gz https://github.com/istio/istio/releases/download/${ISTIOCTL_VERSION}/istio-${ISTIOCTL_VERSION}-linux.tar.gz && \
    tar xzf istio-${ISTIOCTL_VERSION}-linux.tar.gz && \
    mv istio-${ISTIOCTL_VERSION}/bin/istioctl /usr/local/bin/istioctl && \
    chmod +x /usr/local/bin/istioctl && \
    rm -Rf istio-${ISTIOCTL_VERSION}/ istio-${ISTIOCTL_VERSION}-linux.tar.gz

RUN wget -qO kubeval-linux-amd64.tar.gz https://github.com/instrumenta/kubeval/releases/download/${KUBEVAL_VERSION}/kubeval-linux-amd64.tar.gz && \
    tar xzf kubeval-linux-amd64.tar.gz && \
    mv kubeval /usr/local/bin/kubeval && \
    chmod +x /usr/local/bin/kubeval && \
    rm -Rf kubeval-linux-amd64.tar.gz LICENCE README.md

RUN wget -qO /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl

RUN wget -qO /usr/local/bin/kubectx https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx && \
    chmod +x /usr/local/bin/kubectx

RUN wget -qO /usr/local/bin/kubens https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens && \
    chmod +x /usr/local/bin/kubens