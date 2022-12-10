#!/bin/bash

xrandr --output HDMI-0 --mode 1920x1080 --rate 60 --rotate right --right-of DP-0
xrandr --output DP-0 --mode 1920x1080 --rate 144 --rotate normal --primary
