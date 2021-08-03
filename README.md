# hw06
**Решил взять за основу alpine**

**Устанавливаю программы для работы с пакетами**
```[root@packages ~]# yum install -y \
redhat-lsb-core \
wget \
rpmdevtools \
rpm-build \
createrepo \
yum-utils
```
**Скачиваю пакет с выбранного мной репозитория**

```[root@rpms ~]# wget https://download-ib01.fedoraproject.org/pub/epel/7/SRPMS/Packages/a/alpine-2.24-1.el7.src.rpm```

**Попытался распаковать**

```[root@rpms ~]# rpm -i alpine-2.24-1.el7.src.rpm
warning: alpine-2.24-1.el7.src.rpm: Header V4 RSA/SHA256 Signature, key ID 352c64e5: NOKEY
warning: user mockbuild does not exist - using root
warning: group mock does not exist - using root
warning: user mockbuild does not exist - using root
warning: group mock does not exist - using root
warning: user mockbuild does not exist - using root
warning: group mock does not exist - using root
warning: user mockbuild does not exist - using root
warning: group mock does not exist - using root
warning: user mockbuild does not exist - using root
warning: group mock does not exist - using root

```
**Заругался на ключи но распаковал**

**Раскоментировал мод для напримера
**
```sed -i '34 s/#BuildRequires: automake libtool/BuildRequires: automake libtool/' rpmbuild/SPECS/alpine.spec```
**Установил зависимости
**
```[root@rpms ~]# yum-builddep rpmbuild/SPECS/alpine.spec
Failed to set locale, defaulting to C
Loaded plugins: fastestmirror
Enabling base-source repository
Enabling extras-source repository
Enabling updates-source repository
Loading mirror speeds from cached hostfile
 * base: mirror.linux-ia64.org
 * extras: mirror.linux-ia64.org
 * updates: mirror.docker.ru
...
Dependency Updated:
  e2fsprogs.x86_64 0:1.42.9-19.el7     e2fsprogs-libs.x86_64 0:1.42.9-19.el7
  krb5-libs.x86_64 0:1.15.1-50.el7     libcom_err.x86_64 0:1.42.9-19.el7
  libss.x86_64 0:1.42.9-19.el7         openldap.x86_64 0:2.4.44-23.el7_9
  openssl.x86_64 1:1.0.2k-21.el7_9     openssl-libs.x86_64 1:1.0.2k-21.el7_9
  zlib.x86_64 0:1.2.7-19.el7_9

Complete!

```
**Сборка RPM пакета
**
```[root@rpms ~]# rpmbuild -bb rpmbuild/SPECS/alpine.spec
...
+ umask 022
+ cd /root/rpmbuild/BUILD
+ cd alpine-2.24
+ /usr/bin/rm -rf /root/rpmbuild/BUILDROOT/alpine-2.24-1.el7.x86_64
+ exit 0
```
**Проверяем, что пакеты создались
**
```[root@rpms ~]# ll rpmbuild/RPMS/x86_64/
total 8880
-rw-r--r--. 1 root root 2620552 Jul 18 14:46 alpine-2.24-1.el7.x86_64.rpm
-rw-r--r--. 1 root root 6470828 Jul 18 14:46 alpine-debuginfo-2.24-1.el7.x86_64.rpm
```
**Устанваливаем пакет локально для проверки
**
```[root@rpms ~]# yum localinstall -y rpmbuild/RPMS/x86_64/alpine-2.24-1.el7.x86_64.rpm
...
Installed:
  alpine.x86_64 0:2.24-1.el7

Dependency Installed:
  mailcap.noarch 0:2.1.41-2.el7

Complete!
```
**Проверяем
**
```[root@rpms ~]# alpine -v
Alpine 2.24 (LRH 510 2020-10-10) built Sun Jul 18 14:42:42 UTC 2021 on rpms, using patchlevel VERSION=1 created on Sat Oct 10 00:37:40 MDT 2020.
Alpine was built with the following options:
CFLAGS=-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic
LDFLAGS=-Wl,-z,relro
./configure --build=x86_64-redhat-linux-gnu --host=x86_64-redhat-linux-gnu \
  --program-prefix= --disable-dependency-tracking --prefix=/usr \
  --exec-prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin \
  --sysconfdir=/etc --datadir=/usr/share --includedir=/usr/include \
  --libdir=/usr/lib64 --libexecdir=/usr/libexec --localstatedir=/var \
  --sharedstatedir=/var/lib --mandir=/usr/share/man \
  --infodir=/usr/share/info --enable-debug=no --without-tcl \
  --with-c-client-target=lfd --with-smtp-msa=/usr/sbin/sendmail \
  --with-npa=/usr/bin/inews --with-passfile=.alpine.passfile \
  --with-simple-spellcheck=hunspell --with-interactive-spellcheck=hunspell \
  --with-system-pinerc=/etc/pine.conf \
  --with-system-fixed-pinerc=/etc/pine.conf.fixed \
  build_alias=x86_64-redhat-linux-gnu host_alias=x86_64-redhat-linux-gnu
```
** Добавляю репозиторий для NGINX
**
```[root@rpms ~]# yum install epel-release```
**Устанавливаю NGINX
**
```[root@rpms ~]# yum install nginx```
**Запускаю NGINX и добавляю автозагрузку
**
```[root@rpms ~]# systemctl start nginx 
[root@rpms ~]# systemctl enable nginx
```
**Создаём папку для репозитория
**
```[root@rpms ~]# mkdir /usr/share/nginx/html/repo```
**Копируем пакет в созданную папку
**
```[root@rpms ~]# cp rpmbuild/RPMS/x86_64/alpine-2.24-1.el7.x86_64.rpm /usr/share/nginx/html/repo```
**Инициализируем репозиторий**
```[root@rpms ~]# createrepo /usr/share/nginx/html/repo/
Spawning worker 0 with 1 pkgs
Workers Finished
Saving Primary metadata
Saving file lists metadata
Saving other metadata
Generating sqlite DBs
Sqlite DBs complete
```
**Добавляем настройки в конфигурационный файл NGINX**
```[root@rpms ~]# sed -i '/\/usr\/share\/nginx\/html;/a autoindex on;' /etc/nginx/nginx.conf
[root@rpms ~]# sed -i '/\/usr/share/nginx/html;/a index        index.html index.htm;' /etc/nginx/nginx.conf
```
**Перезгружаем NGINX**
```[root@rpms ~]# nginx -s reload```
**Добавляем в репозиторий**
```touch /etc/yum.repos.d/otus.repo
echo "[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1" >> /etc/yum.repos.d/otus.repo
```
**Проверяем**
```[root@rpms ~]# yum repolist enabled | grep otus
Failed to set locale, defaulting to C
otus                  otus-linux                                              1
```
**На клиентской машине удаляем все репозитории**
#rm -f /etc/yum.repos.d/* 
*Вышла промашка, alpine требует зависимости: mailcap, hunspell, если я закрываю остальные репозитории, то эти программы не подгружаются через мой репозиторий*
**Добавляем наш репозиторий с нашего сервера**
touch /etc/yum.repos.d/otus.repo
echo "[otus]
name=otus-linux
baseurl=http://192.168.50.10/repo
gpgcheck=0
enabled=1" >> /etc/yum.repos.d/otus.repo
**И устанавливаем alpine**
yum install -y alpine
        

