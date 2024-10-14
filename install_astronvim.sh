#!/bin/bash

# Остановка выполнения скрипта при любой ошибке
set -e

# Шаг 1: Установка Bash-it
echo "Установка Bash-it..."
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh --silent
source ~/.bashrc

# Установка Neovim как редактора по умолчанию
echo 'export EDITOR=vim' >> ~/.bashrc
source ~/.bashrc

# Включение alias и completion в bash-it
echo "Включение alias и completion в bash-it..."
bash-it enable alias apt
bash-it enable completion git
bash-it enable alias systemd

# Шаг 2: Резервное копирование текущей конфигурации Neovim (если существует)
echo "Резервное копирование текущей конфигурации Neovim..."
if [ -d "$HOME/.config/nvim" ]; then
  mv ~/.config/nvim ~/.config/nvim.bak
fi

if [ -d "$HOME/.local/share/nvim" ]; then
  mv ~/.local/share/nvim ~/.local/share/nvim.bak
fi

if [ -d "$HOME/.local/state/nvim" ]; then
  mv ~/.local/state/nvim ~/.local/state/nvim.bak
fi

if [ -d "$HOME/.cache/nvim" ]; then
  mv ~/.cache/nvim ~/.cache/nvim.bak
fi

# Шаг 3: Скачивание и установка Neovim версии 0.9.4
echo "Скачивание и установка Neovim..."
wget https://github.com/neovim/neovim/releases/download/v0.9.4/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

# Удаление старого пути к nvim, если он есть
if [ -f /usr/bin/nvim ]; then
  sudo rm /usr/bin/nvim
fi

# Создание символической ссылки на новый путь
sudo ln -s /usr/local/bin/nvim /usr/bin/nvim

# Проверка установки Neovim
ls -l /usr/local/bin/nvim
nvim --version

# Шаг 4: Установка AstroNvim
echo "Клонирование репозитория AstroNvim..."
git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim

# Удаление привязки к удаленному репозиторию
rm -rf ~/.config/nvim/.git

# Запуск Neovim для первоначальной установки плагинов
nvim +PackerSync

# Шаг 5: Установка LSP и Treesitter
echo "Установка LSP и Treesitter..."
nvim --headless +LspInstall +TSInstall +qall

# Шаг 6: Установка необходимых пакетов
echo "Установка ripgrep и npm..."
sudo apt-get update
sudo apt-get install -y ripgrep npm

# Установка Tree-sitter CLI через npm
npm install -g tree-sitter-cli

# Шаг 7: Установка дополнительных пакетов для ble.sh
echo "Установка дополнительных пакетов для ble.sh..."
sudo apt install -y git make gawk

# Установка ble.sh
echo "Установка ble.sh..."
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local
echo 'source ~/.local/share/blesh/ble.sh' >> ~/.bashrc
source ~/.bashrc

echo "Установка завершена!"
