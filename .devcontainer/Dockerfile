FROM debian:stretch

RUN apt-get update && apt-get -y install git curl unzip

RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /home/codespace
WORKDIR /home/codespace

ENV PUB_CACHE=/home/codespace/.pub_cache
ENV PATH="/home/codespace/flutter/bin:$PATH"

RUN git git clone -b master https://github.com/flutter/flutter.git
    ./flutter/bin/flutter --version && \
    /home/codespace/flutter/bin/flutter config --enable-web
    
# RUN git clone https://github.com/flutter/flutter && \
#     /home/codespace/flutter/bin/flutter config --enable-web 
