FROM node:alpine

RUN apk add --no-cache ffmpeg hurl

WORKDIR /app
RUN chown node:node /app
USER node

WORKDIR /app/bin/ffcheck
COPY ./bin/ffcheck/package*.json ./
RUN yarn

WORKDIR /app
COPY --chown=node . .

EXPOSE 9000

# todo: automation
# this is just a container for reproducible manual use for now