FROM hub.bccvl.org.au/centos/centos7-epel:2017-02-20

# configure pypi index to use
ARG PIP_INDEX_URL
ARG PIP_TRUSTED_HOST
# If set, pip will look for pre releases
ARG PIP_PRE

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

# TODO: maybe split all below out into a jenkins specific base build/test image

    xorg-x11-server-Xvfb \
    firefox \
    which \
    git \
    && yum clean all \
    && curl -SLs https://github.com/mozilla/geckodriver/releases/download/v0.14.0/geckodriver-v0.14.0-linux64.tar.gz | tar -zxvf - -C /usr/local/bin

RUN export PIP_INDEX_URL=${PIP_INDEX_URL} && \
    export PIP_TRUSTED_HOST=${PIP_TRUSTED_HOST} && \
    export PIP_NO_CACHE_DIR=False && \
    export PIP_PRE=${PIP_PRE} && \
    easy_install pip && \
    pip install --upgrade setuptools wheel virtualenv && \
    pip install guscmversion

ENV PATH /usr/pgsql-9.5/bin:$PATH
