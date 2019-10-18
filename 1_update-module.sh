#!/bin/sh

# Init
FONT_REPO="source-foundry/Hack/"
FONT_NAME=Hack
FONT_TYPE=monospace # sans-serif, sans-serif-condensed, serif, monospace, serif-monospace, sansCJK, serifCJK ...

MODULE_ID='magisk-hack-font'
MODULE_NAME='Magisk Hack Font'
MODULE_AUTHOR=muink
MODULE_DESCRIPTION="Systemless apply $FONT_NAME Font for $FONT_TYPE"

MODULE_PROP=./module.prop
MODULE_INSTALL=./install.sh
MODULE_README=./README.md

# Get latest font info
read VERSION DOWNLOAD <<< $(echo `curl -s "https://api.github.com/repos/${FONT_REPO}releases/latest" |
  sed -En '/: / {s|^.*"tag_name": "([^"]+)",?$|"\1"|p; s|^.*"browser_download_url": "(.*-ttf.tar.xz)",?$|"\1"|p}'`)
VERSION=`echo $VERSION | tr -d \" | sed -En 's|^v*(.*)$|v\1|p'`

# Get latest font files
echo Updating FontFile...
curl -Lso fonts.tar.xz $DOWNLOAD

# Update module.prop
echo Updating module.prop...
if [ "$(grep "version=" $MODULE_PROP | cut -d= -f2)" != "$VERSION" ]; then
  sed -i "\
    /version=/ s|\(.*\)=[^=]*$|\1=$VERSION|;
    /versionCode=/ s|\(.*\)=\([0-9]*\)$|\1=$[ `sed -n "/versionCode=/ s|.*=\([0-9]*\)$|\1|p" $MODULE_PROP` +1 ]|" \
  $MODULE_PROP
  echo Done.
fi
sed -Ei "\
  /id=/ s|(.*)=[^=]*$|\1=$MODULE_ID|;
  /name=/ s|(.*)=[^=]*$|\1=$MODULE_NAME|;
  /author=/ s|(.*)=[^=]*$|\1=$MODULE_AUTHOR|;
  /description=/ s|(.*)=[^=]*$|\1=$MODULE_DESCRIPTION|" \
$MODULE_PROP

# Update install.sh
_space=31
sed -i "/ui_print \"[ ]*@MODULENAME[ ]*\"$/ \
  s|\".*\"|\"$(printf "%$[$[(${_space}-${#MODULE_NAME})/2]+$[(${_space}-${#MODULE_NAME})%2]]s" ' ')$MODULE_NAME$(printf "%$[(${_space}-${#MODULE_NAME})/2]s" ' ')\"|" \
$MODULE_INSTALL
unset _space

# Update README.md
sed -i "\
  s|@MODULENAME|$MODULE_NAME|g;
  s|@AUTHOR|$MODULE_AUTHOR|g;
  s|@MODULEID|$MODULE_ID|g" \
$MODULE_README
