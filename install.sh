#!/bin/bash
set -e  # прерывать при любой ошибке

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Начинаем установку ваших dotfiles и зависимостей...${NC}"

# Функция проверки наличия команды
check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✅ $1 уже установлен${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️ $1 не найден${NC}"
        return 1
    fi
}

# Функция установки пакета через apt
install_apt_package() {
    if ! dpkg -s "$1" &> /dev/null; then
        echo -e "${YELLOW}📦 Устанавливаю $1...${NC}"
        sudo apt install -y "$1"
    else
        echo -e "${GREEN}✅ $1 уже установлен${NC}"
    fi
}

# Запрос подтверждения
confirm() {
    read -p "$1 (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return 1
    fi
    return 0
}

# Проверка наличия sudo
if ! command -v sudo &> /dev/null; then
    echo -e "${RED}❌ sudo не установлен. Установите sudo вручную.${NC}"
    exit 1
fi

# Обновление списка пакетов
echo -e "${YELLOW}🔄 Обновление списка пакетов...${NC}"
sudo apt update

# 1. Установка базовых утилит
install_apt_package curl
install_apt_package git
install_apt_package wget

# 2. Установка Zsh
if ! check_command zsh; then
    install_apt_package zsh
    echo -e "${GREEN}✅ Zsh установлен. Чтобы сделать его оболочкой по умолчанию, выполните: chsh -s $(which zsh)${NC}"
else
    echo -e "${GREEN}✅ Zsh уже установлен${NC}"
fi

# 3. Установка Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}📦 Устанавливаю Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${GREEN}✅ Oh My Zsh уже установлен${NC}"
fi

# 4. Установка плагинов Zsh
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
PLUGINS_DIR="$ZSH_CUSTOM/plugins"

# Функция установки плагина из git
install_zsh_plugin() {
    local repo=$1
    local plugin_name=$(basename "$repo" .git)
    if [ ! -d "$PLUGINS_DIR/$plugin_name" ]; then
        echo -e "${YELLOW}🔌 Устанавливаю плагин $plugin_name...${NC}"
        git clone --depth=1 "https://github.com/$repo.git" "$PLUGINS_DIR/$plugin_name"
    else
        echo -e "${GREEN}✅ Плагин $plugin_name уже установлен${NC}"
    fi
}

mkdir -p "$PLUGINS_DIR"
install_zsh_plugin "zsh-users/zsh-syntax-highlighting"
install_zsh_plugin "zsh-users/zsh-autosuggestions"

# 5. Установка WezTerm (опционально)
if ! command -v wezterm &> /dev/null; then
    if confirm "Хотите установить WezTerm?"; then
        echo -e "${YELLOW}🔧 Добавляю репозиторий WezTerm и устанавливаю...${NC}"
        # Добавление GPG-ключа и репозитория
        curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
        echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list > /dev/null
        sudo apt update
        sudo apt install -y wezterm
    else
        echo -e "${YELLOW}⏭️ WezTerm пропущен.${NC}"
    fi
else
    echo -e "${GREEN}✅ WezTerm уже установлен${NC}"
fi

# 6. Установка Docker (официальный способ)
if ! check_command docker; then
    echo -e "${YELLOW}🐳 Устанавливаю Docker...${NC}"
    # Удаление старых версий
    sudo apt remove -y docker docker-engine docker.io containerd runc || true
    # Установка зависимостей
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    # Добавление ключа и репозитория
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    # Добавление пользователя в группу docker
    sudo usermod -aG docker $USER
    echo -e "${GREEN}✅ Docker установлен. После перезагрузки можно будет использовать без sudo.${NC}"
else
    echo -e "${GREEN}✅ Docker уже установлен${NC}"
fi

# 7. Установка шрифта MesloLGS Nerd Font
FONT_DIR="$HOME/.local/share/fonts"
FONT_NAME="MesloLGS NF"
if fc-list | grep -i "MesloLGS" &> /dev/null; then
    echo -e "${GREEN}✅ Шрифт MesloLGS Nerd Font уже установлен${NC}"
else
    echo -e "${YELLOW}🖌️ Устанавливаю шрифт MesloLGS Nerd Font...${NC}"
    mkdir -p "$FONT_DIR"
    cd /tmp
    wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
    mv *.ttf "$FONT_DIR/"
    fc-cache -fv
    echo -e "${GREEN}✅ Шрифт установлен. Не забудьте выбрать его в настройках терминала.${NC}"
fi

# 8. Применение ваших dotfiles (симлинки)
echo -e "${YELLOW}🔗 Настраиваю символические ссылки из репозитория...${NC}"

# Функция для безопасного создания ссылки
safe_link() {
    local src="$PWD/$1"
    local dst="$2"
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mv "$dst" "$dst.bak" 2>/dev/null || true
        echo "   Существующий файл $dst перемещён в $dst.bak"
    fi
    ln -sf "$src" "$dst"
    echo "   Создана ссылка $dst -> $src"
}

# Основные конфиги в корне
safe_link ".zshrc" "$HOME/.zshrc"
safe_link ".gitconfig" "$HOME/.gitconfig" 2>/dev/null || true

# WezTerm – теперь ссылка на папку .config/wezterm
if [ -d ".config/wezterm" ]; then
    mkdir -p "$HOME/.config"
    safe_link ".config/wezterm" "$HOME/.config/wezterm"
else
    echo -e "${YELLOW}⚠️ Папка .config/wezterm не найдена, пропускаю...${NC}"
fi

# Oh My Zsh custom – ссылка на папку
if [ -d "oh-my-zsh-custom" ]; then
    safe_link "oh-my-zsh-custom" "$HOME/.oh-my-zsh/custom"
else
    echo -e "${YELLOW}⚠️ Папка oh-my-zsh-custom не найдена, пропускаю...${NC}"
fi

# 9. Проверка и добавление плагинов в .zshrc, если их там нет
# (Можно автоматически добавить, но проще оставить пользователю)
echo -e "${YELLOW}⚠️ Не забудьте проверить, что в ~/.zshrc в списке plugins есть:${NC}"
echo "   zsh-syntax-highlighting zsh-autosuggestions docker docker-compose kubectl helm python pip node npm yarn history sudo ubuntu systemd"
echo "   (обычно они уже есть, если вы ранее их добавили)"

# 10. Сообщение о необходимости перезагрузки
echo -e "${GREEN}✅ Установка завершена!${NC}"
echo -e "${YELLOW}🔁 Рекомендуется перезагрузить компьютер, чтобы все изменения вступили в силу.${NC}"
echo "   После перезагрузки откройте терминал и убедитесь, что:"
echo "   - Zsh запускается по умолчанию (если меняли оболочку)"
echo "   - Docker работает (docker run hello-world)"
echo "   - Шрифт MesloLGS выбран в настройках терминала"
echo "   - Подсветка и автодополнение работают"