#!/bin/bash
URL="https://archlinux.org/groups/x86_64/nerd-fonts/"
HTML=$(curl -s "$URL")
FONTS=$(echo "$HTML" | xmllint --html --xpath '//tbody//td//a/text()' - 2>/dev/null | tr '\n' ' ')
# FONTS_PACKAGE=$(echo $FONTS | tr '\n' ' ')
paru -S $FONTS
