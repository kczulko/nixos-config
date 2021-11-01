#!/run/current-system/sw/bin/sh

set -o nounset
set -o errexit

if [ $(hostname) == "thinkpad" ]
then
  echo "Fixme!"
fi

/run/current-system/sw/bin/sh ~/.fehbg
/run/current-system/sw/bin/sh polybar-launcher
