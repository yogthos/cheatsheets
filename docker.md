build a container

    docker build -t <name> .

run the container

    docker run <name>
    
run the container with a given name

    docker run --name <docker ps name> <name>

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

see list of stored images
    
    docker images
 
list available images

    docker images -a

remove image

    docker rmi -f <image Image>

run with docker-compose

    docker-compose up
   
### prod config

limit JVM memory allocation in a container

    docker run -d --name <docker ps name> -p 3000:3000 -m 800M -e JAVA_OPTIONS='-Xmx300m' <name>


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


### Cleanup Commands

Generally safe cleanup commands

delete orphaned and dangling volumes

Dangling volumes are volumes that are not being used by a container. Dangling images are images that are not referenced to by containers or other images.

    docker volume rm $(docker volume ls -qf dangling=true)
    
delete dangling and untagged images

    docker rmi $(docker images -q -f dangling=true)
    
delete exited containers, Note that this also deletes data containers you might have created.

    docker rm $(docker ps -aqf status=exited)

delete all images

    docker rmi $(docker images -q)

kill all running containers

    docker kill $(docker ps -q)

delete all containers

    docker rm $(docker ps -aq)
    
delete stopped containers, and volumes and networks that are not used by containers
note that this will also delete any data-only containers you might have created

    docker system prune -a
    

    
