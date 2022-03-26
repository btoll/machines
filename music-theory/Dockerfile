FROM node:17-alpine

RUN apk update \
    && apk add \
        bash \
        git \
        python3

RUN adduser \
    --uid 1001 \
    --no-create-home \
    --disabled-password \
    --shell /bin/sh \
    noroot

RUN mkdir /build
COPY . /build
WORKDIR /build

RUN npm install \
    && npm run build

USER noroot

ENTRYPOINT ["python3", "-m", "http.server"]

