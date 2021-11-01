#!/run/current-system/sw/bin/sh

set -o nounset
set -o errexit

if [ $(hostname) == "thinkpad" ]
then
    /run/current-system/sw/bin/xrandr --output eDP-1 \
                                  --primary \
                                  --mode 1920x1080 \
                                  --pos 0x0 \
                                  --rotate normal \
                                  --output DP-1 --off \
                                  --output HDMI-1 \
                                  --off --output DP-2 --off
fi

/run/current-system/sw/bin/sh ~/.fehbg
/run/current-system/sw/bin/sh polybar-launcher
