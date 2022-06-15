#!/bin/bash

flutter clean && flutter build apk
if [[ $? == 0 ]]; then
    echo "Copying APK...."
    cp -f $PWD/build/app/outputs/apk/release/app-release.apk $HOME/Desktop/
    echo "APK copied."
    echo "Renaming APK...."
    mv $HOME/Desktop/app-release.apk $HOME/Desktop/Qbix-$(date +%F-%H:%M).apk
else
    echo "Flutter APK Build Failed"
fi
