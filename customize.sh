#!/bin/sh
SKIPUNZIP=1


ui_print "*******************************"
ui_print "      Magisk Cascadia Font     "
ui_print "*******************************"

ui_print "- Extracting module files"
unzip -o "$ZIPFILE" -x 'META-INF/*' fonts.tar.xz -d $MODPATH >&2
# --------------------------------------------
ui_print "- Searching in fonts.xml"
[[ -d /sbin/.magisk/mirror ]] && MIRRORPATH=/sbin/.magisk/mirror || unset MIRRORPATH
FILEPATH=/system/etc
FILE=fonts.xml
mkdir -p $MODPATH/$FILEPATH 2>/dev/null

ui_print "- Unzipping font files..."
FONTSPATH=/system/fonts
zipinfo -1 "$ZIPFILE" >/dev/null && (
  unzip -oj "$ZIPFILE" fonts.tar.xz -d $TMPDIR >&2
  mkdir -p $MODPATH/$FONTSPATH 2>/dev/null
  tar -xf $TMPDIR/fonts.tar.xz -C $MODPATH/$FONTSPATH 2>/dev/null
)

ui_print "- Installing fonts..."
RAWFONTS=`sed -En '/<family name="monospace">/,/<\/family>/ {s|.*<font weight="400" style="normal">(.*).ttf<\/font>.*|\1|p}' $MIRRORPATH/$FILEPATH/$FILE`
NEWFONTS='CascadiaCode'
#NEWFONTS='CascadiaMono'

# Just replace
ln -s $FONTSPATH/${NEWFONTS}.ttf $MODPATH/$FONTSPATH/${RAWFONTS}.ttf


# Default permissions
set_perm_recursive $MODPATH 0 0 0755 0644
