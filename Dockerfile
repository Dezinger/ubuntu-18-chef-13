FROM dezinger/ubuntu-18:latest

MAINTAINER dezinger@gmail.com

ENV SSH_KEYS_DIRECTORY /root/.ssh
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/chef/bin:/opt/chef/embedded/bin \
    APT_ARGS="-y --no-install-recommends --no-upgrade" \
    CHEF_REPO_PATH=/tmp/chef

ARG COOKBOOK_PATH="/var/cookbooks"
ARG CHEFDK_VER=2.3.4

COPY files/ /

# Install chef-client
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install $APT_ARGS \
    ca-certificates git ssh && \
    curl -L --progress-bar https://www.chef.io/chef/install.sh | bash -s -- -P chefdk -v ${CHEFDK_VER} && \
    chef gem install knife-openvpn -v 0.0.6 && \
    mkdir -p $COOKBOOK_PATH && \
# setup mode
    chmod +x /usr/local/bin/add-ssh-keys.sh && \    
# Clean and remove not required packages
    apt-get autoremove -y && \
    rm -rf /var/cache/apt/archives/*

VOLUME ["$SSH_KEYS_DIRECTORY", "$COOKBOOK_PATH"]

WORKDIR "$COOKBOOK_PATH"