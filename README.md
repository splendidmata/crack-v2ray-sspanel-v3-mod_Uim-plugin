# crack-pay-v2ray-sspanel-v3-mod_Uim-plugin

# 本版本是肮脏的破解版本，只是自己学习使用，请支持原版
# 破解二进制文件下载地址：[release](https://github.com/splendidwrx/crack-v2ray-sspanel-v3-mod_Uim-plugin/releases)

# 使用教程请看 [WIKI](https://github.com/splendidwrx/crack-v2ray-sspanel-v3-mod_Uim-plugin/wiki)

## 普通安装
### 后端安装（普通版）
``` bash
bash <(curl -L -s  https://raw.githubusercontent.com/splendidwrx/crack-v2ray-sspanel-v3-mod_Uim-plugin/master/install-release.sh) \
--panelurl http://webapi.com --panelkey webkey --nodeid 2 \
--downwithpanel 1 --speedtestrate 6 --paneltype 0 --usemysql 0 --cfemail mail --cfkey xxx
```
### 后端安装（简单带caddy版）
``` bash
bash <(curl -L -s  https://raw.githubusercontent.com/splendidwrx/crack-v2ray-sspanel-v3-mod_Uim-plugin/master/instal_release_caddy_easy.sh)
```
### caddy安装（已修复，可用性1000%）
``` bash
bash <(curl -L -s https://raw.githubusercontent.com/splendidwrx/crack-v2ray-sspanel-v3-mod_Uim-plugin/master/install_caddy.sh) node.com xxx@gmail.com fakeurl.com v2ray 10550
```

## Docker
### ws+tls
``` bash
cd docker_crack_tls
vi docker-compose.yml
docker-compose up -d
```
### ws
``` bash
cd docker_crack_ws
vi docker-compose.yml
docker-compose up -d
```
