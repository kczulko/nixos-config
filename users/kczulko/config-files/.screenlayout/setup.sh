#!/run/current-system/sw/bin/sh

set -o nounset
set -o errexit

setup-resolution
/run/current-system/sw/bin/sh ~/.fehbg
/run/current-system/sw/bin/sh polybar-launcher
