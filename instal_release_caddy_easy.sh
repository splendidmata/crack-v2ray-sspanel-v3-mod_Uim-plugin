#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Current folder
cur_dir=`pwd`
# Color
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
software=(V2Ray V2Ray_Caddy V2Ray_Caddy_cloudflare)
operation=(install install_BBR stop_disable_firewalld stop_disable_aliyun)
# Make sure only root can run our script
[[ $EUID -ne 0 ]] && echo -e "[${red}Error${plain}] 不是Root用宁妈呢!" && exit 1

get_char(){
    SAVEDSTTY=`stty -g`
    stty -echo
    stty cbreak
    dd if=/dev/tty bs=1 count=1 2> /dev/null
    stty -raw
    stty echo
    stty $SAVEDSTTY
}

# Pre-installation settings
pre_install_V2Ray(){
    echo "面板选择:SSpanel选0，SSRpanel选1，SSpanel可用webapi/mysql，SSRpanel仅可mysql"
    read -p "(v2ray_paneltype (Default 0):" v2ray_paneltype
    [ -z "${v2ray_paneltype}" ] && v2ray_paneltype=0
    echo
    echo "---------------------------"
    echo "v2ray面板方式选择 = ${v2ray_paneltype}"
    echo "---------------------------"
    echo
    # Set sspanel node_id
    echo "sspanel 节点中的node_id"
    read -p "(Default value: 0 ):" sspanel_node_id
    [ -z "${sspanel_node_id}" ] && sspanel_node_id=0
    echo
    echo "---------------------------"
    echo "sspanel_node_id = ${sspanel_node_id}"
    echo "---------------------------"
    echo
     # Set sspanel node_id
    echo "DNS选择 "
    read -p "(默认: localhost ):" lDNS
    [ -z "${lDNS}" ] && lDNS="localhost"
    echo
    echo "---------------------------"
    echo "DNS = ${lDNS}"
    echo "---------------------------"
    echo

    # Set caddy cloudflare ddns email
    echo "(可以不管)（动态dns）cloudflare email for ddns(optional)"
    read -p "(Default hulisang@test.com):" cloudflare_email
    [ -z "${cloudflare_email}" ]  && cloudflare_email="hulisang@test.com"
    echo
    echo "---------------------------"
    echo "cloudflare_email = ${cloudflare_email}"
    echo "---------------------------"
    echo

    # Set caddy cloudflare ddns key
    echo "(可以不管)（动态dns）cloudflare key for ddns(optional)"
    read -p "(Default bbbbbbbbbbbbbbbbbb ):" cloudflare_key
    [ -z "${cloudflare_key}" ] && cloudflare_key="bbbbbbbbbbbbbbbbbb"
    echo
    echo "---------------------------"
    echo "cloudflare_key = ${cloudflare_key}"
    echo "---------------------------"
    echo
    echo

    echo "请选择对接方式 0 for webapi 1 for mysql"
    read -p "(v2ray_usemysql (Default 0):" v2ray_usemysql
    [ -z "${v2ray_usemysql}" ] && v2ray_usemysql=0
    echo
    echo "---------------------------"
    echo "v2ray_usemysql = ${v2ray_usemysql}"
    echo "---------------------------"
    echo

    echo "（可以不管）Which MUREGEX will be used"
    read -p "(MUREGEX (Default %5m%id.%suffix):" MUREGEX
    [ -z "${MUREGEX}" ] && MUREGEX="%5m%id.%suffix"
    echo
    echo "---------------------------"
    echo "MUREGEX = ${MUREGEX}"
    echo "---------------------------"
    echo


    echo "（可以不管）Which MUSUFFIX will be used"
    read -p "(MUSUFFIX (Default microsoft.com):" MUSUFFIX
    [ -z "${MUSUFFIX}" ] && MUSUFFIX="microsoft.com"
    echo
    echo "---------------------------"
    echo "MUSUFFIX = ${MUSUFFIX}"
    echo "---------------------------"
    echo


    echo "（可以不管）Do u use proxy protocol"
    read -p "(ProxyTCP (Default 0):" ProxyTCP
    [ -z "${ProxyTCP}" ] && ProxyTCP=0
    echo
    echo "---------------------------"
    echo "ProxyTCP = ${ProxyTCP}"
    echo "---------------------------"
    echo


    if [ "${v2ray_usemysql}" -eq 0 ];
        then
      # Set sspanel_url
    echo "sspanel网站地址包含http（https）"
    read -p "(There is no default value please make sure you input the right thing):" sspanel_url
    [ -z "${sspanel_url}" ]
    echo
    echo "---------------------------"
    echo "sspanel_url = ${sspanel_url}"
    echo "---------------------------"
    echo
    # Set sspanel key
    echo "sspanel key对接密码，在.config里"
    read -p "(There is no default value please make sure you input the right thing):" sspanel_key
    [ -z "${sspanel_key}" ]
    echo
    echo "---------------------------"
    echo "sspanel_key = ${sspanel_key}"
    echo "---------------------------"
    echo
    else

   # Set Setting if the node go downwith panel
    echo "sspanel/ssrpanel的数据库ip"
    read -p "(v2ray_mysqlhost :" v2ray_mysqlhost
    [ -z "${v2ray_mysqlhost}" ] && v2ray_mysqlhost=""
    echo
    echo "---------------------------"
    echo "sspanel/ssrpanel的数据库ip = ${v2ray_mysqlhost}"
    echo "---------------------------"
    echo
    # Set Setting if the node go downwith panel
    echo "sspanel数据库端口"
    read -p "(v2ray_mysqlport (Default 3306):" v2ray_mysqlport
    [ -z "${v2ray_mysqlport}" ] && v2ray_mysqlport=3306
    echo
    echo "---------------------------"
    echo "sspanel/ssrpanel的数据库端口 = ${v2ray_mysqlport}"
    echo "---------------------------"
    echo
    # Set Setting if the node go downwith panel
    echo "sspanel数据库用户名user"
    read -p "(v2ray_myqluser (Default sspanel):" v2ray_myqluser
    [ -z "${v2ray_myqluser}" ] && v2ray_myqluser="sspanel"
    echo
    echo "---------------------------"
    echo "sspanel/ssrpanel的数据库用户名user = ${v2ray_myqluser}"
    echo "---------------------------"
    echo
    # Set Setting if the node go downwith panel
    echo "sspanel数据库密码"
    read -p "(v2ray_mysqlpassword (Default password):" v2ray_mysqlpassword
    [ -z "${v2ray_mysqlpassword}" ] && v2ray_mysqlpassword=password
    echo
    echo "---------------------------"
    echo "sspanel/ssrpanel的数据库密码 = ${v2ray_mysqlpassword}"
    echo "---------------------------"
    echo
    # Set Setting if the node go downwith panel
    echo "sspanel/ssrpanel的数据库名字"
    read -p "(v2ray_mysqldbname (Default sspanel):" v2ray_mysqldbname
    [ -z "${v2ray_mysqldbname}" ] && v2ray_mysqldbname=sspanel
    echo
    echo "---------------------------"
    echo "sspanel/ssrpanel数据库密码 = ${v2ray_mysqldbname}"
    echo "---------------------------"
    echo
    fi
    # Set sspanel speedtest function
    echo "（可以不用管）sspanel使用speedtest测速周期"
    read -p "(sspanel speedtest: Default (6) hours every time):" sspanel_speedtest
    [ -z "${sspanel_speedtest}" ] && sspanel_speedtest=6
    echo
    echo "---------------------------"
    echo "sspanel_speedtest = ${sspanel_speedtest}"
    echo "---------------------------"
    echo


    # Set Setting if the node go downwith panel
    echo "（可以不用管）节点是否跟随面板下线，0为节点端不下线，1为节点跟着下线"
    read -p "(v2ray_downWithPanel (Default 0):" v2ray_downWithPanel
    [ -z "${v2ray_downWithPanel}" ] && v2ray_downWithPanel=0
    echo
    echo "---------------------------"
    echo "v2ray_downWithPanel = ${v2ray_downWithPanel}"
    echo "---------------------------"
    echo
}

