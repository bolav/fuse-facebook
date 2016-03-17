#!/bin/bash

mkdir dl
curl 'https://origincache.facebook.com/developers/resources/?id=facebook-ios-sdk-current.zip' > dl/facebook-ios-sdk-current.zip
mkdir ios
cd ios
unzip ../dl/facebook-ios-sdk-current.zip
