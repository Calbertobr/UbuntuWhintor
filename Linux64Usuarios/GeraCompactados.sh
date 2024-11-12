#!/bin/bash
#    Pacotes_adicionais PacotesCompactados
clear
IP_SITE="ServidorWeb"
LOCAL_PATH=`pwd`
PacoteDeb="winthor-user"
StrLenPath=$LOCAL_PATH/$PacoteDeb
## Version
let StrLenPath=${#StrLenPath}+1
Check=`find /opt/Linux64Usuarios/$PacoteDeb/ -mmin -10`
if [ "$Check" !=  "" ]
then
    let Version=`cat $LOCAL_PATH/$PacoteDeb/.ver`+1
    chmod 0755 $LOCAL_PATH/$PacoteDeb/DEBIAN/*
    echo -e "Package: $PacoteDeb
Version: $Version
Architecture: amd64
Maintainer: Winthor Linux <calbertobr@gmail.com>
Installed-Size: 356732
Pre-Depends: dpkg (>= 1.14.0)
Depends: wine, wine32-preloader
Provides: Erp
Section: Erp Winthor
Priority:
Description: Instal Winthor on Linux
">$PacoteDeb/DEBIAN/control
    if [ ! -d $LOCAL_PATH/comp ]
    then
        mkdir $LOCAL_PATH/comp
    fi
    rm LinuxPackages/$PacoteDeb*.deb -f
    echo -e "\n\n\t\t-- \033[31mAguarde\033[m --"
    find $LOCAL_PATH/$PacoteDeb/ -type f | cut -c$StrLenPath-300 | grep ^/DEBIAN -v | sort >$LOCAL_PATH/$PacoteDeb/DEBIAN/conffiles
    dpkg-deb -b "$PacoteDeb" $LOCAL_PATH/comp/$PacoteDeb.$Version.deb >>/dev/null
    chmod 0666 $LOCAL_PATH/$PacoteDeb/DEBIAN/*
    echo $Version>$LOCAL_PATH/$PacoteDeb/.ver
    tar cvfz $LOCAL_PATH/NLinuxPackages.tar.gz -C $LOCAL_PATH/comp/ . >>/dev/null
    rsync -avzhe ssh --progress $LOCAL_PATH/NLinuxPackages.tar.gz root@$IP_SITE:/data/FILES/Linux_64/Packages/ >>/dev/null
    rm -rf $LOCAL_PATH/NLinuxPackages.tar.gz $LOCAL_PATH/comp 
    echo -e "\n\n\n\t\033[31m Pacote $PacoteDeb Ver $Version compilado com sucesso. \033[m\n\n\n "
else
    echo -e "\n\n\n\t Pacote Whintor-Ubuntu sem alteração.\n\n\n "
fi
echo "Updates OK"
rsync -avzhe ssh --progress $LOCAL_PATH/Updates   root@$IP_SITE:/data/FILES/Linux_64 >>/dev/null

echo "Updates OK"
rsync -avzhe ssh --progress $LOCAL_PATH/Proccess   root@$IP_SITE:/data/FILES/Linux_64 >>/dev/null

echo "Scripts OK"
rsync -avzhe ssh --progress $LOCAL_PATH/Script/   root@$IP_SITE:/data/FILES/Linux_64 >>/dev/null

echo "Pakages OK"
rsync -avzhe ssh --progress $LOCAL_PATH/$PacoteDeb/var/authorized_keys root@$IP_SITE:/data/FILES/Linux_64/Packages/ >>/dev/null

read call


