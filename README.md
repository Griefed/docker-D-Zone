# docker-D-Zone
https://github.com/d-zone-org/d-zone/tree/v1/docker in a container!

Creates a Container which runs the v1/docker Branch of [D-Zone-Org's](https://github.com/d-zone-org) [D-Zone](https://github.com/d-zone-org/d-zone), with [node:8-alpine](https://hub.docker.com/_/node) as the base image, as seen on https://pixelatomy.com/dzone/?s=default. 

# Deploy with docker-compose:
```
  d-zone:
    container_name: d-zone
    image: griefed/d-zone
    restart: unless-stopped
    ports:
      - 3000:3000
    environment:
      - TOKEN=<YOUR_BOT_TOKEN_HERE>
```
### Deploy on Rasbperry Pi
Using the Dockerfile, this container can be built and run on a Raspberry Pi, too! I've tested it on a Raspberry Pi 3B+.
Simply put the Dockerfile in a directory called `d-zone` in the same directory as your docker-compose.yml, edit your docker-compose.yml:
```
  d-zone:
    container_name: d-zone
    build: ./d-zone/
    restart: unless-stopped
    ports:
      - 3000:3000
    environment:
      - TOKEN=<YOUR_BOT_TOKEN_HERE>
```
Then build with:
```
docker-compose up -d --build d-zone
```

## Note:
D-Zone will, by default, listen to all channels on the servers which your bot is connected to. If you want to set ignoreChannels, you need to edit a file in your D-Zone container:

- docker exec into the container: `docker exec -it d-zone /bin/sh`
- Open discord-config.json in NANO: `nano discord-config.json`
- Edit the "servers" block on a per server basis, e.g.:
```
  "servers": [
    {
      "id": "<YOUR_SERVER_ID_HERE",
      "default": true,
      "ignoreChannels": ["TEXTCHANNEL_ID1","TEXTCHANNEL_ID2","TEXTCHANNEL_ID3"]
    }
  ]
```
`CTRL+X` followed by `Y` followed by `ENTER` to safe and quit NANO. Enter `exit` to leave the container and restart the container with `docker restart d-zone`. 
This tutorial assumes that your bot is only a member of one server. If you want to define multiple server, see https://github.com/d-zone-org/d-zone/blob/master/discord-config-example.json

### Note 2

I use a dockerized nginx as a reverse proxy, specifically https://hub.docker.com/r/linuxserver/swag.
If you want to serve d-zone with a reverse proxy like nginx, then this may be of help to you:
```
server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name YOUR_SUBDOMAIN_HERE.*;

    include /config/nginx/ssl.conf;

    client_max_body_size 0;

    location / {
        include /config/nginx/proxy.conf;
        resolver 127.0.0.11 valid=30s;
        proxy_set_header HOST $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_pass_request_headers on;
        proxy_pass http://D_ZONE_SERVICE_NAME:3000;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
    }
}
```

![d-zone](https://i.imgur.com/ENSa5l0.png)
