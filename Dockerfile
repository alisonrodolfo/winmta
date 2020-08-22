# ----------------------------------
# Environment: ubuntu
# ----------------------------------
FROM        ubuntu:18.04

LABEL       author="Alison Barreiro" maintainer="equipemasters@live.com"

# Install Dependencies
RUN dpkg --add-architecture i386 \
 && apt update \
 && apt upgrade -y \
 && apt install -y software-properties-common iproute2 \
 && apt install -y --install-recommends zip unzip sudo wget curl wine64 libssl1.1 iproute2 lib32gcc1 libntlm0 wget winbind \
 && useradd -d /home/container -m container

RUN     ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
RUN     apt-get install -y tzdata
RUN     dpkg-reconfigure --frontend noninteractive tzdata

USER        container
ENV         HOME /home/container
ENV         WINEARCH win64
ENV         WINEPREFIX /home/container/.wine64
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
