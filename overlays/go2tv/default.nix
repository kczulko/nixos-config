{ inputs, latest-nixpkgs }: final: prev:
{
  go2tv = prev.go2tv.override(prev:
    {
      buildGoModule = args: prev.buildGoModule (args // {
        patches = [ ./no-random-port.patch ];
      });
    }
  );
}
