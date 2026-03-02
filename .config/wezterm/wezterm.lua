-- Подключаем API wezterm
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Принудительно запускаем Zsh
config.default_prog = { '/usr/bin/zsh', '-l' }

-- Цветовая схема (можно выбрать из списка: https://wezfurlong.org/wezterm/colorschemes/)
config.color_scheme = "Dracula"

-- Шрифт (если установлен MesloLGS NF, иначе замените на свой)
config.font = wezterm.font("MesloLGS Nerd Font")
config.font_size = 13

-- Прозрачность фона
config.window_background_opacity = 0.9

config.window_decorations = "RESIZE"

config.initial_cols = 105 -- ширина окна в символах
config.initial_rows = 80 -- высота окна в символах

-- Отключить вкладки, если нужно
config.enable_tab_bar = false

-- Курсор — мигающая вертикальная черта
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500

return config
