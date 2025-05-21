{ xclip, symlinkJoin, writeShellApplication }:
let
  mkClipUtility = name: cmd: writeShellApplication {
    name = name;
    runtimeInputs = [xclip];
    text = ''${cmd} "$@"'';
  };
  pbcopy = mkClipUtility "pbcopy" "xclip -i";
  pbpaste = mkClipUtility "pbpaste" "xclip -o";
in
symlinkJoin {
  name = "clipboard-cli";
  paths = [ pbcopy pbpaste ];
}
