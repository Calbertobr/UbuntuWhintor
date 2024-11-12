#!/bin/bash
if [ ! -d ~/Etiqueta ]
then
    mkdir ~/Etiqueta
fi
Check=`cat ~/Etiqueta/.process`
kill -9 $Check
echo $$>~/Etiqueta/.process
    while [ 1 == 1 ]
    do
#        rm -f ~/Etiqueta/* 
#        rm -f /opt/Zvp/TempDM/*
        ##########################
        if [ -f ~/Etiqueta/*.zvp  ]
        then
            for a in ` ls ~/Etiqueta/*.zvp`
            do
                echo "/opt/Zvp/ZVP64 $a "
                /opt/Zvp/ZVP64 $a
                rm -f $a
            done
        fi
        ##########################
    done
