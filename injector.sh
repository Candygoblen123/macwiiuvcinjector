#!/bin/bash
<<<<<<< HEAD
DIR="$(brew --prefix)/Cellar/wiiuinjector/*/bin/"
=======
DIR=/usr/local/Cellar/wiiuinjector/*/bin/
>>>>>>> 29e6a1c740e1b954089dbf2f0f53787ae98a7cec


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
    # Uses JNUSTool to download and decrypt the "base"
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
    rm -rf ./base
    if [ -f "./tools/jnustool/config" ];
    then
        echo "JNUStool config found!"
    else
        # ask for common key on first run, and save it to jnustool config and nuspacker config
        echo
        echo "But first we need the WiiU common key for JNUSTool."
        echo "Please copy and paste the Wii U common key into the terminal window."
        echo "You will only need to do this once (mabye again if something goes wrong)"
        echo "(We will also use this key for nuspacker's encryptKeyWith)"
        read commonkey

        # create and write JNUStool config
        touch ./tools/jnustool/config
        chmod +x ./tools/jnustool/config
        echo http://ccs.cdn.wup.shop.nintendo.net/ccs/download >> ./tools/jnustool/config
        echo $commonkey >> ./tools/jnustool/config
        echo updatetitles.csv >> ./tools/jnustool/config
        echo https://tagaya.wup.shop.nintendo.net/tagaya/versionlist/EUR/EU/latest_version >> ./tools/jnustool/config
        echo https://tagaya-wup.cdn.nintendo.net/tagaya/versionlist/EUR/EU/list/%d.versionlist >> ./tools/jnustool/config

        # create and write nuspacker config
        touch ./tools/nuspacker/encryptKeyWith
        echo $commonkey > ./tools/nuspacker/encryptKeyWith
        chmod +x ./tools/nuspacker/encryptKeyWith
    fi

    # JNUSTool requires the working directory to contain the config
    cd ./tools/jnustool/
    java -jar JNUSTool.jar $titleId $titleKey -file /code/.*
    java -jar JNUSTool.jar $titleId $titleKey -file /content/.*
    java -jar JNUSTool.jar $titleId $titleKey -file /meta/.*

    # Move base out to a easier to get to dir
    cd $DIR
    mv ./tools/jnustool/*/ ./base
}

