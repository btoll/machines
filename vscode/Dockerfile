FROM debian:bullseye-slim
LABEL maintainer "Benjamin Toll <benjam72@yahoo.com>"

ARG USER=noroot
ARG UID=1000

ENV HOME /home/${USER}
RUN useradd --uid ${UID} --create-home --home-dir $HOME ${USER} \
	&& chown -R ${USER}:${USER} $HOME

ENV LANG C.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y \
    gnupg \
    wget \
	xz-utils \
	libasound2 \
	libdbus-glib-1-2 \
	libgtk-3-0 \
	libx11-xcb-dev \
	libx11-xcb1 \
	libxrender1 \
	libxt6

RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- \
    | apt-key add - \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        code \
        libxshmfence1

WORKDIR $HOME
USER ${USER}

ENTRYPOINT ["/usr/bin/code"]

