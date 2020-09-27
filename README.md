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
- Install NANO as our text editor: ´apk add nano´
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

As far as I know there is currently no way to use a reverse proxy like nginx to serve this container with HTTPS. I've tried a lot of things mentioned [here](https://github.com/d-zone-org/d-zone/issues/5#issuecomment-699672593) and none of them worked. If you find a way to serve this container with nginx and HTTPS, please open an issue explain how you did it, because I sure as hell didn't get it to work.

![d-zone](https://i.imgur.com/ENSa5l0.png)
