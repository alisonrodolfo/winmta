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
 && apt install -y --install-recommends vim zip unzip sudo wget curl nginx fontconfig wine64 libssl1.1 iproute2 lib32gcc1 libntlm0 wget winbind \
  && rm -rf /etc/nginx/nginx.conf \
 && useradd -d /home/container -m container

RUN         echo "worker_processes auto;\n\
                pid /tmp/nginx.pid;\n\
                daemon off;\n\
                worker_rlimit_nofile 5000;\n\
                events {\n\
                        worker_connections 5000;\n\
                }\n\
                error_log /home/container/nginx/error.log;\n\
                error_log /dev/stdout;\n\
                http {\n\
                        sendfile on;\n\
                        tcp_nopush on;\n\
                        tcp_nodelay on;\n\
                        keepalive_timeout 65;\n\
                        types_hash_max_size 2048;\n\
                        include /home/container/nginx/mime.types;\n\
                        default_type application/octet-stream;\n\                     
                        proxy_temp_path /tmp;\n\
                        client_body_temp_path /tmp;\n\
                        fastcgi_temp_path /tmp;\n\
                        uwsgi_temp_path /tmp;\n\
                        scgi_temp_path /tmp;\n\
                        ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE\n\
                        ssl_prefer_server_ciphers on;\n\
                        access_log /home/container/nginx/access.log;\n\
                        access_log /dev/stdout;\n\
                        error_log /home/container/nginx/error.log;\n\
                        error_log /dev/stdout;\n\
                        gzip on;\n\
                        gzip_types *;\n\
                        gzip_disable "msie6";\n\
                        include /home/container/nginx/conf.d/default.conf;\n\
                }" >> /etc/nginx/nginx.conf   

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
