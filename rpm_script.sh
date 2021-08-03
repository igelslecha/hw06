#Script for making rpm
#Install utils for making rpm
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils
#Go to home for root
cd ~/
#Download SRPM pack Alpine
wget https://download-ib01.fedoraproject.org/pub/epel/7/SRPMS/Packages/a/alpine-2.24-1.el7.src.rpm
#Install pack and make tree
rpm -i alpine-2.24-1.el7.src.rpm
#Change for installing "automake ilbtool"
sed -i '34 s/#BuildRequires: automake libtool/BuildRequires: automake libtool/' rpmbuild/SPECS/alpine.spec
#Install dependencies
yum-builddep -y rpmbuild/SPECS/alpine.spec
#Make packet
rpmbuild -bb rpmbuild/SPECS/alpine.spec
#Install pocket for checking
yum localinstall -y  rpmbuild/RPMS/x86_64/alpine-2.24-1.el7.x86_64.rpm
#Added new repo for nginx
yum install -y epel-release
#Install nginx
yum install -y nginx
#Start nginx
systemctl start nginx
#Enable autostart nginx
systemctl enable nginx
#Open http in firewall (there firewall is not running)
#firewall-cmd --zone=public --permanent --add-service=http
#Make folder for repo
mkdir /usr/share/nginx/html/repo
#Copy pocket to new folder
cp rpmbuild/RPMS/x86_64/alpine-2.24-1.el7.x86_64.rpm /usr/share/nginx/html/repo
#Started repo
createrepo /usr/share/nginx/html/repo/
#Set NGINX for share our repo
sed -i '/\/usr\/share\/nginx\/html;/a autoindex on;' /etc/nginx/nginx.conf
sed -i '/\/usr\/share\/nginx\/html;/a index        index.html index.htm;' /etc/nginx/nginx.conf
nginx -s reload
#Added new repo to /etc/yum.repos.d
touch /etc/yum.repos.d/otus.repo
echo "[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1" >> /etc/yum.repos.d/otus.repo
