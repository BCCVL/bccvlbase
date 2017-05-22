FROM hub.bccvl.org.au/centos/centos7-epel:2017-05-22

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
    && curl -SLs https://github.com/mozilla/geckodriver/releases/download/v0.14.0/geckodriver-v0.14.0-linux64.tar.gz | tar -zxvf - -C /usr/local/bin \
    && curl https://bootstrap.pypa.io/get-pip.py | sudo python -

# Manually Install GDAL and newer version of numpy
# libarmadillo adds a a number of dependencies: arpack-devel, atlas-devel, blas-devel, lapack-devel, libquadmath-devel, gcc-fortran
RUN export PIP_INDEX_URL=${PIP_INDEX_URL} && \
    export PIP_TRUSTED_HOST=${PIP_TRUSTED_HOST} && \
    export PIP_NO_CACHE_DIR=False && \
    export PIP_PRE=${PIP_PRE} && \
    export GDAL_VERSION="2.2.0" && \
    pip install --no-cache-dir guscmversion numpy cryptography && \
    `# install build edpendencies:` && \
    yum install -y \
        make \
        qhull \
        hdf \
        crytpopp && \

    buildDeps='hdf5-devel \
               libcurl-devel \
               geos-devel \
               xerces-c-devel \
               expat-devel \
               jasper-devel \
               hdf-devel \
               libgta-devel \
               sqlite-devel \
               armadillo-devel \
               cryptopp-devel \
               cfitsio-devel \
               poppler-devel \
               netcdf-devel \
               libdap-devel \
               json-c-devel \
               qhull-devel \
    ' && \

    yum install -y $buildDeps && \

    cd /tmp && \
    curl http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz | tar -xz && \
    cd gdal-${GDAL_VERSION} && \
    ./configure --with-armadillo --with-poppler --with-epsilon --with-webp --with-cfitsio --with-liblzma=yes --with-dods-root=/usr && \
    make -j 4 && \
    make install && \
    cd .. && \

    `# make sure library paths are set up correctly` && \
    echo -e '/usr/local/lib\n/usr/local/lib64' > /etc/ld.so.conf.d/local.conf && \
    ldconfig && \
    rm -fr gdal-${GDAL_VERSION} && \
    pip install --no-cache-dir gdal==${GDAL_VERSION} && \
    yum remove -y $buildDeps && \
    yum clean all

ENV PATH /usr/pgsql-9.5/bin:$PATH
