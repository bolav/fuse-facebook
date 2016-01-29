#!/bin/bash

mkdir dl
wget 'https://origincache.facebook.com/developers/resources/?id=facebook-android-sdk-4.9.0.zip' -O dl/facebook-android-sdk-4.9.0.zip
unzip dl/facebook-android-sdk-4.9.0.zip
mkdir android
cd android
unzip ../facebook-android-sdk-4.9.0/facebook/facebook-android-sdk-4.9.0.aar
