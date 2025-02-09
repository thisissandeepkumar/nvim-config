FROM alpine:3.21.2

RUN apk add --no-cache llvm clang

RUN clang --version

WORKDIR /app

RUN apk add --no-cache build-base neovim git bash curl ncurses tree

CMD ["sh", "-c", "while :; do sleep 1; done"]
