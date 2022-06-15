#!/bin/bash

flutter clean && flutter build appbundle
if [[ $? == 0 ]]; then
    echo "COPYING APK...."
    cp -f $PWD/build/app/outputs/bundle/release/app.aab $HOME/Desktop/
    echo "APK COPIED."
    echo "RENAMING APK...."
    mv $HOME/Desktop/app.aab $HOME/Desktop/Qbix-$(date +%F-%H:%M).aab
else
    echo "FLUTTER APK BUILD FAILED"
fi
