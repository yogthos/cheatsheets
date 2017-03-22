build a container

    docker build -t <name> .

run the container

    docker run <name>

list running containers

    docker ps
    
list available containers

    docker ps -a
    
stop a running container

    docker kill <container id>
    
remove container

    docker rm <container id>

list volumes

    docker volume ls
    
remove a volume

    docker volume rm <volume name>

list available images

    docker images -a

remove image

    docker rmi -f <image Image>

run with docker-compose

    docker-compose up
   
### prod config

prevent docker from messing with iptables

```
mkdir /etc/systemd/system/docker.service.d
cat << EOF > /etc/systemd/system/docker.service.d/noiptables.conf
[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon -H fd:// --iptables=false
EOF
systemctl daemon-reload
```
