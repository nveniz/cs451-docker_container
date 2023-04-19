# UCY-CS451 Docker Container

## Table of Contents
- [Info](#Info)
- [Prerequisite](#Prerequisites)
- [Installation](#Installation)
- [Running](#Running)

### Info

This is container replacement for the VM provided in the class, compared to the VM this container:
- Has faster access time (every time you need to access) but possibly takes more time to create.
- Requires less disk space (5 GB).
- A shared directory is mounted from the host to the container's filesystem, since containers are stateless by nature.

The Dockerfile has comments describing what does each command does and why and can be easilly modified or changed if the download links of the class change (Intel PIN tool link for example)

The container contains the following programs/tools/packages:
- libbfd
- libelf
- capstone
- Intel PIN tool
- LLVM
- Other utilities (vim, git, gcc, gdb, wget, make)

### Prerequisites 

- Docker engine installed, [info here](https://docs.docker.com/engine/install/)
- 5 GB available storage
- Internet connection (for downloading remote repositories and files)

### Installation

The container need to be built in order to be used, the building process might take from 15 to 30 minutes but it only needs to be built once (except if you change the Dockerfile)

**To build the container:**
```bash
cd cs451-docker_container/

docker build . --build-arg username=$(id -un) --build-arg uid=$(id -u)
```


### Running

To run the container you must change the [DIRECTORY TO MAP] the directory you want to share with the container and use the following command:

```bash
docker run -it -v [DIRECTORY TO MAP]:/home/$(id -un)/shared --hostname=epl451 epl451:latest
```

You can create an alias by adding this to .bashrc:
```bash
alias epl451='docker run -it -v [DIRECTORY TO MAP]:/home/$(id -un)/shared --hostname=epl451 epl451:latest'
```


