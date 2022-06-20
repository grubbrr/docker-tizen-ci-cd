#!/bin/sh -l

echo "docker-tizen-ci-cd\r\n"

command="$1"
directory="${GITHUB_WORKSPACE}/$2"
password="$3"
cert_name="$4"
exclusions="$5"
zip="$6"
type="$7"
version="$8"

if [ -z "$version" ]; then
    version=$(sed -rn 's|<widget.*?" version="(.+?)" viewmodes.*|\1|p' "$directory/config.xml")
else
    # if we have a version, we need to update it in the config.xml
    sed -ri "s|(<widget.*?\" version=\").+?(\" viewmodes.*)|\1$version\2|" "$directory/config.xml"
fi

appName=$(sed -rn 's|.*<name>(.+?)</name>.*|\1|p' "$directory/config.xml")

echo "App name: $appName"
echo "Version: $version\r\n"

if [ -z "$password" ]; then
    echo "Usage: cert-pw is required"
    exit 1
fi

export DISPLAY=:0.0
dbus-launch > /dev/null
export $(dbus-launch)

echo "$password" | gnome-keyring-daemon --unlock > /dev/null

tizen certificate -a "$cert_name" -f "$cert_name" -p "$password" > /dev/null
tizen security-profiles add -n "$cert_name" -a "/home/tizen/tizen-studio-data/keystore/author/$cert_name.p12" -p "$password" > /dev/null
tizen security-profiles set-active -n "$cert_name"

case $command in
    web)
        tizen build-web -e $exclusions -opt -- "$directory"
        tizen package -t wgt -s "$cert_name" -- "$directory/.buildResult" || cat /home/tizen/tizen-studio-data/cli/logs/cli.log
        ;;
    *)
        echo "$1 is not implemented yet"
        exit 1
        ;;
esac

wgtFile="$directory/.buildResult/$appName.wgt"
echo "::set-output name=file::$2/.buildResult/$appName.wgt"

if [ "$zip" = "true" ]; then
    zipLocation="$directory/.buildResult/$appName.zip"

    xmlFile="$directory/.buildResult/pkginfo.xml"
    
    # cp "$PWD"/pkginfo.xml "$xmlFile"

    # sed -ri "s|(.*?)%APPNAME%(.*)|\1$appName\2|" "$xmlFile"
    # sed -ri "s|(.*?)%APPVERSION%(.*)|\1$version\2|" "$xmlFile"
    # sed -ri "s|(.*?)%APPTYPE%(.*)|\1$type\2|" "$xmlFile"

    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $xmlFile
    echo "<pkg name=\"$appName\" type=\"$type\">" >> $xmlFile
    echo "    <packagever>$version</packagever>" >> $xmlFile
    echo "    <app>"
    echo "        <apptype>order_web</apptype>" >> $xmlFile
    echo "        <Existence>1</Existence>" >> $xmlFile
    echo "        <appfile>$appName.wgt</appfile>" >> $xmlFile
    echo "        <version>$version</version>" >> $xmlFile
    echo "    </app>" >> $xmlFile
    echo "</pkg>" >> $xmlFile
    

    zip -j $zipLocation "$wgtFile" "$xmlFile"
    echo "::set-output name=zip::$2/.buildResult/$appName.zip"
fi