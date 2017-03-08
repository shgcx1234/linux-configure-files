# Ubuntu安装后配置
===
## 0、启用root并配置自动登录
* 给root用户设置个密码
    
    `sudo passwd root`
* 设置自动登录
	* 方法一 系统设置-用户账户-解锁-打开自动登录(貌似只有普通用户可以这样)
	* 方法二 编辑/etc/lightdm/lightdm.conf：(所有账号都适用)
	    ```
	    sudo vim  /etc/lightdm/lightdm.conf

	    [Seat:*]
	    autologin-guest=false
	    autologin-user=root
	    autologin-user-timeout=0

	    (貌似不需要下面的代码就可以搞定)
	    #user-session=ubuntu
	    #greeter-session=unity-greeter
	    #allow-guest=false
	    #greeter-show-manual-login=true

* 编辑/root/.profile文件，增加tty -s &&：

	    `tty -s && mesg n || true` 

## 1、根据网络环境，配置网络参数

1) 配置静态IP

`sudo vi /etc/network/interfaces`

原有内容只有如下两行：
```bash
auto lo
iface lo inet loopback
```
如果是动态获取IP地址，那么就不需要添加如下内容
如果设置静态IP,向末尾追加以下内容：
```bash
auto eth0   （是否为eth0，可以通过ifconfig -a 查看）
iface eth0 inet static
address 静态IP地址
netmask 255.255.255.0
gateway 192.168.0.1 
network 192.168.0.0 （不是必须） 
broadcast 192.168.0.255 （不是必须）
dns-nameservers DNS地址（不是必须）
```
然后保存退出；

2) 配置DNS

编辑`sudo vi /etc/resolv.conf`  
向末尾追加如下内容（如果机器可以上网但不知道DNS的话，可以通过在终端使用nm-tool命令来查看）：
```
nameserver DNS地址
```
然后保存退出。

3) 重启网络服务`sudo /etc/init.d/networking restart` （貌似没用，需要重启电脑才行,或者试试`sudo ifdown eth0 && sudo ifup eth0`）

4) (貌似没碰到这个问题）这里有点有问题，就是重启ubuntu后，发现又不能上网了，问题出在 /etc/resolv.conf。重启后，此文件配置的dns又被自动修改为默认值。所以需要永久性修改DNS。方法如下：编辑`sudo vim /etc/resolvconf/resolv.conf.d/base`，添加：
```
nameserver DNS地址
sudo reboot，重启就可以上网了
```

## 2、配置更新源（否则无法安装VIM等常用软件）
```
apt-get update & apt-get upgrade
apt-get install aptitude
apt-get install vim
apt-get install vim-gnome (使vim支持系统剪贴板）
```

## 3、简单配置系统
* 交换ctrl和capslock

You should edit the file /etc/default/keyboard and modify the XKBOPTIONS setting.  
For example to map capslock to control set XKBOPTIONS=“ctrl:nocaps”  
log out and log in again for changes to impact your system.
* 配置等宽字体

终端-编辑-配置文件首选项-custom font 选择等宽字体

## 4、安装搜狗拼音
```
apt-get install fcitx
dpkg -i 搜狗deb安装包路径（**如果报依赖错误的话，apt-get -f install貌似可以安装依赖包，从而解决此问题**）
alt+F2,搜索fcitx,点击启动fcitx，右上角选择搜狗输入法，另配置中删除多余输入法。
```

## 5、clone github中的配置文件
1) 生成ssh key并添加到github
```
ssh-keygen -t rsa -C shgcx1234@gmail.com
将生成的.ssh/id_rsa.pub的全部内容添加到github账号
```

2) 安装git并clone配置文件
```
sudo apt-get install git
git clone git@github.com:shgcx1234/linux-configure-files.git
sudo ./linux-configure-files/link.sh
```

## 6、默认启用tmux
`sudo vim .bashrc`在文件末尾添加如下代码
```
#create or reattach a tmux session when open a term
#if you want to pass ctrl-A to remote OregonUbuntu's tmux, you should press ctrl-A twice
#ctrl-A ctrl-A d you can restore your last work around when you ssh to remote ubuntu
tmux attach-session -t "$USER" || tmux new-session -s "$USER"
exit
```

## 7、安装shadowsocks
1) 安装并配置shadowsocks

`sudo -s` **建议提前切换成root ，获取超级管理员权限（或者在后面所有命令前都要加上sudo，包括在supervisor配置文件中的SS启动命令以及在rc.local中的SS开机启动命令，否则会报各种不同用户相互之间（root与Ubuntu）没权限的错误导致命令无法正常运行。）
（貌似不同用户安装的软件，别的用户调用该命令（root貌似也无法调用用户Ubuntu安装的部分程序命令和文件）的时候容易出现各种权限问题，建议都用同一个用户（root）进行安装和运行**
```
apt-get install python-pip // 安装python包管理工具pip
pip install shadowsocks // 安装shadowsocks  （加 sudo)
vim ~/shadow.json
{
  2 "server":"*********",
  3 "server_port":"443",
  4 "local_port":"1080",
  5 "password":"*******",
  6 "timeout":"600",
  7 "method":"AES-256-CFB"
  8 }
```
2) 配置Shadowsocks成自启动服务
* 首先安装Supervisor
```
apt-get update
apt-get install supervisor
```
* 然后编辑 /etc/supervisor/conf.d/shadowsocks.conf
```
[program:shadowsocks]
command=sslocal -c /etc/shadowsocks.json (**此处路径最好为绝对路径，因为root的～和Michael不一样**）
autorestart=true
user=nobody
```
* 如果你想绑定的端口是小于1024的则需要将user改为root
在 /etc/default/supervisor 最后加一行：
```
ulimit -n 51200
```
* 然后执行
```
service supervisor start
supervisorctl reload
```
SS就变成一个服务了，这样，SS将在开机时自动启动，而如果进程意外退出，Supervisor也会自动重启SS。
* 在/etc/rc.local文件中添加 service supervisor start（否则 supervisor 貌似无法开机启动）
    (20170307 貌似现在不需要这一步也可以自启动了)

## 8、同步火狐

## 9、配置.zshrc，添加历史记录相关命令
`vim .zshrc`,添加如下内容：
```
#关于历史纪录的配置 {{{

#历史纪录条目数量
export HISTSIZE=10000
#注销后保存的历史纪录条目数量
export SAVEHIST=10000

#历史纪录文件位置
export HISTFILE=~/linux-configure-files/.msy_history

#以附加的方式写入历史纪录
setopt INC_APPEND_HISTORY

#如果连续输入的命令相同，历史纪录中只保留一个
#setopt HIST_IGNORE_DUPS      
# 不保留重复的历史记录项
setopt HIST_IGNORE_ALL_DUPS
#在命令前添加空格，不将此命令添加到纪录文件中
setopt HIST_IGNORE_SPACE      

#为历史纪录中的命令添加时间戳      
setopt EXTENDED_HISTORY      

#启用 cd 命令的历史纪录，cd -[TAB]进入历史路径
setopt AUTO_PUSHD
#相同的历史路径只保留一个
setopt PUSHD_IGNORE_DUPS

#}}}
```
