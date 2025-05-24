#!/bin/sh

# Detect primary or fallback to first connected output
OUTPUT=$(xrandr --query | awk '/ connected/{print $1; exit}')
exec i3bar --tray_output "$OUTPUT"
