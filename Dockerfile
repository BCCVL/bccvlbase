FROM hub.bccvl.org.au/centos/centos7-epel:2016-08-21

RUN yum install -y http://yum.postgresql.org/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm \
    && yum install -y \
    exempi-devel \
    freetype-devel \
    gcc \
    gcc-c++ \
    gettext \
    gdal-devel \
    gdal-python \
    lcms2-devel \
    libffi-devel \
    libjpeg-turbo-devel \
    libpng-devel \
    libtiff-devel \
    libwebp-devel \
    libxml2-devel \
    libxslt-devel \
    libzip-devel \
    mailcap \
    openjpeg-devel \
    openssl-devel \
    postgresql95-devel \
    python-devel \
    xorg-x11-server-Xvfb \
    firefox \
    which \
    git \
    && yum clean all

ENV PATH /usr/pgsql-9.5/bin:$PATH
