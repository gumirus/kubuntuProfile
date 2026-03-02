#!/bin/bash
# install.sh – автоматическая установка dotfiles

set -e  # прерывать при ошибке

echo "🔗 Создаём символические ссылки..."

# Ссылка на .zshrc
ln -sf "$PWD/.zshrc" "$HOME/.zshrc"

# Oh My Zsh custom
if [ -d "$HOME/.oh-my-zsh/custom" ]; then
    # Создаём бэкап, если папка уже существует
    mv "$HOME/.oh-my-zsh/custom" "$HOME/.oh-my-zsh/custom.bak"
fi
ln -sf "$PWD/oh-my-zsh-custom" "$HOME/.oh-my-zsh/custom"

# WezTerm
mkdir -p "$HOME/.config"
if [ -d "$HOME/.config/wezterm" ]; then
    mv "$HOME/.config/wezterm" "$HOME/.config/wezterm.bak"
fi
ln -sf "$PWD/wezterm" "$HOME/.config/wezterm"

# Gitconfig (если есть)
[ -f "$PWD/.gitconfig" ] && ln -sf "$PWD/.gitconfig" "$HOME/.gitconfig"

echo "✅ Готово!"
