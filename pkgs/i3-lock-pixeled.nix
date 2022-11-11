{
  i3lock-pixeled
}:
i3lock-pixeled.overrideDerivation (oldAttrs: rec {
  patchPhase = oldAttrs.patchPhase + ''
    substituteInPlace i3lock-pixeled \
      --replace '# take the actual screenshot' 'rm $IMGFILE 2> /dev/null'
  '';
})
