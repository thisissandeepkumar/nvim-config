FROM alpine:3.21.2

RUN apk add --no-cache llvm clang gdb clang-extra-tools build-base gcc musl-dev

RUN clang --version

WORKDIR /app

RUN apk add --no-cache build-base neovim git bash curl ncurses tree

RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim /root/.local/share/nvim/site/pack/packer/start/packer.nvim

CMD ["sh", "-c", "while :; do sleep 1; done"]
