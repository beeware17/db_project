#!/bin/bash

PREREQUISITES=(
    "curl"
    "python3-pip"
    "unzip"
)

AWS_CLI_LINK="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"

function info(){
    echo
    echo "### INFO: $1"
    echo
}

function install_pre_requisites(){
    info "Update packages"
    apt-get update -qq
    for i in "$${PREREQUISITES[*]}"; do
        info "Install $i"
        apt-get install $i -y 
    done
}

function install_aws_cli(){
    info "Download AWS CLI"
    curl $AWS_CLI_LINK -o "awscliv2.zip"
    info "Unzip AWS CLI file"
    unzip awscliv2.zip
    info "Run AWS CLI file"
    ./aws/install --bin-dir /usr/bin --install-dir /usr/bin/aws-cli --update
    info "Clean up AWS instalation files"
    rm -rf aws*
}

function attach_ebs(){
    info "Attaching EBS volume"
    aws ec2 attach-volume --volume-id ${ebs_volume_id} --instance-id ${instance_id} --device /dev/sdf
}

function main(){
    install_pre_requisites
    install_aws_cli
    attach_ebs
}
main
