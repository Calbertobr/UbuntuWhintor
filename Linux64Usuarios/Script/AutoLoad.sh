#!/bin/bash

clear
rm AutoLoad.sh -f >>/dev/null
PWD_NOW=`pwd`
cd /
if [ "$1" != "" ]
then
    rm -f /$1.* >>/dev/null
fi
apt clean

# -----------------------------------------------------------------------------------------------------------------
Trace( ){
    N=$1
    Msgt=''
    for ct in `seq 1 $N`
    do
        Msgt=$Msgt'-'
    done
    echo $Msgt
}

# -----------------------------------------------------------------------------------------------------------------
Mensagem( ){
    StrLen=60
    Msg=$1
    let Len=$StrLen-${#Msg}-2
    let Len=$Len/2
    Msgt=`Trace $StrLen`
    Msgd=`Trace $Len `
    echo -e "\033[32m\n#$Msgt#\n#$Msgd $Msg $Msgd#\n#$Msgt#\n\033[m\n\tTecla algo para continuar"
    sleep 3
}

# -----------------------------------------------------------------------------------------------------------------
Value=`ping 10.1.0.1 -c1 | grep ttl -c `
if [ $Value -eq 1 ]
then
    Site=Site_Interno
else
    Site=Site_Externo
fi

wget -q $Site/Linux64/AutoLoad.sh >>/dev/null
mv AutoLoad.sh /usr/bin/ -f
chmod 755 /usr/bin/AutoLoad.sh
if [ -f /usr/local/share/proccess/ProccessUpdate.sh ]
then
    wget -q $Site/Linux64/Proccess/ProccessUpdate.sh >>/dev/null
    mv ProccessUpdate.sh /usr/local/share/proccess/ProccessUpdate.sh -f
    chmod 755 /usr/local/share/proccess/ProccessUpdate.sh
else
    mkdir /usr/local/share/proccess
    wget -q $Site/Linux64/Proccess/ProccessUpdate.sh >>/dev/null
    mv ProccessUpdate.sh /usr/local/share/proccess/ProccessUpdate.sh -f
    chmod 755 /usr/local/share/proccess/ProccessUpdate.sh
    echo "[Unit]
Description=Script de atualização
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/usr/local/share/proccess/ProccessUpdate.sh

[Install]
WantedBy=multi-user.target
">/usr/local/share/proccess/Proccess.service
    chmod 644 /usr/local/share/proccess/Proccess.service
    chmod 755 /usr/local/share/proccess/ProccessUpdate.sh
    ln -s /usr/local/share/proccess/Proccess.service /usr/lib/systemd/system/Proccess.service
    systemctl -q daemon-reload
    systemctl -q enable Proccess.service
fi

#--------------------------------------------------------------------------------------------------
if [ -f /etc/winthor-user ]
then
    VersionsInstaladas=`cat /etc/winthor-user | sort | uniq | tr ['\n'] [' '] `
fi

if [ "$1" != "" ]
then
    if [ -f /etc/winthor-user ]
    then
        Vers=`cat /etc/winthor-user | grep $1 `
    fi
    if [ "$Vers" == "$1" ]
    then
    # Clear
        echo -e "

    E S T A   A T U A L I Z A C A O   J A   F O I   I M P L E M E N T A D A.

        "
    else
        if [ "$1" != "" ]
        then
            rm -f /$1.*
        fi
        Local=`pwd`
        if [ "$Local" == "/" ]
        then
            if [ "$1" == "" ]
            then
                VersionAtual=1
                if  [ -f /version.load ]
                then
                    Version=`cat /version.load`
                    if [ $Version -eq $VersionAtual ]
                    then
                        echo "Divergente"
                    else
                        echo Ok.
                    fi
                fi
            else

            clear
            Line
            echo -e "C a r g a   d e   U p d a t e   $1   e s p e c i f i c o."
            Line
                wget $Site/Linux64/Updates/$1.sh >>/dev/null
                echo $1 >>/etc/winthor-user
                . ./$1.sh $Site $2
                echo "
         C o m p l e t o   u p d a t e  $1 "
                rm -f /$1.*
                rm -f AutoLoad.sh
            fi
        else
            echo "


         E s t e   c o m a n d o   d e v e   s e r


            e x e c u t a d o   n a   r a i z .

"
        fi
    fi
else

#    clear
    echo "			$Site

        Opções de instalação


        00 Install Inicial
        01 Correção Munin
        02 Install ocsinventory
    "
fi

cd $PWD_NOW