function getMetaSnes(){
    # Collect meta information from the user and inject it into meta.xml and app.xml
    # Includes collection of the gameId, because SNES games need that for some reason
    newId=$( LC_ALL=C tr -dc '0-9' </dev/urandom | head -c 8 )
    clear
    echo What is the name of your game?
    read name
    cd $DIR
    cd ./base/code/
    gameId=$(echo *.rpx | cut -c 5-8)
    echo $gameId
    cd $DIR

    # Honertly the easiest way to do this, but it creates long script files

    # meta.xml
    echo '<?xml version="1.0" encoding="utf-8"?>
<menu type="complex" access="777">
  <version type="unsignedInt" length="4">32</version>
  <product_code type="string" length="32">WUP-N-'"$gameId"'</product_code>
  <content_platform type="string" length="32">WUP</content_platform>
  <company_code type="string" length="8">0001</company_code>
  <mastering_date type="string" length="32"></mastering_date>
  <logo_type type="unsignedInt" length="4">0</logo_type>
  <app_launch_type type="hexBinary" length="4">00000000</app_launch_type>
  <invisible_flag type="hexBinary" length="4">00000000</invisible_flag>
  <no_managed_flag type="hexBinary" length="4">00000000</no_managed_flag>
  <no_event_log type="hexBinary" length="4">00000000</no_event_log>
  <no_icon_database type="hexBinary" length="4">00000000</no_icon_database>
  <launching_flag type="hexBinary" length="4">00000004</launching_flag>
  <install_flag type="hexBinary" length="4">00000000</install_flag>
  <closing_msg type="unsignedInt" length="4">0</closing_msg>
  <title_version type="unsignedInt" length="4">0</title_version>
  <title_id type="hexBinary" length="8">00050000'"$newId"'</title_id>
  <group_id type="hexBinary" length="4">00001095</group_id>
  <boss_id type="hexBinary" length="8">0000000000000000</boss_id>
  <os_version type="hexBinary" length="8">000500101000400A</os_version>
  <app_size type="hexBinary" length="8">0000000000000000</app_size>
  <common_save_size type="hexBinary" length="8">0000000000000000</common_save_size>
  <account_save_size type="hexBinary" length="8">0000000000600000</account_save_size>
  <common_boss_size type="hexBinary" length="8">0000000000000000</common_boss_size>
  <account_boss_size type="hexBinary" length="8">0000000000000000</account_boss_size>
  <save_no_rollback type="unsignedInt" length="4">0</save_no_rollback>
  <join_game_id type="hexBinary" length="4">00000000</join_game_id>
  <join_game_mode_mask type="hexBinary" length="8">0000000000000000</join_game_mode_mask>
  <bg_daemon_enable type="unsignedInt" length="4">1</bg_daemon_enable>
  <olv_accesskey type="unsignedInt" length="4">1831524951</olv_accesskey>
  <wood_tin type="unsignedInt" length="4">0</wood_tin>
  <e_manual type="unsignedInt" length="4">1</e_manual>
  <e_manual_version type="unsignedInt" length="4">0</e_manual_version>
  <region type="hexBinary" length="4">00000002</region>
  <pc_cero type="unsignedInt" length="4">128</pc_cero>
  <pc_esrb type="unsignedInt" length="4">6</pc_esrb>
  <pc_bbfc type="unsignedInt" length="4">192</pc_bbfc>
  <pc_usk type="unsignedInt" length="4">128</pc_usk>
  <pc_pegi_gen type="unsignedInt" length="4">128</pc_pegi_gen>
  <pc_pegi_fin type="unsignedInt" length="4">192</pc_pegi_fin>
  <pc_pegi_prt type="unsignedInt" length="4">128</pc_pegi_prt>
  <pc_pegi_bbfc type="unsignedInt" length="4">128</pc_pegi_bbfc>
  <pc_cob type="unsignedInt" length="4">128</pc_cob>
  <pc_grb type="unsignedInt" length="4">128</pc_grb>
  <pc_cgsrr type="unsignedInt" length="4">128</pc_cgsrr>
  <pc_oflc type="unsignedInt" length="4">128</pc_oflc>
  <pc_reserved0 type="unsignedInt" length="4">192</pc_reserved0>
  <pc_reserved1 type="unsignedInt" length="4">192</pc_reserved1>
  <pc_reserved2 type="unsignedInt" length="4">192</pc_reserved2>
  <pc_reserved3 type="unsignedInt" length="4">192</pc_reserved3>
  <ext_dev_nunchaku type="unsignedInt" length="4">1</ext_dev_nunchaku>
  <ext_dev_classic type="unsignedInt" length="4">1</ext_dev_classic>
  <ext_dev_urcc type="unsignedInt" length="4">1</ext_dev_urcc>
  <ext_dev_board type="unsignedInt" length="4">0</ext_dev_board>
  <ext_dev_usb_keyboard type="unsignedInt" length="4">0</ext_dev_usb_keyboard>
  <ext_dev_etc type="unsignedInt" length="4">0</ext_dev_etc>
  <ext_dev_etc_name type="string" length="512"></ext_dev_etc_name>
  <eula_version type="unsignedInt" length="4">0</eula_version>
  <drc_use type="unsignedInt" length="4">1</drc_use>
  <network_use type="unsignedInt" length="4">0</network_use>
  <online_account_use type="unsignedInt" length="4">0</online_account_use>
  <direct_boot type="unsignedInt" length="4">0</direct_boot>
  <reserved_flag0 type="hexBinary" length="4">00020002</reserved_flag0>
  <reserved_flag1 type="hexBinary" length="4">00000000</reserved_flag1>
  <reserved_flag2 type="hexBinary" length="4">00000000</reserved_flag2>
  <reserved_flag3 type="hexBinary" length="4">00000000</reserved_flag3>
  <reserved_flag4 type="hexBinary" length="4">00000000</reserved_flag4>
  <reserved_flag5 type="hexBinary" length="4">00000000</reserved_flag5>
  <reserved_flag6 type="hexBinary" length="4">00000000</reserved_flag6>
  <reserved_flag7 type="hexBinary" length="4">00000000</reserved_flag7>
  <longname_ja type="string" length="512">'"$name"'</longname_ja>
  <longname_en type="string" length="512">'"$name"'</longname_en>
  <longname_fr type="string" length="512">'"$name"'</longname_fr>
  <longname_de type="string" length="512">'"$name"'</longname_de>
  <longname_it type="string" length="512">'"$name"'</longname_it>
  <longname_es type="string" length="512">'"$name"'</longname_es>
  <longname_zhs type="string" length="512">'"$name"'</longname_zhs>
  <longname_ko type="string" length="512">'"$name"'</longname_ko>
  <longname_nl type="string" length="512">'"$name"'</longname_nl>
  <longname_pt type="string" length="512">'"$name"'</longname_pt>
  <longname_ru type="string" length="512">'"$name"'</longname_ru>
  <longname_zht type="string" length="512">'"$name"'</longname_zht>
  <shortname_ja type="string" length="256">'"$name"'</shortname_ja>
  <shortname_en type="string" length="256">'"$name"'</shortname_en>
  <shortname_fr type="string" length="256">'"$name"'</shortname_fr>
  <shortname_de type="string" length="256">'"$name"'</shortname_de>
  <shortname_it type="string" length="256">'"$name"'</shortname_it>
  <shortname_es type="string" length="256">'"$name"'</shortname_es>
  <shortname_zhs type="string" length="256">'"$name"'</shortname_zhs>
  <shortname_ko type="string" length="256">'"$name"'</shortname_ko>
  <shortname_nl type="string" length="256">'"$name"'</shortname_nl>
  <shortname_pt type="string" length="256">'"$name"'</shortname_pt>
  <shortname_ru type="string" length="256">'"$name"'</shortname_ru>
  <shortname_zht type="string" length="256">'"$name"'</shortname_zht>
  <publisher_ja type="string" length="256">Nintendo</publisher_ja>
  <publisher_en type="string" length="256">Nintendo</publisher_en>
  <publisher_fr type="string" length="256">Nintendo</publisher_fr>
  <publisher_de type="string" length="256">Nintendo</publisher_de>
  <publisher_it type="string" length="256">Nintendo</publisher_it>
  <publisher_es type="string" length="256">Nintendo</publisher_es>
  <publisher_zhs type="string" length="256">Nintendo</publisher_zhs>
  <publisher_ko type="string" length="256">Nintendo</publisher_ko>
  <publisher_nl type="string" length="256">Nintendo</publisher_nl>
  <publisher_pt type="string" length="256">Nintendo</publisher_pt>
  <publisher_ru type="string" length="256">Nintendo</publisher_ru>
  <publisher_zht type="string" length="256">Nintendo</publisher_zht>
  <add_on_unique_id0 type="hexBinary" length="4">00000000</add_on_unique_id0>
  <add_on_unique_id1 type="hexBinary" length="4">00000000</add_on_unique_id1>
  <add_on_unique_id2 type="hexBinary" length="4">00000000</add_on_unique_id2>
  <add_on_unique_id3 type="hexBinary" length="4">00000000</add_on_unique_id3>
  <add_on_unique_id4 type="hexBinary" length="4">00000000</add_on_unique_id4>
  <add_on_unique_id5 type="hexBinary" length="4">00000000</add_on_unique_id5>
  <add_on_unique_id6 type="hexBinary" length="4">00000000</add_on_unique_id6>
  <add_on_unique_id7 type="hexBinary" length="4">00000000</add_on_unique_id7>
  <add_on_unique_id8 type="hexBinary" length="4">00000000</add_on_unique_id8>
  <add_on_unique_id9 type="hexBinary" length="4">00000000</add_on_unique_id9>
  <add_on_unique_id10 type="hexBinary" length="4">00000000</add_on_unique_id10>
  <add_on_unique_id11 type="hexBinary" length="4">00000000</add_on_unique_id11>
  <add_on_unique_id12 type="hexBinary" length="4">00000000</add_on_unique_id12>
  <add_on_unique_id13 type="hexBinary" length="4">00000000</add_on_unique_id13>
  <add_on_unique_id14 type="hexBinary" length="4">00000000</add_on_unique_id14>
  <add_on_unique_id15 type="hexBinary" length="4">00000000</add_on_unique_id15>
  <add_on_unique_id16 type="hexBinary" length="4">00000000</add_on_unique_id16>
  <add_on_unique_id17 type="hexBinary" length="4">00000000</add_on_unique_id17>
  <add_on_unique_id18 type="hexBinary" length="4">00000000</add_on_unique_id18>
  <add_on_unique_id19 type="hexBinary" length="4">00000000</add_on_unique_id19>
  <add_on_unique_id20 type="hexBinary" length="4">00000000</add_on_unique_id20>
  <add_on_unique_id21 type="hexBinary" length="4">00000000</add_on_unique_id21>
  <add_on_unique_id22 type="hexBinary" length="4">00000000</add_on_unique_id22>
  <add_on_unique_id23 type="hexBinary" length="4">00000000</add_on_unique_id23>
  <add_on_unique_id24 type="hexBinary" length="4">00000000</add_on_unique_id24>
  <add_on_unique_id25 type="hexBinary" length="4">00000000</add_on_unique_id25>
  <add_on_unique_id26 type="hexBinary" length="4">00000000</add_on_unique_id26>
  <add_on_unique_id27 type="hexBinary" length="4">00000000</add_on_unique_id27>
  <add_on_unique_id28 type="hexBinary" length="4">00000000</add_on_unique_id28>
  <add_on_unique_id29 type="hexBinary" length="4">00000000</add_on_unique_id29>
  <add_on_unique_id30 type="hexBinary" length="4">00000000</add_on_unique_id30>
  <add_on_unique_id31 type="hexBinary" length="4">00000000</add_on_unique_id31>
</menu>' > ./base/meta/meta.xml

    # app.xml
    echo '<?xml version="1.0" encoding="utf-8"?>
<app type="complex" access="777">
  <version type="unsignedInt" length="4">14</version>
  <os_version type="hexBinary" length="8">000500101000400A</os_version>
  <title_id type="hexBinary" length="8">00050000'"$newId"'</title_id>
  <title_version type="hexBinary" length="2">0000</title_version>
  <sdk_version type="unsignedInt" length="4">20811</sdk_version>
  <app_type type="hexBinary" length="4">80000000</app_type>
  <group_id type="hexBinary" length="4">00001095</group_id>
</app>' > ./base/code/app.xml
}