pre_install_caddy(){
    # Set caddy v2ray domain
    echo "v2ray的真实地址/IP"
    read -p "(There is no default value please make sure you input the right thing):" v2ray_ip
    [ -z "${v2ray_ip}" ]
    echo
    echo "---------------------------"
    echo "v2ray_ip = ${v2ray_ip}"
    echo "---------------------------"
    echo
    
    
    # Set caddy v2ray domain
    echo "v2ray伪装地址（填域名）"
    read -p "(There is no default value please make sure you input the right thing):" v2ray_domain
    [ -z "${v2ray_domain}" ]
    echo
    echo "---------------------------"
    echo "v2ray_domain = ${v2ray_domain}"
    echo "---------------------------"
    echo


    # Set caddy v2ray path
    echo "（下面可以不管了，一路回车吧）caddy v2ray path(不要带/)"
    read -p "(Default path: v2ray):" v2ray_path
    [ -z "${v2ray_path}" ] && v2ray_path="v2ray"
    echo
    echo "---------------------------"
    echo "v2ray_path = ${v2ray_path}"
    echo "---------------------------"
    echo

    # Set caddy v2ray tls email
    echo "caddy v2ray tls email"
    read -p "(No default ):" v2ray_email
    [ -z "${v2ray_email}" ]
    echo
    echo "---------------------------"
    echo "v2ray_email = ${v2ray_email}"
    echo "---------------------------"
    echo

    # Set Caddy v2ray listen port
    echo "caddy v2ray local listen port"
    read -p "(Default port: 10550):" v2ray_local_port
    [ -z "${v2ray_local_port}" ] && v2ray_local_port=10550
    echo
    echo "---------------------------"
    echo "v2ray_local_port = ${v2ray_local_port}"
    echo "---------------------------"
    echo

}

