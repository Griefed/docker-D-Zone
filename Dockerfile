FROM lsiobase/alpine:3.12

LABEL maintainer="Griefed <griefed@griefed.de>"
LABEL description="Dockerfile to build an image of D-Zone which is to be accessed with IP:PORT"

# Install dependencies, download app, build app, remove unneeded stuff
RUN \
        echo "**** install dependencies and build tools and stuff ****" && \
        apk add --no-cache \
                git \
                npm && \
        mkdir -p \
                /app/d-zone && \
        git clone -b \
                v1/docker \
                https://github.com/d-zone-org/d-zone.git \
                /app/d-zone && \
        echo "**** run npm install and build D-Zone ****" && \
                cd /app/d-zone && \
                npm install --no-optional && \
                npm run-script build && \
        echo "**** delete git as we no longer need it ****" && \
                apk del --purge \
                        git && \
                rm -rf \
                        /root/.cache \
                        /tmp/*

# Copy local files
COPY root/ /

# Communicate ports and volumes to be used
EXPOSE 3000

VOLUME /config
