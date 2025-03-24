#!bin/bash
apt update
apt install docker.io -y 
systemctl start docker
systemctl enable docker 
docker pull ${app_image}
docker run  -p ${port_host}:${port_container} -d  ${app_image} 



#TODO: Create userdata
#TODO: Update packages, install docker, verify that you can pull from ECR, pull app:v1 or app:v2. Docker run ...