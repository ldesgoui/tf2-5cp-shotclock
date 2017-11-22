#!/bin/sh

smcc -w213 \
    addons/sourcemod/scripting/shotclock.sp \
    -o addons/sourcemod/plugins/shotclock.smx

zip -r 5cp-shotclock-0.1.0.zip addons/
