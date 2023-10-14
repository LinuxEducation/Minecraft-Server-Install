#!/bin/bash

##Autor:    lukas
##Ver:      0.9
##Data:     26.8.2020/15:42
##DC:       [py]lukas
##GitHub:   https://github.com/LinuxEducation
##YouTube:  https://www.youtube.com/channel/UC_tx8bMzfLU-hDml6PzSTqg

echo -e "\E[34mSkrypt nie działa? Potrzebujesz pomocy?\E[0m" \
        '\nDisCord: [py]lukas\nemail:   linuxieducation@gmail.com\n-> zapoznaj się z pojeciami: root, sudo, sudo su <-\n'

eula_accept()
{
    echo -e "\n\E[32mWarunki korzystania z Minecraft:\E[0m" \
            '\nPobierając dowolne oprogramowanie ze strony minecraft.net, wyrażasz zgodę na warunki korzystania z Minecraft i zasady polityki prywatności' \
            '\nEULA (https://account.mojang.com/documents/minecraft_eula)'
        
        read -p 'Wyrażasz zgodę na powyższe warunki? [T/n]: ' odp
        case $odp in
            [tTyY1]) echo 'eula=true' > eula.txt
                     ;;
            *      ) exit 1
                     ;;
        esac
}

which java &> /dev/null \
    &&  { echo -e '\E[32mJavaJDK:  zainstalowana:\E[0m'; $(java -version); }  \
    ||  { echo -e '\E[32mInstalacja JavaJDK:\E[0m'; apt-get install -y openjdk-19-jre-headless || exit 1; }
    

if [ ! -f eula.txt ] ;
then
    eula_accept
else
    grep -q 'eula=false' < eula.txt \
    && eula_accept
fi


if [ ! -f URL_Minecraft ] ; then

cat <<EOF > URL_Minecraft
##Adresy mogą ulec zmianie przez co skrypt nie będzie działał prawidłowo.
##Silnik Serwera: Vanila
https://launcher.mojang.com/v1/objects/a412fd69db1f81db3f511c1463fd304675244077/server.jar
##Silnik Serwera: Spigot: 1.20.2
https://download.getbukkit.org/spigot/spigot-1.20.2.jar
##Silnik Serwera: Paper: 1.20.2
https://api.papermc.io/v2/projects/paper/versions/1.20.2/builds/234/downloads/paper-1.20.2-234.jar
EOF

    echo -e "\n\E[32mPlik URL_Minecraft utworzony:\E[0m"
    cat URL_Minecraft

else
    echo -e "\n\E[32mPlik URL_Minecraft: Istnieje\E[0m"
    cat URL_Minecraft
fi


ls [spf]*.jar &> /dev/null \
    || { echo -e "\n\E[32mPobieranie Silnika MC:\E[0m"; \
         wget $(sed -e '/^#/d' < URL_Minecraft)
       }


echo -e "\n\E[32mGenerowanie skryptu startowego:\E[0m"

for engine_mc in ls [SsPpFf]*.jar
do

    case "$engine_mc" in
        server*.jar ) echo -e "Silnik Serwera:\E[1;34m Vanila\E[0m \E[34m[$engine_mc]\E[0m  \E[31mSilnik podstawowy -bez pluginów\E[0m";;
        spigot*.jar ) echo -e "Silnik Serwera:\E[1;34m Spigot\E[0m \E[34m[$engine_mc]\E[0m  \E[31mSzybkość, wydajność, skrypty, pluginy\E[0m";;
        paper*.jar  ) echo -e "Silnik Serwera:\E[1;34m Paper\E[0m  \E[34m[$engine_mc]\E[0m  \E[31mLepsza wersja Spigota\E[0m";;
    esac
    
done
    
    
while true
do

    read -p 'Wybierz silnik Twojego Serwera: ' engine_mc

    case $engine_mc in

        [Vv]anila)  engine_real_name=$(ls [Ss]erver*.jar)
                    echo "screen -S Serwer_Vanila java -Xms1024M -Xmx1024M -jar $engine_real_name nqui" > start.sh
                    chmod +x start.sh
                    break
                    ;;
        [Ss]pigot)  engine_real_name=$(ls [Ss]pigot*.jar)
                    echo "screen -S Serwer_Spigot java -Xms1024M -Xmx1024M -jar $engine_real_name nqui" > start.sh
                    chmod +x start.sh
                    break
                    ;; 
         [Pp]aper)  engine_real_name=$(ls [Pp]aper*.jar)
                    echo "screen -S Serwer_Paper java -Xms1024M -Xmx1024M -jar $engine_real_name nqui" > start.sh
                    chmod +x start.sh
                    break
                    ;;
        *         ) echo "Plik o naziwe: $engine_mc nie istnieje. Popraw!"
                    continue
                    ;;
    esac

done
    

echo -e "\n\E[32mUtworzono skrypt startowy:\E[0m"
echo -e 'start.sh dla silnika:' $engine_mc

echo -e "\n\E[34mInstalacja zakończona poyślnie!\E[0m"
exit 0
