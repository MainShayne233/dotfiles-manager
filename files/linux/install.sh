# curl
sudo apt install curl

# git
sudo apt install git

# neovim
sudo apt install neovim

# jq
sudo apt install jq

# dotfiles
if ! [ -x "$(command -v dotfiles)" ]; then
  (
    mkdir $HOME/shell
    cd $HOME/shell
    git clone https://github.com/MainShayne233/dotfiles-manager
  )
else
    echo "already have dotfiles"
fi

# asdf
if ! [ -x "$(command -v asdf)" ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.0
fi

# hub
sudo snap install hub --classic

# xclip
sudo apt install xclip


# asdf plugins
source $HOME/.bashrc

sudo apt install -y build-essential autoconf m4 libncurses5-dev libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev libpng* libssh-dev unixodbc-dev xsltproc fop

asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git

if ! [[ `asdf list nodejs` ]]; then
  asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  
  bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
fi

asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git

# Clone Packlane
mkdir $HOME/packlane
if ! [ -d $HOME/packlane/packlane ]; then
  (
    mkdir $HOME/packlane
    cd $HOME/packlane
    git clone https://github.com/Packlane/packlane
  )
fi

cd $HOME/packlane/packlane
asdf install

asdf global nodejs 9.11.1

# yarn
if ! [[ `which yarn` ]]; then
  npm i -g yarn
  asdf reshim nodejs
  yarn config set prefix ~/.yarn
fi

# instal Slack
sudo snap install slack --classic

# tmux
sudo apt install tmux -y

# mongodb
if ! [[ `which mongo` ]]; then
  sudo apt install libcurl3 -y
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
  echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
  sudo apt update
  sudo apt install -y mongodb-org
fi


# postgres
if ! [[ `which psql` ]]; then
  sudo apt install -y postgresql postgresql-contrib
fi

# spotify
snap install spotify
