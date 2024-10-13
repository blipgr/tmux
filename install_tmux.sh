#!/bin/bash

# Остановка выполнения скрипта при любой ошибке
set -e

# Обновление списка пакетов и установка tmux
echo "Установка tmux..."
sudo apt update && sudo apt install -y tmux git

# Создание директории для плагинов
echo "Создание директории для плагинов TPM..."
mkdir -p ~/.tmux/plugins

# Клонирование Tmux Plugin Manager (TPM)
if [ ! -d "~/.tmux/plugins/tpm" ]; then
  echo "Клонирование Tmux Plugin Manager (TPM)..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  echo "TPM уже установлен."
fi

# Создание файла .tmux.conf с текущей конфигурацией
echo "Создание файла ~/.tmux.conf..."
cat <<EOL > ~/.tmux.conf
set -g default-terminal "screen-256color"

# Изменение индексов
set -g base-index 1
setw -g pane-base-index 1

# Настройки прокрутки через Alt + PageUp и Alt + PageDown
bind -n M-PageUp copy-mode -u \; send-keys PageUp
bind -n M-PageDown send-keys PageDown

unbind r
bind r source-file ~/.tmux.conf

set -g mouse on
set-window-option -g mode-keys vi

unbind -T copy-mode-vi MouseDragEnd1Pane

# Плагины
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-sessionist'
set -g @plugin 'blipgr/tmux'  # Ваш форк с nordtheme/tmux
set -g @plugin 'nhdaly/tmux-better-mouse-mode'

set -g @resurrect-capture-pane-contents 'on'
set -g @continuum-restore 'on'

# Старт менеджера плагинов
run '~/.tmux/plugins/tpm/tpm'
EOL

# Перезагрузка конфигурации tmux, если он уже запущен
if pgrep tmux > /dev/null; then
  echo "Перезагрузка конфигурации tmux..."
  tmux source-file ~/.tmux.conf
fi

echo "Установка плагинов через TPM..."
~/.tmux/plugins/tpm/bin/install_plugins

echo "Установка и настройка завершена. Откройте новую сессию tmux и нажмите 'prefix + I' для загрузки плагинов."
