all:	build

build:	GlobalProtect_rpm-5.0.3.0-10.rpm
	docker build -t globalprotect .

kill:
	docker kill `docker ps -q --filter="ancestor=globalprotect"`

interact:
	docker run -it --rm --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro --tmpfs /tmp --tmpfs /run globalprotect

addshell:
	docker exec -it `docker ps -q --filter="ancestor=globalprotect"` /bin/bash -l

GlobalProtect_rpm-5.0.3.0-10.rpm:	PanGPLinux-5.0.3-c10.tgz

PanGPLinux-5.0.3-c10.tgz:
	wget https://software.dartmouth.edu/Linux/Connectivity/PanGPLinux-5.0.3-c10.tgz
	tar xzvf PanGPLinux-5.0.3-c10.tgz
	tar tvf PanGPLinux-5.0.3-c10.tgz  | grep -v GlobalProtect_rpm-5.0.3.0-10.rpm | awk '{ print $$9 }' | xargs rm || exit 0
