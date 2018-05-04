#!/bin/bash
#URL: https://github.com/yushangcl/JetbrainsServer
#E-mail: gayhub@live.cn
clear
echo "    ################################################"
echo "    #                                              #"
echo "    #            Build Jetbrains Server            #"
echo "    #             https://blog.itbat.cn            #"
echo "    #                Version 0.1.1                 #"
echo "    ################################################"
#Prepare the installation environment
echo -e ""
echo -e "Prepare the installation environment."
if cat /etc/*-release | grep -Eqi "centos|red hat|redhat"; then
  echo "RPM-based"
  yum -y install git
elif cat /etc/*-release | grep -Eqi "debian|ubuntu|deepin"; then
  echo "Debian-based"
  apt-get -y install git
else
  echo "This release is not supported."
  exit
fi
#Check instruction
if getconf LONG_BIT | grep -Eqi "64"; then
  arch=64
else
  arch=32
fi
#Build Jetbrains Server
git clone https://github.com/yushangcl/JetbrainsServer
if cat /etc/*-release | grep -Eqi "raspbian"; then
  mv JetbrainsServer/binaries/IntelliJIDEALicenseServer_linux_arm jetbrains
else
  if [ "$arch" -eq 32 ]; then
    mv JetbrainsServer/binaries/IntelliJIDEALicenseServer_linux_i386 jetbrains
  else
    mv JetbrainsServer/binaries/IntelliJIDEALicenseServer_linux_amd64 jetbrains
  fi
fi
mv jetbrains /usr/bin/
chmod +x /usr/bin/jetbrains
nohup jetbrains -p 1017 -u Bat.IT > /home/jetbrains.log 2>&1 &
echo -ne '\n@reboot root nohup jetbrains > /home/jetbrains.log 2>&1 &\n\n' >>/etc/crontab
#Cleaning Work
rm -rf JetbrainsServer
#Check jetbrains server status
sleep 1
echo "Check Jetbrains Server status..."
sleep 1
PIDS=`ps -ef |grep jetbrains |grep -v grep | awk '{print $2}'`
if [ "$PIDS" != "" ]; then
  echo "jetbrains server is runing!"
else
  echo "jetbrains server is NOT running!"
fi
