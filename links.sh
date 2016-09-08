#!/bin/bash
echo "create links of configs"
ln -s ~/linux-configure-files/.vimrc ~/.vimrc
ln -s ~/linux-configure-files/.tmux.conf ~/.tmux.conf
ln -s ~/linux-configure-files/.vimperatorrc ~/.vimperatorrc
#ln -s ~/linux-configure-files/.inputrc ~/.inputrc

#Set git global account name and email
git config --global user.name shgcx1234
git config --global user.email shgcx1234@gmail.com

#after this , open vim ,then :PluginInstall
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

#install zsh
apt-get install zsh
chsh -s /bin/zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

#Create ssh keys,after this paste .ssh/id_rsa.pub content to github
ssh-keygen -t rsa -C shgcx1234@gmail.com
