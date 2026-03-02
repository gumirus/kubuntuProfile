# 🐧 Kubuntu Profile

Мои конфигурационные файлы (dotfiles) для Kubuntu: Zsh, Oh My Zsh, WezTerm и другие настройки.

## 🚀 Установка

1. **Клонируйте репозиторий**  
   ```bash
   git clone git@github.com:gumirus/kubuntuProfile.git ~/.dotfiles
   ```

2. **Запустите установочный скрипт**  
   ```bash
   cd ~/.dotfiles
   ./install.sh
   ```

3. **Перезапустите терминал** или выполните `source ~/.zshrc`, чтобы изменения вступили в силу.

## 📦 Зависимости

Перед установкой убедитесь, что в системе установлены:

- **Zsh**  
  ```bash
  sudo apt install zsh
  ```

- **Oh My Zsh**  
  ```bash
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ```

- **WezTerm** (опционально)  
  ```bash
  sudo apt install wezterm
  ```

## ⚠️ Важно

Скрипт `install.sh` **не устанавливает** сами программы (Zsh, Oh My Zsh, WezTerm), а только настраивает их. На новой системе их нужно поставить заранее.

## 🔧 Что входит в конфигурацию

- `.zshrc` – основной конфиг Zsh
- `oh-my-zsh-custom/` – пользовательские плагины и темы
- `wezterm/` – настройки терминала WezTerm
- `.gitconfig` – глобальные настройки Git (если есть)

## 🧪 Проверка работоспособности

После установки откройте новый терминал и выполните:

```bash
echo $ZSH_CUSTOM   # должно показывать ~/.oh-my-zsh/custom
```

Если всё настроено правильно, вы увидите свою привычную тему и плагины.

## 📝 Лицензия

MIT (или укажите свою)