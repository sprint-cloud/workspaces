FROM ubuntu:noble
LABEL org.opencontainers.image.source https://github.com/sprint-cloud/workspaces
ARG HOME=/workspace
ARG USER=sprinter
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update && \
    apt-get install --yes --no-install-recommends --no-install-suggests \
        curl \
        rsync \
        bash \
        zsh \
        git \
        vim \
        nano \
        python3 \
        python3-pip \
        python3-venv \
        php-cli \
        nodejs \
        npm \
        unzip \
        golang \
        dotnet-sdk-8.0

# Install tools from Hub tools image
COPY --from=ghcr.io/sprint-cloud/tools:latest /downloads/bin/* /usr/local/bin/

# Install Docker Cli only from dind image
COPY --from=docker:dind-rootless /usr/local/bin/docker /usr/local/bin/

RUN useradd ${USER} -s /bin/zsh -d ${HOME} -m

RUN mkdir /template && chown -R ${USER}:${USER} /template

USER sprinter
WORKDIR ${HOME}
COPY --chown=${USER}:${USER} home/* .
RUN curl -L git.io/antigen > antigen.zsh && \
    /bin/zsh -c "source .zshrc"
RUN rsync -rtv /workspace/ /template/
#RUN rm -rf ${HOME}/*