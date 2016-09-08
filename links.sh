#!/bin/bash
echo "create links of configs"
ln -s ~/linux-configure-files/.vimrc ~/.vimrc
ln -s ~/linux-configure-files/.tmux.conf ~/.tmux.conf
ln -s ~/linux-configure-files/.vimperatorrc ~/.vimperatorrc
#ln -s ~/linux-configure-files/.inputrc ~/.inputrc

#after this , open vim ,then :PluginInstall
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

#install zsh
apt-get install zsh
chsh -s /bin/zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

