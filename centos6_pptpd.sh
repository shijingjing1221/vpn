#!/bin/bash
clear
echo ""
echo -e "\033[44;37m ###################################### \033[0m"
echo -e "\033[44;37m #   PPTPD Installer for CentOS 6.x   # \033[0m"
echo -e "\033[44;37m #                                    # \033[0m"
echo -e "\033[44;37m #    The original from DiaHosting    # \033[0m"
echo -e "\033[44;37m #                                    # \033[0m"
echo -e "\033[44;37m # Modify by Jetso / Date: 2012-12-15 # \033[0m"
echo -e "\033[44;37m #                                    # \033[0m"
echo -e "\033[44;37m #   Weibo: http://t.qq.com/jetsor    # \033[0m"
echo -e "\033[44;37m #                                    # \033[0m"
echo -e "\033[44;37m #           Version: 1.0             # \033[0m"
echo -e "\033[44;37m ###################################### \033[0m"
echo ""

## Define ##
get_char()
{
SAVEDSTTY=`stty -g`
stty -echo
stty cbreak
dd if=/dev/tty bs=1 count=1 2> /dev/null
stty -raw
stty echo
stty $SAVEDSTTY
}
echo ""
echo -e "\033[47;30m * Press any key to start installing PPTP VPN \033[0m"
echo -e "\033[47;30m * Or press Ctrl+C to cancel the installation \033[0m"
char=`get_char`
echo ""

## Start ##
echo "nameserver 8.8.8.8
nameserver 8.8.4.4
search localdomain" >> /etc/resolv.conf
service network restart

yum remove -y pptpd ppp
iptables --flush POSTROUTING --table nat
iptables --flush FORWARD
rm -rf /etc/pptpd.conf
rm -rf /etc/ppp

arch=`uname -m`
wget http://poptop.sourceforge.net/yum/stable/packages/pptpd-1.4.0-1.el6.$arch.rpm
wget http://poptop.sourceforge.net/yum/stable/packages/ppp-2.4.5-33.0.rhel6.$arch.rpm
wget http://poptop.sourceforge.net/yum/stable/packages/kernel_ppp_mppe-1.0.2-3dkms.noarch.rpm
wget http://poptop.sourceforge.net/yum/stable/packages/dkms-2.0.17.5-1.noarch.rpm
yum -y update
yum -y upgrade
yum -y install make libpcap iptables gcc-c++ logrotate tar cpio perl pam tcp_wrappers policycoreutils
rpm -ivh dkms-2.0.17.5-1.noarch.rpm
rpm -ivh kernel_ppp_mppe-1.0.2-3dkms.noarch.rpm
rpm -qa kernel_ppp_mppe
rpm -Uvh ppp-2.4.5-33.0.rhel6.$arch.rpm
rpm -Uvh pptpd-1.4.0-1.el6.$arch.rpm

rm -r /dev/ppp
mknod /dev/ppp c 108 0
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "mknod /dev/ppp c 108 0" >> /etc/rc.local
echo "echo 1 > /proc/sys/net/ipv4/ip_forward" >> /etc/rc.local
echo "localip 10.0.10.1" >> /etc/pptpd.conf
echo "remoteip 10.0.10.2-254" >> /etc/pptpd.conf
echo "ms-dns 8.8.8.8" >> /etc/ppp/options.pptpd
echo "ms-dns 8.8.4.4" >> /etc/ppp/options.pptpd

pass=`openssl rand 6 -base64`
if [ "$1" != "" ]
then pass=$1
fi

echo "OTW pptpd ${pass} *" >> /etc/ppp/chap-secrets

iptables -t nat -A POSTROUTING -s 10.0.10.0/24 -j SNAT --to-source `ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk 'NR==1 { print $1}'`
iptables -A FORWARD -p tcp --syn -s 10.0.10.0/24 -j TCPMSS --set-mss 1356
iptables -I FORWARD -p tcp --syn -i ppp+ -j TCPMSS --set-mss 1356
service iptables save

chkconfig iptables on
chkconfig pptpd on

service iptables start
service pptpd start

## Completed ##
echo ""
echo -e "\033[44;37m ###################################### \033[0m"
echo -e "\033[44;37m #   PPTPD Installer for CentOS 6.x   # \033[0m"
echo -e "\033[44;37m #                                    # \033[0m"
echo -e "\033[44;37m #    The original from DiaHosting    # \033[0m"
echo -e "\033[44;37m #                                    # \033[0m"
echo -e "\033[44;37m # Modify by Jetso / Date: 2012-12-15 # \033[0m"
echo -e "\033[44;37m #                                    # \033[0m"
echo -e "\033[44;37m #   Weibo: http://t.qq.com/jetsor    # \033[0m"
echo -e "\033[44;37m #                                    # \033[0m"
echo -e "\033[44;37m #           Version: 1.0             # \033[0m"
echo -e "\033[44;37m ###################################### \033[0m"
echo ""
echo -e "VPN service is installed, your username is\033[32m OTW\033[0m, password is\033[32m ${pass}\033[0m"
echo ""
