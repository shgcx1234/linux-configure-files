# Kali安装后配置 git

标签（空格分隔）： kali

---
## 1、根据网络环境，配置网络参数
- 建议安装系统时就设置好，否则可能有问题

## 2、配置更新源
- 如果因为某些原因，你在安装kali过程中，当被问到“使用网络镜像”时选择了否（建议安装系统时选是），可能会导致你的sources.list文件中丢失一些条目，或者因为别的原因导致你使用apt-get命令总是找不到数据包，这时候就要考虑更新下源。
	'vim /etc/apt/sources.list`
可以删除该文件中的所有内容，也可以直接在文前添加新的APT源。

    这里我参考官方的更新源以及国内的更新源给出下面的sources.list

```
#官网kali源
deb http://http.kali.org/kali kali-rolling main contrib non-free

#中科大kali源
deb http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib
deb-src http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib
deb http://mirrors.ustc.edu.cn/kali-security kali-current/updates main contrib non-free
deb-src http://mirrors.ustc.edu.cn/kali-security kali-current/updates main contrib non-free

#阿里云kali源
deb http://mirrors.aliyun.com/kali kali-rolling main non-free contrib
deb-src http://mirrors.aliyun.com/kali kali-rolling main non-free contrib
deb http://mirrors.aliyun.com/kali-security kali-rolling/updates main contrib non-free
deb-src http://mirrors.aliyun.com/kali-security kali-rolling/updates main contrib non-free
```

对软件进行一次整体更新：
```bash
apt-get update & apt-get upgrade
apt-get dist-upgrade 
apt-get clean

apt-get install aptitude
```

## 3、简单配置系统
* 交换ctrl和capslock
You should edit the file /etc/default/keyboard and modify the XKBOPTIONS setting.
For example to map capslock to control set XKBOPTIONS=“ctrl:nocaps”
log out and log in again for changes to impact your system.

* 设置重启时，root自动登录
`root@kali:~# vim /etc/gdm3/daemon.conf`
Kali 2.0启用自动登录用户


* 设置启动终端的快捷键

## 4、克隆git中的配置文件
1. `ssh-keygen -t rsa -C shgcx1234@gmail.com`
将生成的.ssh/id_rsa.pub的全部内容添加到github账号
2. `git clone git@github.com:shgcx1234/linux-configure-files.git
./linux-configure-files/link.sh`

## 5、安装搜狗拼音
```
apt-get install fcitx
dpkg -i 搜狗deb安装包路径（如果报依赖错误的话，apt-get -f install貌似可以安装依赖包，从而解决此问题）
重启后，即可使用搜狗拼音
```
## 6、安装shadowsocks
```
apt-get install python-pip
pip install shadowsocks
vim ~/shadow.json
{
  2 "server":"52.192.119.175",
  3 "server_port":"443",
  4 "local_port":"1080",
  5 "password":"8013601",
  6 "timeout":"600",
  7 "method":"AES-256-CFB"
  8 }
```
### 配置成自启动服务
* 首先安装Supervisor
```
apt-get update 
apt-get install supervisor
```
* 然后编辑 /etc/supervisor/conf.d/shadowsocks.conf
```
[program:shadowsocks] 
command=ssserver -c /etc/shadowsocks.json 
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

## 7、同步火狐


