
if [ "$USER" == "user" ]
then
    wine P:\\\SetupWinthor\\\WinThorInstall.exe
    rm -f /home/user/Área\ de\ Trabalho/*
else
    clear
    echo "

    O root não pode executar este arquivo !!!

    "
fi

if [ -d "/home/user/.wine/drive_c/InstantClient/" ]
then
    cp -f /var/tnsnames.ora /home/user/.wine/drive_c/InstantClient/tnsnames.ora
fi
