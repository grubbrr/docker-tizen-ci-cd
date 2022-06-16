#!/bin/sh -l

command="$1"
directory="$2"
password="$3"
cert_name="$4"
exclusions="$5"
zip="$6"

if [ -z "$password" ]; then
    echo "Usage: cert-pw is required"
    exit 1
fi

export DISPLAY=:0.0
dbus-launch
export $(dbus-launch)

echo "$password" | gnome-keyring-daemon --unlock

tizen certificate -a "$cert_name" -f "$cert_name" -p "$password"
tizen security-profiles add -n "$cert_name" -a "/home/tizen/tizen-studio-data/keystore/author/$cert_name.p12" -p "$password"
tizen security-profiles set-active -n "$cert_name"

cat /home/tizen/tizen-studio-data/profile/profiles.xml

case $command in
    web)
        tizen build-web -e $exclusions -opt -- "${GITHUB_WORKSPACE}/$directory"
        tizen package -t wgt -s "$cert_name" -- "${GITHUB_WORKSPACE}/$directory/.buildResult" || cat /home/tizen/tizen-studio-data/cli/logs/cli.log
        ;;
    *)
        echo "$1 is not implemented yet"
        exit 1
        ;;
esac

# echo "Hello $1"
# time=$(date)
# echo "::set-output name=file::$time"