function getIcon(){
    # Get the icon and bootscreens from the user, and move them
    # TODO: get conversion from png working
    clear
    echo "Please drag and drop the iconTex.tga into the terminal window"
    echo "please note that it must be 128x128 and have a bit depth of 32"
    read iconTex
    clear
    echo "Please drag and drop the bootTvTex.tga into the terminal window"
    echo "please note that it must be 1280x720 and have a bit depth of 24"
    read bootTvTex
    clear
    echo "Please drag and drop the bootDrcTex.tga into the terminal window"
    echo "please note that it must be 854x480 and have a bit depth of 24"
    read bootDrcTex
    clear

    cd $DIR/base/meta
    rm -rf ./iconTex.tga
    rm -rf ./bootTvTex.tga
    rm -rf ./bootDrcTex.tga

    # magick $iconTex -resize 128x128\! -depth 32 +compress ./iconTex.tga
    # truncate -s +8 ./iconTex.tga
    # echo -n "TRUEVISION-XFILE." >> ./iconTex.tga
    # truncate -s +1 ./iconTex.tga

    # magick $bootTvTex -resize 1280x720\! -depth 24 +compress -alpha off ./bootTvTex.tga
    # truncate -s +8 ./bootTvTex.tga
    # echo -n "TRUEVISION-XFILE." >> ./bootTvTex.tga
    # truncate -s +1 ./bootTvTex.tga

    # magick $bootTvTex -resize 1280x720\! -depth 24 +compress -alpha off ./bootDrcTex.tga
    # truncate -s +8 ./bootDrcTex.tga
    # echo -n "TRUEVISION-XFILE." >> ./bootDrcTex.tga
    # truncate -s +1 ./bootDrcTex.tga



    cp $iconTex ./iconTex.tga
    cp $bootTvTex ./bootTvTex.tga
    cp $bootDrcTex ./bootDrcTex.tga

}

