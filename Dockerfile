FROM node:8-alpine

LABEL   maintainer="Griefed <griefed@griefed.de>"
LABEL   description="Based on https://github.com/d-zone-org/d-zone/tree/v1/docker \
but pulls files from GitHub instead of copying from local filesystem. \
You must set your bot token as an environment variable and your bot must be \
a member of at least one server for this to work."


RUN     apk update && apk upgrade && apk add git && apk add nano                        && \
        git clone -b heroku https://github.com/d-zone-org/d-zone.git /opt/d-zone        && \
        cd /opt/d-zone                                                                  && \
        npm install --no-optional                                                       && \
        npm run-script build                                                            && \
        apk del git

WORKDIR /opt/d-zone

RUN     node ./script/update-config.js

CMD ["npm","start"]
