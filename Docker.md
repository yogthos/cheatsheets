original source https://gitlab.com/insanitywholesale/docks-and-whales/-/blob/master/dockerstuff.md

# Docker

## Preamble

Docker is quite popular and has a lot of benefits if used appropriately.
This tutorial will hopefully help readers become more familiar with it.
You snooze, you lose so let's get into it.

## Prerequisites

- MUST:
	- Have Linux installed
	- Have docker installed
	- Internet connection to download images
	- Some Linux knowledge
- OPTIONAL:
	- Dockerhub account to push images to

## Concepts and Architecture

### Images and Containers

What are images, what are containers and how are they different?
Images are a snapshot of a system while containers are a running instance of an image.
For example, the nginx docker image has all the necessary bits installed to run nginx.
When we start that image, there is now an nginx container running.

To see it action, we can run  
`docker image ls`  
to see all docker images on our system.
To download a new one, also referred to as pulling an image, we can run
`docker pull nginx`  
or if a specific version is required,  
`docker pull nginx:1.17.10`

Images are also immutable meaning they don't keep any changes you make to them.
If we were to go into an ubuntu container, run `apt update && apt -y full-upgrade` then restart the container, the updates would be lost.
To demonstrate it, we can run  
`docker run --rm -i -t ubuntu`  
then when we see the shell prompt change, run  
`touch testfile && ls`  
followed up by `exit`.
Running  
`docker run --rm -i -t ubuntu`  
again followed up by `ls` shows that the file named `testfile` does not exist there anymore.
The interactive shell won't really come up again until we get to debugging. Unlike virtual machines, containers are not meant to be used interactively.

