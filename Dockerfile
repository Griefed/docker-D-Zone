FROM lsiobase/alpine:3.12

LABEL maintainer="Griefed <griefed@griefed.de>"

# Test whether these are needed. If not, remove
ENV HOME="/app"
ENV NODE_ENV="production"

# Build our D-Zone S6 image with lsiobase alpine. Much love to, Linuxserver.io!
RUN \
        echo "**** install dependencies and build tools and stuff ****" && \
        apk add --no-cache \
                git \
                nano \
                npm \
                nodejs && \
        mkdir -p \
                /app/d-zone && \
        git clone -b \
                heroku \
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

# Communicate port to be used
EXPOSE 3000
