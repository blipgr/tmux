git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh
source $HOME/.bashrc
echo 'export EDITOR=nvim' >> ~/.bashrc
source ~/.bashrc
bash-it enable alias apt
bash-it enable completion git
bash-it enable  alias  systemd
sudo apt install git make gawk -Y
sudo apt -y install git make gawk
sudo apt install build-essential
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local
echo 'source ~/.local/share/blesh/ble.sh' >> ~/.bashrc
source ~/.bashrc
