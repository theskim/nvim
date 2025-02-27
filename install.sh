#!/bin/bash

echo "🔍 Checking dependencies for Neovim..."

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

if ! command_exists rg; then
  echo "🚀 Installing ripgrep..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install ripgrep
  elif [[ -f /etc/debian_version ]]; then
    sudo apt update && sudo apt install -y ripgrep
  elif [[ -f /etc/redhat-release ]]; then
    sudo dnf install -y ripgrep
  elif [[ -f /etc/arch-release ]]; then
    sudo pacman -S --noconfirm ripgrep
  else
    echo "❌ Unsupported OS. Please install ripgrep manually."
    exit 1
  fi
else
  echo "✅ ripgrep is already installed."
fi

echo "🛠 Installing Neovim dependencies..."
nvim --headless "+Lazy! sync" +qall

echo "✅ Setup complete!"

