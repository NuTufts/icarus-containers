FROM sl:7

MAINTAINER tmw@fnal.gov

## Based on a recipe from: https://github.com/lyon-fnal/singularity-def

# Runs within container
RUN mkdir -p /cvmfs /Users /exp /pnfs /grid

# We do lots of yum clean so we can make the container small
RUN  yum -y update && \
     yum clean all && \
     yum -y install epel-release redhat-lsb-core perl expat-devel glibc-devel gdb time git && \
     yum clean all && \
     yum -y install freetype-devel libXpm-devel libXmu-devel mesa-libGL-devel mesa-libGLU-devel && \
     yum clean all && \
     yum -y install libjpeg libpng libtiff tar zip bzip2 patch openssl-devel wget sudo strace && \
     yum clean all

RUN git clone https://github.com/NuTufts/icarus-containers.git && \
    cp icarus-containers/slf7.repo /etc/yum.repos.d/slf.repo && \
    wget http://ftp.scientificlinux.org/linux/scientific/7.2/x86_64/os/RPM-GPG-KEY-sl && \
    wget http://ftp.scientificlinux.org/linux/scientific/7.2/x86_64/os/RPM-GPG-KEY-sl7 && \
    rpm --import RPM-GPG-KEY-sl && \
    rpm --import RPM-GPG-KEY-sl7 && \
    rm -f RPM-GPG-KEY-sl && \
    rm -f RPM-GPG-KEY-sl7 && \
    yum install -y --enablerepo=fermilab-primary fermilab-base_kerberos fermilab-util_kx509 cigetcert && \
    yum clean all & \
    cp icarus-containers/krb5.conf /etc/ & rm -rf icarus-containers



RUN yum install -y curl wget perl freetype libGLEW redhat-lsb-core \
    libSM.x86_64 libXmu.x86_64 libXpm.x86_64 openssl krb5-libs krb5-server krb5-workstation \
    libzstd-devel.x86_64 xxhash-devel.x86_64 && \
    yum clean all   