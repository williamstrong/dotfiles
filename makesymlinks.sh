#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

# function for linking dotfiles
function linkdotfile {
  file="$1"
  if [ ! -e ~/.$file -a ! -L ~/.$file ]; then
      echo "$file not found, linking..." >&2
      ln -s ~/dotfiles/$file ~/.$file
  else
      echo "$file found, ignoring..." >&2
  fi
} 




install_zsh () {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $dir/zprezto/ ]]; then
	git clone --recursive https://github.com/sorin-ionescu/prezto.git zprezto

    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh)
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        if [[ -f /etc/redhat-release ]]; then
            sudo yum install zsh
            install_zsh
        fi
        if [[ -f /etc/debian_version ]]; then
            sudo apt-get install zsh
            install_zsh
        fi
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}

install_zsh

zsh install_prezto.zsh

# link over .vim and .vimrc
linkdotfile vim
linkdotfile vimrc

# link over .gitconfig
linkdotfile gitconfig
linkdotfile gitattributes

# link over .tmux.conf
linkdotfile tmux.conf

# create chunkwm config
linkdotfile chunkwmrc
linkdotfile skhdrc


# create zsh completion
linkdotfile zsh-completions


# Install Vundle
vim +PluginInstall +qall

# create a global Git ignore file
if [ ! -e ~/.global_ignore ]; then
    echo "~/.global_ignore not found, curling from Github..." >&2
    curl \
      https://raw.githubusercontent.com/github/gitignore/master/Global/Emacs.gitignore \
      https://raw.githubusercontent.com/github/gitignore/master/Global/Vim.gitignore \
      https://raw.githubusercontent.com/github/gitignore/master/Global/macOS.gitignore \
    > ~/.global_ignore 2> /dev/null
    git config --global core.excludesfile ~/.global_ignore &&
      echo "[message] adding ignore file to Git..." >&2
else
    echo "~/.global_ignore found, ignoring..." >&2
fi
