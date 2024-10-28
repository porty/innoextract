FROM debian:bookworm-slim AS builder

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        cmake \
        git \
        libboost-date-time1.81-dev \
        libboost-filesystem1.81-dev \
        libboost-iostreams1.81-dev \
        libboost-program-options1.81-dev \
        libboost-system1.81-dev \
        libbz2-dev \
        liblzma-dev \
        libzstd-dev \
        python3 \
        zlib1g-dev

ADD . /src/innoextract

RUN cd /src/innoextract && \
    mkdir build && \
    cd build && \
    cmake -DUSE_STATIC_LIBS=1 .. && \
    make

FROM debian:bookworm-slim

COPY --from=builder /src/innoextract/build/innoextract /usr/local/bin/innoextract

ENTRYPOINT ["/usr/local/bin/innoextract"]
