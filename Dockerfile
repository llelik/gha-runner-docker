FROM quay.io/centos/centos:stream9

ARG RUNNER_VERSION="2.232.0"

# Prevents installdependencies.sh from prompting the user and blocking the image creation
# ARG DEBIAN_FRONTEND=noninteractive

RUN dnf update -y && adduser -m -d /home/docker docker
RUN dnf install -y --skip-broken curl jq python3 python3-pip git make telnet procps

# import EPEL rpm and installing EPEL repo
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Extras-SHA512
RUN dnf config-manager --set-enabled crb
RUN dnf upgrade --refresh

RUN dnf install -y python3.12 python3.12-pip
COPY requirements.txt /home/docker/requirements.txt
COPY requirements.yml /home/docker/requirements.yml


RUN pip3.12 install -r /home/docker/requirements.txt
RUN /usr/local/bin/ansible-galaxy install -r /home/docker/requirements.yml

RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L "https://github.com/actions/runner/releases/download/v2.323.0/actions-runner-linux-x64-2.323.0.tar.gz"  \
    && tar -xzf ./actions-runner-linux-x64-2.323.0.tar.gz

RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh
COPY start.sh start.sh

# make the script executable
RUN chmod +x start.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

ENTRYPOINT ["./start.sh"]

