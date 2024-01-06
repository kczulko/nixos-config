{ pkgs, ... }: with pkgs;

writeScriptBin "polybar-launcher"
  ''
    killall -q polybar || true
    killall -q polybar || true
    pkill polybar || true

    ${polybarFull}/bin/polybar -q -c ~/.config/polybar/config desktop-mainbar
  ''

