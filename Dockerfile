FROM centos:centos7

ARG AWSCLI_VERSION
ARG ANSIBLE_VERSION
ARG TERRAFORM_VERSION
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile"

# Install required libraries
RUN yum update -y \
  && yum install gcc \
    bzip2-devel \
    openssl-devel \
    make \
    unzip \
    python3 \
    -y

WORKDIR /tmp

# Download Terraform and add it into bin PATH
RUN mkdir -p /tmp/build \
  && curl -sfLo /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && unzip /tmp/terraform.zip -d /usr/local/bin

WORKDIR /root

# Force Python 3 as default Python
RUN ln -sf /usr/bin/python3 /usr/bin/python

# Install Ansible / AWS CLI
RUN pip3 install --upgrade pip cffi
RUN pip3 install wheel
RUN pip3 install "awscli==${AWSCLI_VERSION}" 
RUN pip3 install "ansible==${ANSIBLE_VERSION}"

RUN chmod a+x /usr/local/bin/*

ENTRYPOINT ["/bin/bash","-c"]