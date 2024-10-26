FROM codercom/enterprise-base:ubuntu
LABEL org.opencontainers.image.source https://github.com/sprint-cloud/workspaces

USER root
# Install packages
RUN apt update && sudo apt install -y \
    zsh \
    nodejs \
    npm \
    php-cli\
    unzip

COPY --from=composer/composer /usr/bin/composer /usr/local/bin/composer
COPY --from=bitnami/kubectl /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/

RUN mkdir /template && chown -R coder:coder /template
RUN usermod --shell /bin/zsh coder 
USER coder
COPY home/* /home/coder/
RUN curl -L git.io/antigen > /home/coder/antigen.zsh
RUN curl -sSL https://werf.io/install.sh | bash -s -- --ci
RUN rsync -ar /home/coder /template
RUN rm -rf /home/coder/*