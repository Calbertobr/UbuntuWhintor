#!/bin/bash

##########################################################################################################
#
#	DATA:			09 Novembro de 2015
# 	Release:	I	15 Maio     de 2019
#	Release:	II	13 Maio     de 2021
#	Release:	III	07 Agosto   de 2024		Incluido pacotes opem vpn e file conf em /etc/OpenSS
#
#
#	POR:			Carlos Alberto			calbertobr@gmail.com
#
#	MOTIVO			Instalacao do linux nas estacoes de trabalho.
#
#	ESPECIFICACAO:		Uso Somente para SunSpecial Caracteristicas Internas.
#
#	Release II	Adequação ubuntu 20
#		Nesta versão os diretorios bin são alias.
#
#
###########################################################################################################
clear
# if [ "$2" != "Teste" ]
# then
#     export CodFil=1
# fi
# -----------------------------------------------------------------------------------------------------------------
rebo(){
    echo -e "\033[6;31m Reboot em 5 segundos \033[0m\n\n\n"
    rm -rf .bk >>/dev/null
    for t in 5 4 3 2 1 0
    do
        sleep 1
        echo -e "  \033[6;3"$t"m $t \033[m  "
    done
    reboot
}
rm -f /etc/ConfigInicialMachine
# -----------------------------------------------------------------------------------------------------------------
Trace( ){
    N=$1
    Msgt=''
    for ct in `seq 1 $N`
    do
        Msgt=$Msgt'-'
    done
    echo -e "\033[31m#$Msgt#\033[m"
}
# -----------------------------------------------------------------------------------------------------------------
Mensagem( ){
    StrLen=80
    Msg=$1
    let Len=$StrLen-${#Msg}-4
    let Len=$Len/2
    Msgt=`Trace $StrLen`
    Msgd=`Trace $Len `
    echo -e "\033[32m\n$Msgt\n$Msgd $Msg $Msgd\n$Msgt\n\033[m\n"
}
# -----------------------------------------------------------------------------------------------------------------
#
#
# -----------------------------------------------------------------------------------------------------------------
if [ ! -d /.bk ]
then
    mkdir /.bk
fi
## Determinar Variaveis, Diretorios, Arrays
    SiteDown=$1
    Filiais=( "00-Nvl" "01-MTR" "02-Mig" "03-MTF" "04-VRY" "05-Nvl" "06-IMP" "07-MIL" "08-BOR" "09-HS" "10-Nvl" "11-ITA" "12-" "13-CMD" "14-PER" "15-ESQ" "16-Nvl" "17-Nvl" "18-FOR" )
     Deptos=( "0-Svr" "1-Svr" "2-Net" "3-Imp" "4-Rel" "5-Sat" "6-Nvl" "7-Nvl" "8-Nvl" "9-Nvl" "10-TI" "11-Pes" "12-Cnt" "13-Vnd" "14-Mkt" "15-Dir" "16-Nvl" "17-Brd" "18-Fin" "19-Blc" "20-Cax" "21-Fis" "22-Fat" "23-Exp" "24-Sep" "25-Ass" "26-Rec" )
    NetWans=( "SS-TEC#M@meluco33" "SS-LOG#M@meluco33" "SS-MKT#M@meluco33" "SS-COM#M@meluco33" "CMD001#M@meluco33" "CMD002#M@meluco33" "CMD003#M@meluco33" "CMD004#M@meluco33" "CMD005#M@meluco33" "CMD006#M@meluco33" "CMD007#M@meluco33" "CMD008#M@meluco33" )
## Verifica configuracao do source list.
##----------------------------------------------------------------------------------------------------------------------------
ConfigSources(){
    Vetor=`cat /etc/apt/sources.list | grep "br."`
    if [ "$Vetor" != "" ]
    then
        cat /etc/apt/sources.list >/etc/apt/sources.list.bk ; sed 's/br.//g' /etc/apt/sources.list.bk >/etc/apt/sources.list
        systemctl daemon-reload
        apt update >>/dev/null 
        apt purge libreoffice-* -y >>/dev/null 
    fi
}

## C O N F I G U R A   R E D E
##----------------------------------------------------------------------------------------------------------------------------
ConfiguraRede(){
    unset CodDep CodFil Dhcp
    while [ "$Ok" != "S" ]
    do  
    clear
        Mensagem  "Qual filial a ser instalada esta Maquina ?"
        for CodFil in 1 3 4 6 7 8 9 11 13 14 15 18
        do
            echo -e "		${Filiais[$CodFil]} "
        done
        read CodFil
    clear
        Mensagem "Qual Departamento ?" S " "
        for CodDep in 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28
        do
            echo -e "		${Deptos[$CodDep]} "
        done
        read CodDep
        HostName=`echo ${Deptos[$CodDep]}  | awk -F\- '{ print $2 }'`
        case ${#FinalIp} in
            1)
                HostName=$HostName"00$FinalIp" ;;
            2)
                HostName=$HostName"0$FinalIp" ;;
            *)
                HostName=$HostName"$FinalIp" ;;
        esac
    clear
        Mensagem "Esta Filial usa DHCP ? S/N " S ""
        read Dhcp
        if [ "$Dhcp" == "S" ] || [ "$Dhcp" == "s" ]
        then
            Dhcp='S'
        else
            Dhcp='N'
    clear
            Mensagem "Qual bloco final do Ip a ser atribuido de 1 a 253 ?" S " "
            read FinalIp
        fi
    clear
        Mensagem "Favor digitar login do usuario." S ""
        read LoginTerm
        HostName="$HostName."`echo ${Filiais[$CodFil]} | awk -F\- '{ print $2 }'`".sstec.net.br"
    clear
        Mensagem "Dados abaixo estao Corretos."
        echo -e "\n
                Filial\t\t\t\t ${Filiais[$CodFil]} \n
                Departamento\t\t\t ${Deptos[$CodDep]} \n
                IP\t\t\t\t 10.$CodFil.$CodDep.$FinalIp \n
                Hostname\t\t\t $HostName \n\n
                Usa DHCP\t\t\t $Dhcp \n\n
                Login Rdesktop\t\t\t $LoginTerm \n\n
                Correto ? (s/n) \n
        "
        read Result
        if [ "$Result" == "S" ] || [ "$Result" == "s" ]
        then
            Ok='S'
        else
            CodFil=""
            CodDep=""
        fi
        echo "UserLogin:$LoginTerm">>/etc/ConfigInicialMachine
        echo "Rede:$CodFil:$CodDep">>/etc/ConfigInicialMachine
    done
    H=`hostname`
    sed -i 's/'$H'/'$HostName'/g' /etc/hostname
    sed -i 's/'$H'/'$HostName'/g' /etc/hosts
    hostname $HostName
    ConfigMunin="$SiteDown/amoeba.php?IP=10.$CodFil.$CodDep.$FinalIp&NAME=$HostName"
    rm -f /etc/netplan/*.yaml
    if [ "$BB" == "N" ]
    then
        echo -e "network:
    version: 2
    renderer: NetworkManager
    ethernets:
        eth0:
            dhcp4: false
            addresses: [ 10.$CodFil.$CodDep.$FinalIp/16 ]
            nameservers:
                addresses: [ 10.$CodFil.0.1, 8.8.8.8 ]
            gateway4: 10.$CodFil.0.1
">/etc/netplan/eth.yaml
        echo -e "network:
    version: 2
    renderer: NetworkManager
    wifis:
        wlan0:
            dhcp4: true
            access-points:
">/etc/netplan/wlan.yaml
    else
        echo -e "network:
    version: 2
    renderer: NetworkManager
    ethernets:
        eth0:
            dhcp4: true
">/etc/netplan/eth0.yaml

        echo -e "network:
    version: 2
    renderer: NetworkManager
    wifis:
        wlan0:
            dhcp4: true
            access-points:
">/etc/netplan/wlan.yaml
    fi
    for Net in ${NetWans[@]}
    do
        Rede=`echo $Net | awk -F\#  '{ print $1 }' `
        Senha=`echo $Net | awk -F\#  '{ print $2 }' `
        echo -e "                \"$Rede\":
                    password: \"$Senha\"">>/etc/netplan/wlan.yaml
    done
}

## Install Packages SunSpecial
##----------------------------------------------------------------------------------------------------------------------------
InstallSun() {
    SunOk=`dpkg -l | grep sunspecialprograms`
    if [ "$SunOk" == "" ]
    then
        dpkg --add-architecture i386
        apt update 
        apt upgrade -y        
        apt install wine wine32-preloader -y
        # removidos : ocsinventory-agent        
        Trace 80
        package="mc ssh-import-id gtk2-engines openssh-server nfs-kernel-server nfs-common munin-node rdesktop ntp gnome-shell-extensions libcanberra-gtk-module nautilus language-pack-pt language-pack-gnome-pt gnome-control-center pdftk rar unrar unace zip p7zip-rar sharutils mpack arj cabextract file-roller uudeview network-manager-openvpn network-manager-openvpn-gnome unzip p7zip-full language-pack-gnome-pt-base libnss3-tools"
        apt install $package -y     
        apt install -f -y
        Trace 80
        wget http://$SiteDown/Linux64/Packages/NLinuxPackages.tar.gz
        tar xvfz NLinuxPackages.tar.gz -C /var/cache/apt/archives/
        rm -f NLinuxPackages.tar.gz
        Check=`dpkg -l | grep google-chrome-stable -c`
        #----------------------------------------------------------------------------------------------------------------------
        if [ $Check -eq 0 ]
        then
            echo "-- $Check"
            wget -P /var/cache/apt/archives/ https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        fi
        Check=`dpkg -l | grep teamviewer -c`
        #----------------------------------------------------------------------------------------------------------------------
        if [ $Check -eq 0 ]
        then
            echo "-- $Check"
            wget -P /var/cache/apt/archives/ https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
        fi
        #----------------------------------------------------------------------------------------------------------------------
        for package in `ls /var/cache/apt/archives/ | grep deb`
        do
            dpkg -i /var/cache/apt/archives/$package
            apt install -f -y
        done
        Check=`systemctl status teamviewerd.service | grep Active | grep active | grep running -c`
        if [ $Check -ne 1 ]
        then
            #echo -e "[int32] EulaAccepted = 1\n[int32] EulaAcceptedRevision = 6\n[int32] General_DirectLAN = 1\n[int32] Security_PasswordStrength = 1"
            rm -f /etc/teamviewer/global.conf
            Trace 80
            Path="/etc/gdm3"
            for Fil in `ls $Path | grep conf$ `
            do
                Lin=`cat -n $Path/$Fil | grep WaylandEnable | awk {' print \$1 '}`
                if [ "$Lin" != "" ]
                then
                    run="sed -i  "$Lin"d $Path/$Fil "
                    echo $run
                    run="sed -i "$Lin"i\WaylandEnable=false $Path/$Fil"
                    $run
                fi
            done
            teamviewer --daemon stop
            teamviewer --passwd \&nbspawk577
            teamviewer license accept
            teamviewer --daemon restart
            teamviewer --daemon enable
            Trace 80
        fi
        apt update
        apt upgrade -y
        apt autoremove -y

        sed -i 's/NomeMaquinaLocal/'$HostName'/g' /etc/munin/munin-node.conf >>/dev/null
        #echo -e "server=$SiteDown:17080\n">/etc/ocsinventory/ocsinventory-agent.cfg
    fi
}

## Altera Senha Root para login remoto
##----------------------------------------------------------------------------------------------------------------------------
PasswordRoot() {
    echo "PasswordRoot"
    passwd root <<eof
&nbspawk577
&nbspawk577
eof
    passwd master <<eof
&nbspawk577
&nbspawk577
eof
    ConfigMunin=$ConfigMunin\&IdTeam=`teamviewer --info | grep 'TeamViewer ID:' | tr -d [' '] | awk -F\:  '{ print $2 }' | tr -d ['a-z']`
    wget $ConfigMunin
    rm -f *amoeba*
    sed -i 's/#PermitRootLogin/PermitRootLogin/g' etc/ssh/sshd_config
    sed -i 's/prohibit-password/yes/g' /etc/ssh/sshd_config
    systemctl restart ssh.service
}

## Limpa pacotes quebrados
##----------------------------------------------------------------------------------------------------------------------------
CleanPackages() {
    for a in "gnome-initial-setup snapd cups-browsed gnome-online-accounts aisleriot gnome-mahjongg gnome-mines gnome-sudoku libgnome-games-support-1-3:amd64 libgnome-games-support-common gnome-software gnome-software-plugin-snap snapd"
    do
        apt purge $a -y
    done
    apt purge -y `dpkg -l | grep ^rc | awk -F\  '{ print $2 }' | tr ['\n'] [' ']`
    apt autoremove -y
    apt upgrade -y
    apt autoclean
    apt autoremove -y
    apt install -f
}

## Alteração de arquivos de configuração
##----------------------------------------------------------------------------------------------------------------------------
AlterFilesConf(){
    sed 's/^BrowseLocalProtocols.*$/BrowseLocalProtocols\ none/' -i /etc/cups/cupsd.conf
    sed -i 's/UserTerminal/'$LoginTerm'/g' /home/$LoginTerm/.local/share/applications/Winthor.desktop
    sed -i 's/UserTerminal/'$LoginTerm'/g' /home/$LoginTerm/.local/share/applications/WinthorRemoto.desktop
    sed -i 's/UserTerminal/'$LoginTerm'/g' /home/$LoginTerm/.local/share/applications/WinthorRemotoLocal.desktop
    cat /etc/ntpsec/ntp.conf  | grep ^pool -v | grep ^server -v >/var/ntp.conf
    echo -e "# Severs Hora legal Brasil \n server a.st1.ntp.br \n server b.st1.ntp.br \n server c.st1.ntp.br \n server d.st1.ntp.br \n\n server a.ntp.br\n server b.ntp.br\n server c.ntp.br \n\n server gps.ntp.br \n ">>/var/ntp.conf
    cat /var/ntp.conf >/etc/ntpsec/ntp.conf
    systemctl restart ntp
    ntpq -p
}
## Loop de instalação
if [ "$2" != "" ]
then
    CodFil=1
else
    for run in ConfigSources ConfiguraRede InstallSun PasswordRoot CleanPackages AlterFilesConf
    do
#        Mensagem "Iniciando $run."
        $run 
        Mensagem " Processo $run Finalizado."
    done
fi


echo -e "\n\n\n\n\n\n\n\n

#####################################################################################

    I n s t a l a ç ã o   T e r m i n a d a  

    Reboot this machine to continue

####################################################################################\n
"
rebo
