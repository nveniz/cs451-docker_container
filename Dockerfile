# Total size 4.69GB

FROM ubuntu
ARG username
ARG uid
ENV pintool='https://www.cs.ucy.ac.cy/courses/EPL451/src/pin-3.6-97554-g31f0a167d-gcc-linux.tar.gz'
#
# Packages to install
#
RUN apt-get update && apt-get install -y \
	wget gcc gdb vim doas\
	binutils-dev\
	libelf-dev\
	libcapstone-dev\
	python3 build-essential make cmake\
	git 


# MANDATORY:	Creates a new user in the container with the same UID and name as the host.
# 		This is used so that when we mount a file system from the host the files
# 		and directories created in the docker container have the same uid as the host files
#
# 		Also adds a rule in the doas config (lightweight sudo alternative) so that 
# 		the user has root permissions

RUN 	useradd -mU -u ${uid} -s /bin/bash ${username} &&\
	echo "permit nopass ${username} as root" >> /etc/doas.conf &&\
	mkdir /home/${username}/shared/
	
#Change to user $USERNAME
USER ${username}
# Change directory to user's home dir
WORKDIR /home/${username}


# MANDATORY:	Installation of the Intel pin tool taken with wget from the link
# 		provided in the lectures (change the ENV variable at the start
# 		of the Dockerfile if the link changes in the future)
#

RUN 	wget ${pintool} &&\
	export pintoolfile=$(echo ${pintool} | awk -F '/' '{print $NF}') &&\
	tar -xzf $pintoolfile &&\
	doas ln -s /home/nv/$(echo $pintoolfile | sed 's/.tar.*//')/pin /usr/bin/pin &&\
	rm ${pintoolfile}

# MANDATORY:	Installs llvm using the llvm minimal size build and llvmorg-13.0.0 version
# 		
# 		For full build change cmake command (4th command below) to:
# 			cmake -S ../llvm -DLLVM_ENABLE_PROJECTS=clang -B build -G 'Unix Makefiles' &&\
# 		To get a list of available version use:
# 			git tag --list
# 		To change the version of llvm:
# 			git checkout <llvm version found in git tag --list>
# 		
RUN 	git clone https://github.com/llvm/llvm-project.git &&\
	cd /home/${username}/llvm-project/llvm/ &&\
	mkdir build &&\
	cmake -S ../llvm -DLLVM_ENABLE_PROJECTS=clang -DCMAKE_BUILD_TYPE=MinSizeRel -B build -G 'Unix Makefiles' &&\
	git checkout llvmorg-13.0.0 &&\
	echo "export PATH=$PATH:/home/${username}/llvm-project/llvm/build/bin" >> /home/${username}/.bashrc
	
# OPTIONAL:  	Added colored prompt and some aliases that I find usefull 
# 		(especially sudo = doas)
#
RUN 	echo "PS1='\[\033[1;31m\]\u@\h\[\033[1;33m\] \W\[\033[1;36m\] $\[\033[0;37m\] '\n" >> /home/${username}/.bashrc &&\
	echo "alias sudo='doas'" >> /home/${username}/.bashrc &&\
	echo "alias ls='ls -lrh --color=auto'" >> /home/${username}/.bashrc &&\
	echo "alias la='ls -lrah --color=auto'" >> /home/${username}/.bashrc &&\
	echo "alias grep='grep --color'" >> /home/${username}/.bashrc



#Change directory to /home/username
WORKDIR /home/${username}