- Some notes so far:
	- The `--rm` removes the container when the docker command exits (not necessary here but good for testing so we don't fill up our system with unneeded containers)
	- The `-i -t` gives us an interactive terminal to execute commands in this case (this is not available on every image, for example postgres and nginx show logs
		- In the case of nginx and postgres, even without (`-it`) they capture the terminal with logging so we use `-d` to run them in detached mode
		- The `--name` option gives a (hopefully) human-readable name to the container, especially useful when used with `-d`
	- docker pulls the image we specified (in this case the ubuntu one) if it's not on the system yet when we use `docker run`
	- There is a special image named `scratch` if you want to build things from the lowest level allowable

Containers can be started and stopped but it's more complex than that as is evident from our experimentation and notes this far.
We'll return to using nginx now since most images are going to be centered around the included application.
Using  
`docker run -d --name ngx-alp nginx:alpine`  
we start an alpine-based nginx container running in detached mode.  
After checking the output of  
`docker container ls`  
specifically the NAMES column, we can see that it did indeed start and was assigned the desired name.
A quick  
`docker stop ngx-alp`  
will make it disappear from `docker container ls` but not from everywhere.
If we try to run  
`docker run -d --name ngx-alp nginx:alpine`  
then docker will return an error since there is a container with that name but in stopped state.
We can confirm that using  
` docker container ls --all`  
and then choose to start it again using  
`docker start ngx-alp`  
or remove it using  
`docker rm ngx-alp`  
Remember, we didn't use `--rm` so the container did not get automatically removed after we stopped it.
You might have figured it out already but the containers are given random unique names as well as a unique ID, both of which can be used to address them when we want to stop, start or remove them.

### Tags

What is the `:1.17.10` I added to the pull command in the previous section?
Clearly it's a version number but more importantly it's an image tag.
Tags allow us to specify the flavour or edition of the image that we want to use.
For example, to pull an alpine-based nginx image, we can run
`docker pull nginx:1.17.10`  
or
`docker pull nginx:1.17.10-alpine`  
to be more explicit.
If none is specified, the `:latest` tag is used so it is the default tag, keep this in mind.
Images can have multiple tags so `nginx:latest` and `nginx:1.17.10`(at the time of writing) will pull the same image but that won't be true forever.
Explicitly specifying tags is useful to avoid the "works on my machine" type of issues when working with docker.

### Ports

Many applications communicate over ports so how do we deal with that communication and move further along with our nginx example.
The port required for a basic "this works" page to load from nginx is 80. However, if you were to run `docker run nginx` and try to
`curl http://localhost:80`  
it would not work.
For an analogy with more conventional setups, think of it as port forwarding being required.
Port 80 inside the container needs to be mapped to a port on the system in order to become accessible which is controlled by the `-p` option.
I will use distinct ports to make the example more clear so here we go, run
`docker run -d -p --name ngx 3000:80 nginx`  
(which will use ``nginx:latest`) and then run  
`curl http://localhost:3000`  
This should return a bit of HTML and internal CSS to indicate that the default nginx page is reachable.
We see that port 3000 outside of the container is mapped to port 80 inside of the container.
To make sure, we can try
`docker run -d -p --name ngx2 4000:80 nginx`  
and then
`curl http://localhost:4000`  
to see that it works and try
`docker run -d -p --name ngx2 3000:80 nginx`  
to check that it won't allow us to start it since port 3000 is already used by another container.

### Networking

From the get-go, docker has a bridge network that all containers connect to by default but don't have the perks of name resolution like user-defined bridge networks do.
What is a bridge network though and are there other types of networks?  
We'll go through them one by one and explain what they're useful for.


#### Bridge
First, bridge networks. By utilizing NAT, in a similar way that a router does, they are able to have containers communicate over them (or not for security reasons). Each container connected to a bridge network gets its own IP address and there are iptables rules added to block or allow traffic between networks and containers (or ports as we saw in the previous section). While the default bridge network that docker creates is mostly fine for testing and messing around, user-defined networks have a few advantages that make them suitable for more proper use such as:  
	- DNS resolution to make containers able to communicate using names and not IPs which could change
	- Isolation since a container has to be explicitly added to them
	- Adding and removing a container can be done on the fly (without starting and stopping)
	- Configurability such as using a larger MTU and in general tweaking them for the use case
	- Sharing environment variables
	- Have effectively all ports exposed between them
	- Not having to use the deprecated `--link` flag  
So it's safe to say that using user-defined ones is worth it. How to go about it then?
Time to find out.  
In order to create a network we just have to run
`docker network create bridge-net`
or  
`docker network create --driver bridge bridge-net`  
and to delete it we use  
`docker network rm bridge-net`  
but how do we use it?  
For this, we'll need two containers. Let's pick alpine since it includes the `ping` command. The flag to specify what network to attach the container to is `--network` so the full commands are as follows
```
docker run -dit --name alpine1 --network bridge-net alpine:latest
docker run -dit --name alpine2 --network bridge-net alpine:latest
```
The above will run two containers in detached mode and enable the interactive terminal. We can connect to that terminal,  
`docker attach alpine1`  
after which we get a prompt inside it.
Let's test out that name resolution by pinging it 3 times  
`ping -c 3 alpine2`  
which should work wonderfully. This means our containers can talk to eachother using their names while also having randomly assigned addresses from docker's subnet.
In case we forget the network's details, it is possible to use
`docker network list`  
to find the network's name followed by
`docker inspect bridge-net`
and get the network's details in JSON format.

#### Macvlan

When integration with the network that the host is connected to is desired, we can use macvlan. Despite VLAN being a part of the name, using them is an option rather than a requirement. Let's start with the possibly more familiar mode.  

##### Bridge mode

In this mode, the network is bridged to a physical interface on the host and it integrates with the underlying network.

To see it in action, (I'll assume a fairly standard home network scheme) we can look at
```
$ ip r
default via 192.168.1.1 dev eth0 metric 2
172.16.0.0/16 dev virbr0 proto kernel scope link src 172.16.0.1 linkdown
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 linkdown
172.18.0.0/16 dev br-b0ed5d210b62 proto kernel scope link src 172.18.0.1
192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.2
```
to find our interface's name, `eth0` in this case and then create the network
`docker network create -d macvlan --subnet=192.168.1.0/24 --gateway=192.168.1.1 -o parent=eth0 macvlan-net`  
Connecting containers to it is done the same way we previously used. For example,
`docker run -dit --name alpine-on-macvlan --network macvlan-net alpine:latest`

##### 802.1q mode

I'm not going to go too in-depth about this mode since the amount of people with level 2 or level 3 managed switches is limited but it deserves at least a brief mention. If you've worked with VLANS on linux, you know that new interfaces are created, usually in the format the name of the physical parent followed by a dot `.` and then the VLAN number. To create a network linked to VLAN 31 on the `eth0` interface, we use the same command as before but with a VLAN interface instead like so
`docker network create -d macvlan --subnet=192.168.1.0/24 --gateway=192.168.1.1 -o parent=eth0.31 macvlan31-net`

[//]: # (maybe include host networking too)

### Storage

So far we have not looked into how we work with storing data.  
In the beginning it was stated and demonstrated that any changes made do not persist.
How do people use containers to run file servers and databases then?
The answer is bind mounts and volumes.
Bind mounts map a specified directory on the host to one inside the container.
Volumes on the other hand are managed through docker and are a bit more isolated from the host's functionality.
Every time we ran a container, an anonymous volume was created.
Instead, we could have created a named volume using
`docker volume create ngx-vol`  
`docker run --name ngx-with-vol -p 3000:80 --mount source=ngx-vol,target=/usr/share/nginx/html nginx`  
The volumes are under `/var/lib/docker/volumes` in case you were wondering.
Volumes can be shared between two containers and be mounted read-only but we won't be going into that right now.
With bind mounts, it looks a bit different since we need to pick a directory on the host.
If the directory doesn't exist it will be created for us by docker.
Let's try it using  
`docker run --name ngx-with-bind-mount -p 3000:80 -v /tmp/ngx:/usr/share/nginx/html nginx`  
which will mount /tmp/ngx from the host to /usr/share/nginx/html in the container.
This gives us an error if we try to
`curl http://localhost:3000`  
because the bind mounted host directory doesn't get filled with the contents of the container's target directory.
There is an alternative syntax for this using the `--mount` option which is as follows  
`docker run -d --rm --name ngx-w-alt-bind-mount -p 3000:80 --mount type=bind,source=/tmp/nginx,target=/usr/share/nginx/html nginx`  
and will not create the directory on the host if it doesn't exist.
That's the main gist about storage when it comes to docker. The thing most often found in the wild is bind mounts with the `-v` syntax and named volumes.

#### Installing

There are multiple ways to install docker-compose. From your distributions repositories, from third-party repositories, from the realease binary, from source, from pip but by far my favorite is as a docker container. Take a look [over here](https://docs.docker.com/compose/install/#install-as-a-container) if you're interested, otherwise choose the way you prefer to get it installed to your system. After that, we're ready to write some YAML.

#### Usage

Taking advantage of docker-compose is mainly by writing a file that describes how you want your services set up. Just make sure to pay attention to indentation because YAML is very picky about that (be prepared to give the spacebar a proper workout). What images will we work with?

## Building Images

All the talk about using docker is good but with kubernetes dominating the industry as far as orchestration, docker finds its home as a way to build images and as a container runtime.
How do you build an image then? It all starts with a Dockerfile.

### Dockerfile

Similar to a Makefile but used for docker containers instead, the Dockerfile describes how to build your image. The first statement is `FROM` which specifies which base image to use. Other things you need is at least a little bit of familiarity with the tooling used by the project so you can discern what errors mean. Don't be intimidated by that though, we'll be going through it step by step. 

#### Single-stage example build

For our starting example, we'll use nginx and the following simple index.html:  
```
<!DOCTYPE html>
<html>
	<head>
		<title>First Docker Image</title>
	</head>
	<body>
		<h1>It exists and it works.</h1>
	</body>
</html>
```
So we create a new file named Dockerfile and put the following in it  
```  
FROM nginx:1.17.10-alpine
```
We could bind-mount our files but shipping them inside the image is we'd need if this was a website we were packing so let's do it. I'm making the assumption that index.html is in the current working directory
```  
FROM nginx:1.17.10-alpine
COPY ./index.html /usr/share/nginx/html/
```
Without a port exposed, it won't be accessible even if we bind ports to it so let's do that next
```  
FROM nginx:1.17.10-alpine
COPY ./index.html /usr/share/nginx/html/
EXPOSE 80
```
The final thing we should put in there is what command will be ran when the container starts. Running as a daemon is not desired since it will be in the foreground so we turn that off.
```
FROM nginx:1.17.10-alpine
COPY ./index.html /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```
Now for building the image we can run a simple  
`docker build -f Dockerfile .`  
to do the job. The `-f` specifies what file to use to build the image and `.` signifies the current working directory as the build context.
We don't necessarily have to specify the file every time, if it is named `Dockerfile` it will be used automatically.  

That's not fancy enough though. We should probably give it a name and a tag (otherwise it will be tagged with `:latest`)
`docker build -t first-site:0.0.1 .`  
Running the old faithful  
`docker image ls`  
should reflect that our custom image was built and tagged appropriately.  

Congratulations, you just built your first docker image. But things are never this simple, right? We're not always going to be working with websites let alone ones that have less than 10 lines of HTML. Let's try something a bit more realistic. What about...a microservice written in golang exposing an api centered around a list of coffees?

#### Multi-stage golang example build

I am going to be using [this](https://github.com/insanitywholesale/microsrv) for demonstration. Ignore the included dockerfile, our main focus now is to understand the steps required to make images. After cloning the project and entering its directory, delete the included Dockerfile (it's not as correct as the one we're going to make anyway) and make an empty one. Just the same as before, we're going to start with a `FROM ` statement.
```
FROM golang:1.14.2
```
Picking version 1.14.2 since that is the latest at the time of writing and the code has been tested to work with it.
Next, we're going to go into the `$GOPATH` directory, in a subdirectory named `src` and then in a subdirectory with our project's name. Note that we use `/go/src/microsrv` since `$GOPATH` is resolved to `/go` in this image.
```
FROM golang:1.14.2
WORKDIR /go/src/microsrv
```
We could have used the `RUN` statement and done `RUN cd $GOPATH/src/microsrv` but the `WORKDIR` command works at the Dockerfile level meaning that all subsequent commands will use it and it also creates the directory in case it doesn't exist already.
After that, it's time to copy over the project files using `COPY`
```
FROM golang:1.14.2
WORKDIR /go/src/microsrv
COPY . .
```
this copies the contents of our current working directory outside of the container (project's root) into the current working directory inside the container ($GOPATH/src/microsrv)
Following that, we run the command to download all the required dependencies and source code but not build or install the project (that's due to using `-d`). Here the `RUN`statement is used which executes the command after it inside the container.
```
FROM golang:1.14.2
WORKDIR /go/src/microsrv
COPY . .
RUN go get -d -v ./...
```
Of course in the end we want to build and install the project so let's do that
```
FROM golang:1.14.2
WORKDIR /go/src/microsrv
COPY . .
RUN go get -d -v ./...
RUN go install -v ./...
```
Right after that is exposing the port, 9090 in this case
```
FROM golang:1.14.2
WORKDIR /go/src/microsrv
COPY . .
RUN go get -d -v ./...
RUN go install -v ./...
EXPOSE 9090
```
The last piece missing is the command to be executed
```
FROM golang:1.14.2
WORKDIR /go/src/microsrv
COPY . .
RUN go get -d -v ./...
RUN go install -v ./...
EXPOSE 9090
CMD ["microsrv"]
```
On to building the image now  
`docker build -t coffee-api:0.0.1 .`
and then running and testing it
`docker run --rm -d --name coffee-api -p 9090:9090 coffee-api:0.0.1`
`curl http://localhost:9090/products`  
which should return a JSON-formatted object of all the coffees and their public-facing details.
This is all fine and dandy but if we check `docker image ls` we see that the resulting image is about 1GB in size which just won't fly. We have to optimize but how? One way is to think of what's needed in compile-time compared to run-time. The entire language is not required after the project has been built and not much if any operating-system level tools are required other than for debugging.  

To achive this separation we can use multi-stage builds.
The first step is taking out runtime-specific things out of the build stage.
What port gets exposed and what command is ran when the container starts is not in the build stage's scope so let's remove those.
```
FROM golang:1.14.2
WORKDIR /go/src/microsrv
COPY . .
RUN go get -d -v ./...
RUN go install -v ./...
```
Time to build the second stage. First we'll use an alias for the first stage in order to be able to copy stuff from it.  
```
FROM golang:1.14.2 as build
WORKDIR /go/src/microsrv
COPY . .
RUN go get -d -v ./...
RUN go install -v ./...
```
With that done, let's define the second stage inside the same file. We'll use busybox, a very small image that has just enough to be usable for our case. Since the default image uses glibc as its C library, we'll specify that tag since busybox doesn't use it by default.
```
FROM golang:1.14.2 as build
WORKDIR /go/src/microsrv
COPY . .
RUN go get -d -v ./...
RUN go install -v ./...

FROM busybox:glibc
```
Here is where the alias comes in handy when copying the resulting binary (located at $GOPATH/bin/microsrv) from the first stage
```
FROM golang:1.14.2 as build
WORKDIR /go/src/microsrv
COPY . .
RUN go get -d -v ./...
RUN go install -v ./...

FROM busybox:glibc
COPY --from=build /go/bin/microsrv /
```
And finally we add the two lines that were removed  
```
FROM golang:1.14.2 as build
WORKDIR /go/src/microsrv
COPY . .
RUN go get -d -v ./...
RUN go install -v ./...

FROM busybox:glibc
COPY --from=build /go/bin/microsrv /
EXPOSE 9090
CMD ["/microsrv"]
```
All that's left now is to build (I incremented the version number so the image doesn't steal the previous one's tagged name but normally you want the docker image version to match the version of the application)
`docker build -t coffee-api:0.0.2 .`
then run and test  
`docker run --rm -d --name coffee-api -p 9090:9090 coffee-api:0.0.1`
`curl http://localhost:9090/products`  

If everything went according to plan, a JSON object with the coffees was returned to you and you've built your first multi-stage docker image (which you should remember to stop using `docker stop coffee-api`). We're not done yet though, maybe it's time we throw our old pal nginx back into the mix and move from the backend to the frontend.

#### Multi-stage reactjs example build

Now that our backend is all packed up, time to see how we'd go about doing the same thing with the frontend. This time we have to interact with nodejs during the build but it's not required for runtime. I think you get an idea of what's to come so let's not hesitate.

The project I'll be using for this demonstration is [this](https://gitlab.com/insanitywholesale/reactionary), just a simple one-page counter application. Same as the previous example, we'll clone it, change into its directory and delete the included Dockerfile since we'll be remaking it from scratch.
As I mentioned, it's good to know the project's tooling, in this case we need node and npm for building the application but not for running it. We'll start with a `FROM` statement to grab the node image but pre-emptively optimize by going with the alpine flavour. The size comparison between the regular version is as follows and should explain why this is a better choice.  
```
$ docker images | grep node
node                             alpine              0854fcfc1637        2 days ago          117MB
node                             latest              a511eb5c14ec        2 days ago          941MB
```
Coming in at over 8 times the size of the alpine one, the main image is massive and doesn't include anything we need and won't get otherwise.
Starting with our Dockerfile then, we pick the latest (at the time of writing) node image based on the latest alpine version and alias it to `build` since it will be our build stage
```
FROM node:14.1.0-alpine3.11 as build
```
We then change our current working directory to `/app` and move all of our project's freshly cloned files in there
```
FROM node:14.1.0-alpine3.11 as build
WORKDIR /app
COPY . .
```
Now on to getting everything installed and ready for the build. Since it's a reactjs website and the scripts that will be run (as defined in package.json) are from the `react-scripts` package (which needs to be installed globally) we will opt for installing that first before the usual `npm install`. Here is the Dockerfile up until now  
```
FROM node:14.1.0-alpine3.11 as build
WORKDIR /app
COPY . .
RUN npm install --global react-scripts
RUN npm install
```
To finish up the build stage one last command is required in order to generate the files that nginx will serve  
```
FROM node:14.1.0-alpine3.11 as build
WORKDIR /app
COPY . .
RUN npm install --global react-scripts
RUN npm install
RUN npm run build
```
There we go then. The resulting files will be inside the container in the `/app/build` directory. No instructions for exposing any ports or the starting command we specified since that's for the runtime stage. Speaking of which, you might have already guessed what the rest of the Dockerfile will look like. Start with an nginx alpine image, copy over only the necessary files to it from the build stage, open up port 80 and start nginx in foreground mode. Here is the final result
```
FROM node:14.1.0-alpine3.11 as build
WORKDIR /app
COPY . .
RUN npm install --global react-scripts
RUN npm install
RUN npm run build

FROM nginx:1.17.10-alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```
After we're done with that, we should actually build the image and give it a descriptive tag  
`docker build -t reactjs-counters:0.0.1 .`  
followed up by starting it in order to test
`docker run --rm -d --name reactjs-counters -p 80:80 reactjs-counters:0.0.1`
and then visit  
`http://localhost`  
in your browser of choice to see if it works.

## Publishing Images

We've made our image and sharing is caring so how do we make it available to the world and where are images stored? The go-to place for getting images is dockerhub, a public docker registry. Docker registries are where images are stored and distributed from. You can also run your own if you wish but that's for another time. Right now, we have two images built and ready to be shipped. Well...almost. We could certainly upload them as they are and then try to pull them but we'd find that we need to specify a tag. That happens because they're not tagged as `:latest` which is the default tag. One step at a time though.

### DockerHub

First, you should make an account if you don't have one already by going over on the [dockerhub website](https://hub.docker.com/signup) and signing up. Next up, run `docker login` in a terminal to, you guessed it, log in. This will allow you to push images to your account. I already got mine so we're ready to start.  

### Tagging
Since we just finished making our reactjs-based image, let's use it here too. Previously we only tagged it as `reactjs-counters:0.0.1` but we need something more now. The format of the image name should be `username/image:tag`. There at least 2 ways to go about this. Either rebuild the image and tag it differently or tag the existing one. I'll go over both of them.

First, let's look at the "I wish I'd known sooner" method. As we know, images have a unique identifier. This is under the ``IMAGE ID` column in `docker image ls` output. A single image can be tagged with different names. So here is the way we'd build it with multiple tags, one of them being the properly versioned one and the other one being latest (don't forget to substitute `username` with your actual username):  
`docker build -t username/reactjs-counters:0.0.1 -t username/reactjs-counters:latest .`  
And there we have it. Simple enough, ain't it? But how about tagging an already existing image? Someone might not fancy rebuilding theirs.

That's what the `docker tag` command is for. All we have to do is find the image ID from the output of `docker image ls` and then tag it twice. Here we go then (assuming this is the image ID `7755c1923b8a`):
```
docker tag 7755c1923b8a username/reactjs-counters:0.0.1
docker tag 7755c1923b8a username/reactjs-counters:latest
```


### Pushing

All that's left is to `docker push` the image of our choice and make it available so other people can `docker pull` it.  

```
docker push username/reactjs-counters:0.0.1
docker push username/reactjs-counters:latest
```
And that's it!  
We have successfully taken an application, written a Dockerfile for it, built an image for it and published it to DockerHub!

## Outro

Hopefully you've learned something useful about docker after reading this, I had fun writing it and looking into things that had faded from my memory. Docker is an interesting technology that can be leveraged in many ways to improve development and production workflows everywhere from a single board computer to a fleet of servers in a datacenter. Let me know what you thought about it and I hope you have a good rest of your day.

