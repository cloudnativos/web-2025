FROM node:20-alpine

WORKDIR /app

COPY archetypes archetypes
COPY content content
COPY data data
COPY i18n i18n
COPY layouts layouts
COPY static static
COPY themes themes
COPY .gitmodules config.toml icons.js package.json package-lock.json Makefile postcss.config.js ./

RUN apk add hugo make python3 py3-setuptools build-base git && \
    git init && \
    npm install && git submodule update -f --init --recursive

ENTRYPOINT [ "hugo" ]
CMD [ "server", "--disableLiveReload", "--bind", "0.0.0.0" ]