# Config docker
run_V2Ray(){
    echo "按下任意按键开始运行安装程序...或者按下Ctrl+C来取消"
    char=`get_char`
    echo "开始安装"
    bash <(curl -L -s https://raw.githubusercontent.com/splendidwrx/crack-v2ray-sspanel-v3-mod_Uim-plugin/master/install-release.sh) --panelurl "${sspanel_url}" --panelkey "${sspanel_key}" --nodeid ${sspanel_node_id} --downwithpanel ${v2ray_downWithPanel} --mysqlhost ${v2ray_mysqlhost} --mysqldbname ${v2ray_mysqldbname} --mysqluser ${v2ray_myqluser} --mysqlpasswd "${v2ray_mysqlpassword}" --mysqlport ${v2ray_mysqlport} --speedtestrate ${sspanel_speedtest} --paneltype ${v2ray_paneltype} --usemysql ${v2ray_myqluser} --ldns "${lDNS}" --cfkey ${cloudflare_key} --cfemail ${cloudflare_email} --muregex "${MUREGEX}" --musuffix "${MUSUFFIX}" --proxytcp ${ProxyTCP}
}

run_caddy(){
     echo "按下任意按键开始运行安装程序...或者按下Ctrl+C来取消"
     char=`get_char`
     echo "开始安装Caddy"
     bash <(curl -L -s https://raw.githubusercontent.com/splendidwrx/crack-v2ray-sspanel-v3-mod_Uim-plugin/master/install_caddy.sh) ${v2ray_ip} ${v2ray_email} ${v2ray_domain} ${v2ray_path} ${v2ray_local_port}  
}


install_select(){
    clear
    while true
    do
    echo  "想要安装哪种类型的V2Ray？"
    for ((i=1;i<=${#software[@]};i++ )); do
        hint="${software[$i-1]}"
        echo -e "${green}${i}${plain}) ${hint}"
    done
    read -p "Please enter a number (Default ${software[0]}):" selected
    [ -z "${selected}" ] && selected="1"
    case "${selected}" in
        1|2|3|4)
        echo
        echo "You choose = ${software[${selected}-1]}"
        echo
        break
        ;;
        *)
        echo -e "[${red}Error${plain}] Please only enter a number [1-4]"
        ;;
    esac
    done
}

#stop_disable_firewalld
stop_disable_firewalld(){
    echo "关掉防火墙"
    systemctl stop firewalld
    echo "不自启防火墙"
    systemctl disable firewalld

}

#install_BBR
install_BBR(){
    bash <(curl -L -s https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh)
}

#stop_disable_aliyun
stop_disable_aliyun(){
    echo "停止阿里云"
   systemctl stop aliyun
   echo "不自启阿里云" 
   systemctl disable aliyun
}

# Install v2ray
install(){
    install_select
    case "${selected}" in
        1)
        pre_install_V2Ray
        run_V2Ray
        ;;
        2)
        pre_install_V2Ray
        pre_install_caddy
        run_V2Ray
        run_caddy
        ;;
        3)
        pre_install_V2Ray
        pre_install_caddy
        run_V2Ray
        run_caddy
        ;;
        *)
        echo "Wrong number"
        ;;
    esac
}

# Initialization step
clear
while true
do
echo  "Which operation you'd select:"
for ((i=1;i<=${#operation[@]};i++ )); do
    hint="${operation[$i-1]}"
    echo -e "${green}${i}${plain}) ${hint}"
done
read -p "Please enter a number (Default ${operation[0]}):" selected
[ -z "${selected}" ] && selected="1"
case "${selected}" in
    1|2|3|4)
    echo
    echo "You choose = ${operation[${selected}-1]}"
    echo
    ${operation[${selected}-1]}
    break
    ;;
    *)
    echo -e "[${red}Error${plain}] Please only enter a number [1-4]"
    ;;
esac
done
