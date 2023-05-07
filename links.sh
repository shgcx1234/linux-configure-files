#!/bin/bash

#1. install git on server, then
#Create ssh keys,then paste .ssh/id_rsa.pub content to github
#ssh-keygen -t rsa -C test06182126.com
#git clone git@github.com:shgcx1234/linux-configure-files.git

#2.sudo linux-configure-files/links.sh
echo "create links of configs"
sudo apt install tmux
ln -s ~/linux-configure-files/.vimrc ~/.vimrc
ln -s ~/linux-configure-files/.tmux.conf ~/.tmux.conf
#ln -s ~/linux-configure-files/.vimperatorrc ~/.vimperatorrc
#ln -s ~/linux-configure-files/.inputrc ~/.inputrc

#Set git global account name and email
git config --global user.name test0618
git config --global user.email test0618@126.com

#3.after this , open vim ,then :PluginInstall
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

#install zsh
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ln -sf ~/linux-configure-files/.zsh_history  ~/.zsh_history
# add netxt line into .zshrc
# It logs duplicate commands. But every time you open terminal, it will delete all duplicate commands.
#setopt hist_ignore_all_dups



#4.(no need) add below command into .bashrc
#create or reattach a tmux session when open a term
#if you want to pass ctrl-A to remote OregonUbuntu's tmux, you should press ctrl-A twice
#ctrl-A ctrl-A d you can restore your last work around when you ssh to remote ubuntu
#tmux attach-session -t "$USER" || tmux new-session -s "$USER"
#exit

