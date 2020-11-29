[![docker-D-Zone](https://i.griefed.de/images/2020/11/18/docker-D-Zone_header.png)](https://github.com/Griefed/docker-D-Zone)

---

[![Docker Pulls](https://img.shields.io/docker/pulls/griefed/d-zone?style=flat-square)](https://hub.docker.com/repository/docker/griefed/d-zone)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/griefed/d-zone?label=Image%20size&sort=date&style=flat-square)](https://hub.docker.com/repository/docker/griefed/d-zone)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/griefed/d-zone?label=Docker%20build&style=flat-square)](https://hub.docker.com/repository/docker/griefed/d-zone)
[![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/griefed/d-zone?label=Docker%20build&style=flat-square)](https://hub.docker.com/repository/docker/griefed/d-zone)
[![GitHub Repo stars](https://img.shields.io/github/stars/Griefed/docker-D-Zone?label=GitHub%20Stars&style=social)](https://github.com/Griefed/docker-D-Zone)
[![GitHub forks](https://img.shields.io/github/forks/Griefed/docker-D-Zone?label=GitHub%20Forks&style=social)](https://github.com/Griefed/docker-D-Zone)

# docker-D-Zone

D-Zone is a graphical simulation meant to abstractly represent the activity in your Discord server. This is not meant for any actual monitoring or diagnostics, only an experiment in the abstraction of chatroom data represented via autonomous characters in a scene.

[![d-zone](https://i.griefed.de/images/2020/11/18/docker-D-Zone_screenshot.png)](https://github.com/d-zone-org/d-zone)

---

Creates a Container which runs [d-zone-org's](https://github.com/d-zone-org) [d-zone](https://github.com/d-zone-org/d-zone), with [lsiobase/alpine](https://hub.docker.com/r/lsiobase/alpine) as the base image, as seen on https://pixelatomy.com/dzone/?s=default.

The [lsiobase/alpine](https://hub.docker.com/r/lsiobase/alpine) image is a custom base image built with [Alpine linux](https://alpinelinux.org/) and [S6 overlay](https://github.com/just-containers/s6-overlay).
Using this image allows us to use the same user/group ids in the container as on the host, making file transfers much easier

# Deployment

Tags | Description
-----|-------------
port | Use tag `port` if accessing d-zone via IP:PORT
proxy | Use tag `proxy` if accessing d-zone through a reverse proxy line NGINX
port-arm | Use tag `port-arm` if accessing d-zone via IP:PORT
proxy-arm | Use tag `proxy-arm` if accessing d-zone through a reverse proxy line NGINX

## Pre-built images

Using docker-compose:

```docker-compose.yml
version: "2"
services:
  d-zone:
    image: griefed/d-zone:latest
    container_name: d-zone
    restart: unless-stopped
    environment:
      - TZ=Europe/Berlin # Timezone
      - TOKEN=YOUR_DISCORD_BOT_TOKEN # Needed for D-Zone to create the simulation. See https://discordapp.com/developers/applications/me
      - PUID=1000 # User ID
      - PGID=1000 # Group ID
    volumes:
      - /host/path/to/config:/config # Contains all application data and base-image config files
    ports:
      - 3000:3000/tcp # Website
```

Using CLI:

```bash
docker create \
  --name=d-zone \
  -e TZ=Europe/Berlin \
  -e TOKEN=YOUR_DISCORD_BOT_TOKEN \
  -e PUID=1000 \
  -e PGID=1000 \
  -v /host/path/to/config:/config \
  -p 3000:3000 \
  --restart unless-stopped \
  griefed/d-zone:latest
```
## Raspberry Pi

To run this container on a Raspberry Pi, use the `arm`-prefix for the `port`- and `proxy`-tags. I've tested the `port`-tag on a Raspberry Pi 3B.

`griefed/d-zone:port-arm`
`griefed/d-zone:proxy-arm`

# Configuration

Configuration | Explanation
------------ | -------------
[Restart policy](https://docs.docker.com/compose/compose-file/#restart) | "no", always, on-failure, unless-stopped
config volume | Contains config files and logs.
data volume | Contains your/the containers important data.
TZ | Timezone
PUID | for UserID
PGID | for GroupID
ports | The port where d-zone will be available at. Only relevant when using `griefed/d-zone:port`

## User / Group Identifiers

When using volumes, permissions issues can arise between the host OS and the container. [Linuxserver.io](https://www.linuxserver.io/) avoids this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

# Building the image yourself

Use the [Dockerfile](https://github.com/Griefed/docker-D-Zone/Dockerfile) to build the image yourself, in case you want to make any changes to it

docker-compose.yml:

```docker-compose.yml
version: '3.6'
services:
  d-zone:
    build: ./docker-D-Zone/
    container_name: d-zone
    restart: unless-stopped
    environment:
      - TZ=Europe/Berlin # Timezone
      - TOKEN=YOUR_DISCORD_BOT_TOKEN # Needed for D-Zone to create the simulation. See https://discordapp.com/developers/applications/me
      - PUID=1000 # User ID
      - PGID=1000 # Group ID
    volumes:
      - /host/path/to/config:/config # Contains all application data and base-image config files
    ports:
      - 3000:3000/tcp # Website
```

1. Clone the repository: `git clone https://github.com/Griefed/docker-D-Zone.git ./docker-D-Zone`
1. Rename **Dockerfile.port** to **Dockerfile**: `mv Dockerfile.port Dockerfile`
1. Prepare docker-compose.yml file as seen above
1. `docker-compose up -d --build d-zone`
1. Visit IP.ADDRESS.OF.HOST:8080
1. ???
1. Profit!

# App Information

**Specify channels to ignore:**

D-Zone will, by default, listen to all channels on the servers which your bot is connected to.
If you want to set ignoreChannels, you need to edit your `discord-config.json`file in the folder you specified in your `volumes:`.
Edit the "servers" block on a per server basis, e.g.:

```json
  "servers": [
    {
      "id": "<YOUR_SERVER_ID_HERE",
      "default": true,
      "ignoreChannels": ["TEXTCHANNEL_ID1","TEXTCHANNEL_ID2","TEXTCHANNEL_ID3"]
    }
  ]
```

If you want to define multiple servers, see https://github.com/d-zone-org/d-zone/blob/master/discord-config-example.json

**Running D-Zone behind a reverse proxy like NGINX**

If you want to serve d-zone with a reverse proxy like nginx and HTTPS, then this may be of help to you:

```docker-compose.yml
version: "2"
services:
  d-zone:
    image: griefed/d-zone:latest
    container_name: d-zone
    restart: unless-stopped
    environment:
      - TZ=Europe/Berlin # Timezone
      - TOKEN=YOUR_DISCORD_BOT_TOKEN # Needed for D-Zone to create the simulation. See https://discordapp.com/developers/applications/me
      - PUID=1000 # User ID
      - PGID=1000 # Group ID
    volumes:
      - /host/path/to/config:/config # Contains all application data and base-image config files
```

I use a dockerized NGINX as a reverse proxy, specifically [linuxserver/swag](https://hub.docker.com/r/linuxserver/swag).

```nginx
server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name SUBDOMAIN.*;

    include /config/nginx/ssl.conf;

    client_max_body_size 0;

    # enable for ldap auth, fill in ldap details in ldap.conf
    #include /config/nginx/ldap.conf;

    # enable for Authelia
    #include /config/nginx/authelia-server.conf;

    location / {
        # enable the next two lines for http auth
        #auth_basic "Restricted";
        #auth_basic_user_file /config/nginx/.htpasswd;

        # enable the next two lines for ldap auth
        #auth_request /auth;
        #error_page 401 =200 /ldaplogin;

        # enable for Authelia
        #include /config/nginx/authelia-location.conf;

        include /config/nginx/proxy.conf;
        resolver 127.0.0.11 valid=30s;

        proxy_set_header HOST $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_pass_request_headers on;
        set $upstream_app d-zone;
        set $upstream_port 3000;
        set $upstream_proto http;
        proxy_pass $upstream_proto://$upstream_app:$upstream_port;
        #proxy_http_version 1.0;
        #proxy_set_header Upgrade $http_upgrade;
        #proxy_set_header Connection "Upgrade";

    }
}
```
