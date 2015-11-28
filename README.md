在CentOS 6 （32/64位）安装VPN PPTP Server

准备步骤： yum update -y

1.VPN PPTP Server下载一键安装脚本

# wget centos6_pptpd.sh

运行脚本
# chmod +x centos6_pptpd.sh
# ./centos6_pptpd.sh

然后等待安装完成后 会自动创建一个随机的用户。完成时，脚本会在屏幕上用绿色的字体打印出用户名和密码。



2.添加或者修改用户

方法一（简略）添加用户的方法：
# echo "aaa pptpd bbb *"  >> /etc/ppp/chap-secrets

其中的 aaa 你可以修改为你想要的任意用户名，bbb 可以修改为你想用的任意密码。
注意这些都是英文输入法下的 "" >>    ！

方法二
你可以在这个/etc/ppp/chap-secrets里面添加或者修改用户，格式和上面的一样。下面的命令是用VI打开用户配置文件！
# vi /etc/ppp/chap-secrets

至于vi的操作你要了解一下基本的vi编辑：
http://www.cnblogs.com/itech/archive/2009/04/17/1438439.html

3. Centos6上的VPN客户端配置

  a. 安装必要的包   yum install NetworkManager* -y
  
  b. 打开图形化界面 System->Preferences->Network Connections
  
  c. 添加VPN，并保证配置一下属性
  
      1) General->Gateway
      
      2) Optional->Username && Password
      
      3) Advanced-->Security and Compressio->"Use Point to Pont encryption(MPPE)"&&"Allow status encryption"

