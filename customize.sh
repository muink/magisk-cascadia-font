#!/bin/sh
SKIPUNZIP=1


ui_print "*******************************"
ui_print "      Magisk Cascadia Font     "
ui_print "*******************************"

ui_print "- Extracting module files"
unzip -o "$ZIPFILE" -x 'META-INF/*' -d $MODPATH >&2
# --------------------------------------------
ui_print "- Searching in fonts.xml"
[[ -d /sbin/.magisk/mirror ]] && MIRRORPATH=/sbin/.magisk/mirror || unset MIRRORPATH
FILEPATH=/system/etc/fonts.xml

ui_print "- Installing fonts..."
TARGET="$(sed -En '/<family name="monospace">/,/<\/family>/ {s|.*<font weight="400" style="normal"[^\>]*>(.*).ttf<\/font>.*|\1|p}' $FILEPATH) \
	$(sed -En '/<family name="serif-monospace">/,/<\/family>/ {s|.*<font weight="400" style="normal"[^\>]*>(.*).ttf<\/font>.*|\1|p}' $FILEPATH)"
SOURCE='CascadiaCode'
#SOURCE='CascadiaMono'

# Just replace
for _t in $TARGET; do
	ln -s ${SOURCE}.ttf $MODPATH/system/fonts/${_t}.ttf.placeholder
done

# Default permissions
set_perm_recursive $MODPATH 0 0 0755 0644
