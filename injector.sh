#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


function getRom() {
    echo Drag and drop the ROM file into the terminal window,
    echo then press Enter.
    read romFile
    #check if file exists
    if [ -f "$romFile" ];
    then
        echo Thank you!
        echo Do not delete or move the rom file until the script is finished.
        echo
        echo
    else
        echo The ROM file provided does not exist,
        echo or I could not get to it for some reason.
        exit
    fi
}

function getBase(){
    echo Please copy and paste the TitleID of the base into the terminal window.
    echo You can check which base you need on the compatibility list
    read titleId
    echo
    echo Now, Please copy and paste the TitleKEY of the base into the terminal window.
    echo This is not the same as the titleID.
    read titleKey
    clear
    echo Thank you,
    echo I will now attempt to download the base.
    echo You will need an internet connection for this.
    cd $DIR
    if [ -f "./tools/jnustool/config" ];
    then
        echo JNUStool config found!
    else
        echo
        echo But first we need the WiiU common key.
        echo Please copy and paste the Wii U common key into the terminal window.
        echo You will only need to do this once
        read commonkey
        touch ./tools/jnustool/config
        chmod +x ./tools/jnustool/config
        echo http://ccs.cdn.wup.shop.nintendo.net/ccs/download >> ./tools/jnustool/config
        echo $commonkey >> ./tools/jnustool/config
        echo updatetitles.csv >> ./tools/jnustool/config
        echo https://tagaya.wup.shop.nintendo.net/tagaya/versionlist/EUR/EU/latest_version >> ./tools/jnustool/config
        echo https://tagaya-wup.cdn.nintendo.net/tagaya/versionlist/EUR/EU/list/%d.versionlist >> ./tools/jnustool/config
    fi

    cd ./tools/jnustool/
    java -jar JNUSTool.jar $titleId $titleKey -file /code/.*
    java -jar JNUSTool.jar $titleId $titleKey -file /content/.*
    java -jar JNUSTool.jar $titleId $titleKey -file /meta/.*

    cd $DIR
    mv ./tools/jnustool/*/ ./base
}

function getMeta(){
    newId=$( LC_ALL=C tr -dc '0-9' </dev/urandom | head -c 8 )
    clear
    echo What is the name of your game?
    read name

}

function superNintendo(){
    clear
    getRom
    getBase
    getMeta



}

clear
echo Hello! Welcome to the injector script!
echo We can only inject SNES games right now,
echo but more injectors are coming in the future!

PS3='Pick a console: '
options=("SNES" "Exit")
select opt in "${options[@]}"
do
    case $opt in
        "SNES")
            superNintendo
            break
            ;;
        "Exit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
