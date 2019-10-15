#!/bin/sh

# Get latest font info
REPO="source-foundry/Hack/"
FONT_TYPE=monospace
tmp_josn=./tmp.josn
curl -so $tmp_josn "https://api.github.com/repos/${REPO}releases/latest"

VERSION=`grep '"tag_name":' $tmp_josn | sed -E 's|.*"([^"]+)".*|\1|'`
DOWNLOAD=`grep "browser_download_url.*-ttf\.tar\.xz" $tmp_josn | cut -d: -f2,3 | tr -d \"`
rm -f $tmp_josn | unset tmp_josn

# Update module
MODULE_PROP=./module.prop
if [ "$(grep "version=" $MODULE_PROP | cut -d= -f2)" == "$VERSION" ]; then echo Not need update.. & exit;
else
  echo Updating module.prop...
  sed -i "/version=/ s|\(.*\)=[^=]*$|\1=${VERSION}|; \
  /versionCode=/ s|\(.*\)=\([0-9]*\)$|\1=$[ `sed -n "/versionCode=/ s|.*=\([0-9]*\)$|\1|p" $MODULE_PROP` +1 ]|" $MODULE_PROP
  echo Updating FontFile...
  curl -Lso fonts.tar.xz $DOWNLOAD
  echo Done.
fi
