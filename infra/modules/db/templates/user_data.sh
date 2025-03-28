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
        apt-get -qq install $i -y 
    done
}

function install_aws_cli(){
    info "Download AWS CLI"
    curl $AWS_CLI_LINK -o "awscliv2.zip"
    info "Unzip AWS CLI file"
    unzip -qq awscliv2.zip 
    info "Run AWS CLI file"
    ./aws/install --bin-dir /usr/bin --install-dir /usr/bin/aws-cli --update
    info "Clean up AWS instalation files"
    rm -rf aws*
}

function attach_ebs(){
    info "Attaching EBS volume"
    TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` 
    INSTANCE_ID=`curl -H "X-aws-ec2-metadata-token: $TOKEN"  http://169.254.169.254/latest/meta-data/instance-id` 
    aws ec2 attach-volume --volume-id ${ebs_volume_id} --instance-id  $${INSTANCE_ID} --device /dev/sdf
}

function createfs(){
    if ! file -s /dev/xvdf | grep  -q "ext4";then
        info "Creating fs"
        mkfs -t ext4 /dev/xvdf
    else 
        info "Fs is created"
    fi    
}

function install_mysql(){
    info "install mysql"
    apt-get -qq install mysql-server-8.0  -y 
}


function mount_ebs(){
    info "create dir for  mysql"
    mkdir -p /var/lib/mysql
    info "mount disk"
    mount /dev/xvdf /var/lib/mysql
    chown mysql:mysql /var/lib/mysql
    chmod 750 /var/lib/mysql
    UUID=$(blkid -s UUID -o value /dev/xvdf)
    if ! grep -qs "$UUID" /etc/fstab; then
        echo "UUID=$UUID /var/lib/mysql ext4 defaults,nofail 0 2" | tee -a /etc/fstab
        info "fstab updated with new entry."
    else
        info "fstab already contains an entry for this volume."
    fi
    mount -a
}

 function start_enable_mysql(){
    info "enable service mysql"
    systemctl enable mysql
    systemctl start mysql
}

function main(){
    install_pre_requisites
    attach_ebs
    install_aws_cli
    createfs
    mount_ebs
    install_mysql
    start_enable_mysql
}

main
