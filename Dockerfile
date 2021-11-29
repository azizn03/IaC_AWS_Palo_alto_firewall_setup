FROM centos:7

RUN yum-config-manager --add-repo "https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo"

RUN yum install -y epel-release \
                       wget \
                       sudo \
                       openssh \
                       openssh-server \
                       openssh-clients \
                       yum-utils \
                       terraform

RUN yum install -y jq \
                   golang

RUN cd /var/tmp && \
    wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.35.13/terragrunt_linux_amd64 && \
    mv terragrunt_linux_amd64 terragrunt && chmod 770 terragrunt && mv ./terragrunt /bin/terragrunt


COPY . /terragrunt/

RUN cd /terragrunt && chmod 770 ./*.sh ./*.go && \
    cd terragrunt && terraform init

WORKDIR /terragrunt

