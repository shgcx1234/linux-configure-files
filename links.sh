#!/bin/bash

#1.Create ssh keys,after this paste .ssh/id_rsa.pub content to github
#ssh-keygen -t rsa -C shgcx1234@gmail.com
#git clone git@github.com:shgcx1234/linux-configure-files.git ~/linux-configure-files

#2.sudo linux-configure-files/links.sh
echo "create links of configs"
apt-get install tmux
ln -s ~/linux-configure-files/.vimrc ~/.vimrc
ln -s ~/linux-configure-files/.tmux.conf ~/.tmux.conf
ln -s ~/linux-configure-files/.vimperatorrc ~/.vimperatorrc
#ln -s ~/linux-configure-files/.inputrc ~/.inputrc

#Set git global account name and email
git config --global user.name shgcx1234
git config --global user.email shgcx1234@gmail.com

#3.after this , open vim ,then :PluginInstall
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

#install zsh
apt-get install zsh
#chsh -s /bin/zsh #leave the default term bash and use zsh in tmux
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc


#4.add below command into .bashrc
#create or reattach a tmux session when open a term
#if you want to pass ctrl-A to remote OregonUbuntu's tmux, you should press ctrl-A twice
#ctrl-A ctrl-A d you can restore your last work around when you ssh to remote ubuntu
#tmux attach-session -t "$USER" || tmux new-session -s "$USER"
#exit

