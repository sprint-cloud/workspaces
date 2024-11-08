


FROM codercom/enterprise-base:ubuntu AS tools
USER root
RUN apt update && apt install -y gpg-agent
RUN mkdir -p /downloads/bin && chown -R coder:coder /downloads
USER coder
COPY --from=composer/composer /usr/bin/composer /download/bin/composer
#COPY --from=bitnami/kubectl /opt/bitnami/kubectl/bin/kubectl /download/bin/kubectl
COPY --from=argoproj/argocd /usr/local/bin/argocd /download/bin/argocd
COPY --from=bitnami/argo-workflow-cli /argo /download/bin/argo
#COPY --from=maniator/gh /usr/bin/gh /download/bin/gh

ARG GH_VERSION=2.61.0
ARG WERF_VERSION=2.12.1
ARG ACT_VERSION=0.2.69
ARG KUBECTL_VERSION=1.31.2


WORKDIR /downloads
# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256" && \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check && \
    install -m 755 kubectl /downloads/bin/

# Install Github client
RUN wget https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz && \
    wget https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_checksums.txt && \
    find . -type f -exec sha256sum {} \; >> gh_${GH_VERSION}_checksums.txt && \
    tar -zxvf gh_${GH_VERSION}_linux_amd64.tar.gz && \
    install -m 0755 gh_${GH_VERSION}_linux_amd64/bin/gh /downloads/bin/gh

# Install local act runner
RUN wget https://github.com/nektos/act/releases/download/v${ACT_VERSION}/act_Linux_x86_64.tar.gz && \
    wget https://github.com/nektos/act/releases/download/v${ACT_VERSION}/checksums.txt && \
    find . -type f -exec sha256sum {} \; >> checksums.txt && \
    tar xzvf act_Linux_x86_64.tar.gz && \
    install -m 0755 act /downloads/bin

# Install werf
RUN curl -sSLO "https://tuf.werf.io/targets/releases/${WERF_VERSION}/linux-amd64/bin/werf"\
    -O "https://tuf.werf.io/targets/signatures/${WERF_VERSION}/linux-amd64/bin/werf.sig" && \
    curl -sSL https://werf.io/werf.asc | gpg --import && gpg --verify werf.sig werf && \
    install -m 0755 werf /downloads/bin/werf




FROM codercom/enterprise-base:ubuntu
LABEL org.opencontainers.image.source https://github.com/sprint-cloud/workspaces

USER root
# Install packages
RUN apt update && sudo apt install -y \
    zsh \
    nodejs \
    npm \
    php-cli\
    unzip\
    golang-go\
    dotnet-sdk-8.0

RUN apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/
COPY --from=tools /downloads/bin/* /usr/local/bin/

RUN mkdir /template && chown -R coder:coder /template
RUN usermod --shell /bin/zsh coder 
USER coder
COPY home/* /home/coder/
RUN curl -L git.io/antigen > /home/coder/antigen.zsh && \
    /bin/zsh -c 'source /home/coder/.zshrc'
RUN rsync -ar /home/coder /template
RUN rm -rf /home/coder/*