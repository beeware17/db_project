#!bin/bash

PREREQUISITES=(
    "docker.io"
    "curl"
)

function main (){
    info "Starting user data"
    install_pre_requisites
    configure_docker
    start_app
    info "Ended user data"
}

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

function configure_docker(){
    info "Start docker"
    systemctl start docker
    info "Enable docker"
    systemctl enable docker
}

function start_app() {
    info "Pulling image"
    docker pull ${app_image}
    info "Running container"
    docker run  -p ${port_host}:${port_container} -d  ${app_image} 
}

main