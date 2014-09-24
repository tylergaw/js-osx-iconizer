#!/bin/sh
GULPPATH="$1"
SKETCHDOC="$2"
NAME="$3"
CLASSNAME="$4"
LOC="$5"
TEMPLATE="$6"
HTML="$7"
CSS="$8"

source ~/.bash_profile

cd $GULPPATH && gulp symbols -d "$SKETCHDOC" -n "$NAME" -t "$TEMPLATE" -c "$CLASSNAME" -l "$LOC" --sample "$HTML" --css "$CSS"
