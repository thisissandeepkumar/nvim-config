#!/bin/bash

# Check if Homebrew is installed. If not, install it
if test ! $(which brew); then
  echo "Installing Homebrew..."
  # ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update

brew install neovim

git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim

mkdir -p ~/.config/nvim
curl -fsSL "https://raw.githubusercontent.com/thisissandeepkumar/nvim-config/refs/heads/main/init.lua" \
  -o ~/.config/nvim/init.lua

# Check if Node.js is installed. If not, install it with nvm
if test ! $(which node); then
  echo "Installing Node.js..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  source ~/.zshrc
  nvm install v22.13.1
fi

npm install -g eslint eslint_d
brew install llvm
pipx install pyright

# Install the Copilot plugin
git clone https://github.com/github/copilot.vim.git \
  ~/.config/nvim/pack/github/start/copilot.vim
