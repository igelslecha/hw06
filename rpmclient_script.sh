#Script for clients vm
#Remoute all old repo
#rm -f /etc/yum.repos.d/*
#Added new repo
touch /etc/yum.repos.d/otus.repo
echo "[otus]
name=otus-linux
baseurl=http://192.168.50.10/repo
gpgcheck=0
enabled=1" >> /etc/yum.repos.d/otus.repo
#Install Alpine from our repo
yum install -y alpine



