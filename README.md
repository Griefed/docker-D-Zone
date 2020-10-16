# [D-Zone](https://github.com/d-zone-org/d-zone)
https://github.com/d-zone-org/d-zone in a container!

[![Docker Pulls](https://img.shields.io/docker/pulls/griefed/d-zone?style=flat-square)](https://hub.docker.com/repository/docker/griefed/d-zone)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/griefed/d-zone?label=Image%20size&sort=date&style=flat-square)](https://hub.docker.com/repository/docker/griefed/d-zone)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/griefed/d-zone?label=Docker%20build&style=flat-square)](https://hub.docker.com/repository/docker/griefed/d-zone)
[![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/griefed/d-zone?label=Docker%20build&style=flat-square)](https://hub.docker.com/repository/docker/griefed/d-zone)
[![GitHub Repo stars](https://img.shields.io/github/stars/Griefed/docker-D-Zone?label=GitHub%20Stars&style=social)](https://github.com/Griefed/docker-D-Zone)
[![GitHub forks](https://img.shields.io/github/forks/Griefed/docker-D-Zone?label=GitHub%20Forks&style=social)](https://github.com/Griefed/docker-D-Zone)

Creates a Container which runs the heroku branch of [D-Zone-Org's](https://github.com/d-zone-org) [D-Zone](https://github.com/d-zone-org/d-zone), with [lsiobase/alpine](https://hub.docker.com/r/lsiobase/alpine) as the base image, as seen on https://pixelatomy.com/dzone/?s=default. 

The lasiobase/alpine image is a custom base image built with [Alpine linux](https://alpinelinux.org/) and [S6 overlay](https://github.com/just-containers/s6-overlay).
Using this image allows us to use the same user/group ids in the container as on the host, making file transfers much easier

---

# Work In Progress!
D-Zone is a graphical simulation meant to abstractly represent the activity in your Discord server.

This is not meant for any actual monitoring or diagnostics, only an experiment in the abstraction of chatroom data represented via autonomous characters in a scene.

## Deployment

### Pre-built images

Tag | Explanation
----|------------
proxy | Use this image if you are using a reverse proxy
port | Use this image if you want to access d-zone via `IP:PORT`

```docker-compose.yml
  d-zone:
    container_name: d-zone
    image: griefed/d-zone:<tag> # Either proxy or port
    restart: unless-stopped
    volumes:
      - ./path/to/config/files:/config
    environment:
      - TOKEN=<YOUR_BOT_TOKEN_HERE>
      - TZ=Europe/Berlin
      - PUID=1000  # User ID
      - PGID=1000  # Group ID
    ports:         # Only specify a port mapping when
      - 3000:3000  # using the port tag
```

### Raspberry Pi & building the image yourself

Using the [Dockerfile.port](https://github.com/Griefed/docker-D-Zone/blob/lsiobase/alpine/Dockerfile.port), this container can be built and run on a Raspberry Pi. 
I've tested it on a Raspberry Pi 3B & 3B+.

#### docker-compose.yml

```docker-compose.yml
  d-zone:
    container_name: d-zone
    build: ./d-zone/
    restart: unless-stopped
    volumes:
      - ./path/to/config/files:/config
    environment:
      - TOKEN=<YOUR_BOT_TOKEN_HERE>
      - TZ=Europe/Berlin
      - PUID=1000  #User ID
      - PGID=1000  #Group ID
    ports:
      - 3000:3000
```

1. Clone the repository: `git clone https://github.com/Griefed/docker-D-Zone.git ./d-zone`
1. Rename **Dockerfile.port to **Dockerfile**: `mv Dockerfile.port Dockerfile`
1. Prepare docker-compose.yml file as seen below
1. docker-compose up -d --build d-zone
1. Visit IP.ADDRESS.OF.HOST:3000
1. ???
1. Profit!

## Configuration

Configuration | Explanation
------------ | -------------
restart | [Restart policy](https://docs.docker.com/compose/compose-file/#restart) Either: "no", always, on-failure, unless-stopped
volumes | /config contains all relevant configuration files.
TZ | Timezone
PUID | for UserID
PGID | for GroupID
ports | The port where D-Zone will be available at. Only relevant when using `port`-tag

## User / Group Identifiers

When using volumes, permissions issues can arise between the host OS and the container. [Linuxserver.io](https://www.linuxserver.io/) avoids this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

## Specify channels to ignore:
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

## Running D-Zone behind a reverse proxy like NGINX

If you want to serve d-zone with a reverse proxy like nginx and HTTPS, then this may be of help to you:

```docker-compose.yml
  d-zone:
    container_name: d-zone
    image: griefed/d-zone:proxy
    restart: unless-stopped
    volumes:
      - ./path/to/config/files:/config
    environment:
      - TOKEN=<YOUR_BOT_TOKEN_HERE>
      - TZ=Europe/Berlin
      - PUID=1000  #User ID
      - PGID=1000  #Group ID
```

I use a dockerized NGINX as a reverse proxy, specifically [linuxserver/swag](https://hub.docker.com/r/linuxserver/swag).

```nginx
server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name SUBDMOAIN.*;

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
    }
}
```

![d-zone](https://i.imgur.com/uCd6eRa.png)
