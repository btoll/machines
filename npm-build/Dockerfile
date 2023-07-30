FROM node:17-bullseye-slim
LABEL maintainer "Benjamin Toll <benjam72@yahoo.com>"

ARG BUILD_DIR=/build

RUN mkdir $BUILD_DIR \
    && chown -R $USER:$USER $BUILD_DIR

WORKDIR $BUILD_DIR
USER node

ENTRYPOINT ["/bin/sh", "-c", "npm install && npm run build"]

