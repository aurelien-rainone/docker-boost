FROM alpine:3.6
LABEL Description="Boost C++ libraries on Alpine Linux"

ARG BOOST_VERSION=1.66.0
ARG BOOST_DIR=boost_1_66_0
ENV BOOST_VERSION ${BOOST_VERSION}

RUN mkdir -p ${BOOST_DIR} \
    && apk --no-cache add --virtual .build-dependencies \
    build-base \
    linux-headers \
    curl \
    tar \
    && curl -sL --retry 3 "https://dl.bintray.com/boostorg/release/${BOOST_VERSION}/source/${BOOST_DIR}.tar.gz" | \
    tar -xz --strip 1 -C ${BOOST_DIR}/ \
    && cd ${BOOST_DIR} \
    && ./bootstrap.sh \
    && ./b2 --without-python --prefix=/usr -j 4 link=shared runtime-link=shared install \
    && cd .. && rm -rf ${BOOST_DIR} \
    && apk del .build-dependencies \
    && rm -rf /var/cache/*

CMD ["sh"]