function packUp(){
    # Use nuspacker to pack the game into an installable format

    # Cleanup .DS_Store system files, cuz it makes nuspacker break
    cd $DIR
    find ./base/ -name ".DS_Store" -delete
    clear
    echo "Packing game into an installable format..."

    # Check for nuspacker config again here (it should already exist, but it dosn't hurt to make sure)
    if [ -f "./tools/nuspacker/encryptKeyWith" ];
    then
        echo "nuspacker config found!"
    else
        # ask for common key on first run, and save it to nuspacker config
        echo
        echo "For some reason, it didn't get written to eariler and nuspacker needs the WiiU common key."
        echo "Please copy and paste the Wii U common key into the terminal window."
        echo "You will only need to do this once. (Unless you delete the config)"
        read commonkey

        # create and write nuspacker config
        touch ./tools/nuspacker/encryptKeyWith
        echo $commonkey > ./tools/nuspacker/encryptKeyWith
        chmod +x ./tools/nuspacker/encryptKeyWith
    fi

    # nuspacker requires the working directory to contain the config
    cd ./tools/nuspacker/

    java -jar ./nuspacker.jar -in "$DIR/base/" -out ~/Desktop/"$name-00050000$newId"

}

function superNintendo(){
    clear
    getRom
    getBase
    getMetaSnes

    # convert the .rpx file into a .elf file
    clear
    echo Injecting the rom...
    cd $DIR
    wiiurpxtool -d ./base/code/*.rpx ./base/code/in.elf

    # inject the SNES rom into the new .elf
    retroinject base/code/in.elf "$romFile" base/code/injected.elf

    # delete the old, not injected .rpx and .elf
    rm -rf ./base/code/*.rpx
    rm -rf ./base/code/in.elf

    #convert back to .rpx
    wiiurpxtool -c ./base/code/injected.elf ./base/code/WUP-$gameId.rpx

    # more cleanup
    rm -rf ./base/code/injected.elf

    getIcon
    packUp
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
            exit
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

rm -rf $DIR/base/
echo
echo
echo "Injected game is at ~/Desktop/$name-00050000$newId with titleid 00050000$newId"
exit
