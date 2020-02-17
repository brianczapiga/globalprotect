FROM centos:7.7.1908

WORKDIR /root

ENV container docker

RUN yum install -y which initscripts vim gcc g++ make openssh openssh-clients traceroute net-tools iputils nmap-ncat nmap lsof strace less which iproute 

# install globalprotect
# https://software.dartmouth.edu/Linux/Connectivity/PanGPLinux-5.0.3-c10.tgz
COPY GlobalProtect_rpm-5.0.3.0-10.rpm /root
RUN yum install -y /root/GlobalProtect_rpm-5.0.3.0-10.rpm && rm -f /root/GlobalProtect_rpm-5.0.3.0-10.rpm

# remove password for root within the container
RUN sed -i 's/^root:locked/root:/' /etc/shadow

# autologin to root on console
RUN sed -i '/^ExecStart/s/--noclear/--autologin root --noclear/' /lib/systemd/system/console-getty.service

# disable services that aren't going to start anyways
RUN systemctl disable network

# export paths and aliases
RUN echo 'export PATH=$PATH:/opt/paloaltonetworks/globalprotect' >> /root/.bash_profile
RUN echo 'alias connect="/opt/paloaltonetworks/globalprotect/globalprotect connect -p put_your_gateway_hostname_here"' >> /root/.bash_profile
RUN echo 'alias disconnect="/opt/paloaltonetworks/globalprotect/globalprotect disconnect"' >> /root/.bash_profile
RUN echo 'alias status="/opt/paloaltonetworks/globalprotect/globalprotect show --status"' >> /root/.bash_profile
RUN echo 'alias exit="halt"' >> /root/.bash_profile
RUN echo 'alias quit="halt"' >> /root/.bash_profile

# start system
CMD [ "/sbin/init" ]
