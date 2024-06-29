#!/bin/bash
amixer get Master -M | grep -oE -m1 "[[:digit:]]*%"
#awk -F"[][]" '/Mono:/ { print $2 }' <(amixer sget Master)
