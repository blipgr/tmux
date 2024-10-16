#!/bin/bash

# Остановка выполнения скрипта при любой ошибке
#set -e

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
#!/bin/bash

# Создание нового файла пользовательских настроек для AstroNvim
CONFIG_DIR="$HOME/.config/nvim/lua"
USER_CONFIG_FILE="$CONFIG_DIR/user_config.lua"

# Создаем директорию, если она не существует
if [ ! -d "$CONFIG_DIR" ]; then
    echo "Создание директории $CONFIG_DIR"
    mkdir -p "$CONFIG_DIR"
    if [ $? -ne 0 ]; then
        echo "Ошибка: не удалось создать директорию $CONFIG_DIR"
        exit 1
    fi
fi

# Создаем файл user_config.lua с пользовательскими настройками
if [ ! -f "$USER_CONFIG_FILE" ]; then
    echo "Создание файла пользовательских настроек $USER_CONFIG_FILE"
    cat <<EOL > "$USER_CONFIG_FILE"
-- Файл пользовательских настроек

-- Переопределение dd для удаления без копирования в буфер обмена
vim.keymap.set('n', 'dd', '"_dd', { noremap = true, desc = "Delete line without copying" })

-- Здесь вы можете добавить другие пользовательские настройки
EOL
    if [ $? -ne 0 ]; then
        echo "Ошибка: не удалось создать файл $USER_CONFIG_FILE"
        exit 1
    fi
else
    echo "Файл $USER_CONFIG_FILE уже существует."
fi

# Обновление файла lazy_setup.lua для загрузки пользовательских настроек
LAZY_SETUP_FILE="$CONFIG_DIR/lazy_setup.lua"
if [ -f "$LAZY_SETUP_FILE" ]; then
    if ! grep -q "require(\"user_config\")" "$LAZY_SETUP_FILE"; then
        echo "Добавление строки для загрузки пользовательских настроек в $LAZY_SETUP_FILE"
        echo "require(\"user_config\")" >> "$LAZY_SETUP_FILE"
        if [ $? -ne 0 ]; then
            echo "Ошибка: не удалось обновить файл $LAZY_SETUP_FILE"
            exit 1
        fi
        echo "Файл lazy_setup.lua обновлен для загрузки пользовательских настроек."
    else
        echo "Строка require(\"user_config\") уже присутствует в $LAZY_SETUP_FILE"
    fi
else
    echo "Ошибка: файл lazy_setup.lua не найден. Пожалуйста, добавьте строку \"require(\"user_config\")\" вручную."
fi

echo "Пользовательские настройки созданы и файл user_config.lua готов."

source ~/.bashrc

echo "Установка завершена!"
