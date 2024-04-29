#!/bin/bash
echo "  _____                 _   _       _     ";
echo " | ____|_ __ ___  _   _| | | |_   _| |__  ";
echo " |  _| |  _   _ \| | | | |_| | | | | '_ \ ";
echo " | |___| | | | | | |_| |  _  | |_| | |_) |";
echo " |_____|_| |_| |_|\__ _|_| |_|\__ _|_ __/ ";
echo "                                          ";
DEVICE_NAME=$1
DEVICE_ID=$2
SKIN_NAME=$3
SKIN_DIR="/opt/android-sdk-linux/skins"
PACKAGE="system-images;android-33;android-wear;x86_64"
if /opt/android-sdk-linux/cmdline-tools/tools/bin/avdmanager list avd | grep -q $DEVICE_NAME; then
    echo "AVD ${DEVICE_NAME} already exists."
else
    echo "Creating AVD ${DEVICE_NAME}..."
    echo no | /opt/android-sdk-linux/cmdline-tools/tools/bin/avdmanager create avd --name $DEVICE_NAME --device $DEVICE_ID --package $PACKAGE  --force
    AVD_DIR="/home/emuhub/.android/avd/$DEVICE_NAME.avd"
    # Edit the config.ini file
    sed -i 's/hw\.keyboard\s*=\s*no/hw.keyboard = yes/' $AVD_DIR/config.ini
    sed -i 's|skin\.path\s*=\s*_no_skin|skin.path = '$SKIN_DIR/$SKIN_NAME'|' "$AVD_DIR/config.ini"
fi

if screen -ls | grep -q "$DEVICE_NAME"; then
    screen -S "$DEVICE_NAME" -X quit
fi
    screen -dmS "$DEVICE_NAME"
    screen -S "$DEVICE_NAME" -X stuff "export QT_X11_NO_MITSHM=1 && /opt/android-sdk-linux/emulator/emulator -avd $DEVICE_NAME -gpu host -skindir $SKIN_DIR -skin $SKIN_NAME -delay-adb  ^M"

if screen -ls | grep -q "${DEVICE_NAME}_apk_install"; then
    screen -S "${DEVICE_NAME}_apk_install" -X quit
fi
    screen -dmS "${DEVICE_NAME}_apk_install"
    screen -S "${DEVICE_NAME}_apk_install" -X stuff "/opt/android-sdk-linux/platform-tools/adb wait-for-device shell 'while [[ -z \$(getprop sys.boot_completed) ]]; do sleep 1; done;' && /opt/android-sdk-linux/platform-tools/adb install /home/emuhub/apk/app-release.apk && exit"$(printf \\r)

