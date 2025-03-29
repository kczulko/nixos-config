{ pkgs, ...}:
let
  name = "DCP-J105";
  ip = "192.168.0.14";
in
{
  services.printing.enable = true;
  services.printing.drivers = [ (pkgs.callPackage ../pkgs/dcpj105-printer.nix { }) ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hardware = {
    sane = {
      enable = true;
      brscan4 = {
        enable = true;
        netDevices = {
          home = { model = name; ip = ip; };
        };
      };
    };

    printers = {
      ensureDefaultPrinter = name;
      ensurePrinters = [
        {
          name = name;
          description = "Brother ${name}";
          deviceUri = "dnssd://Brother%20DCP-J105._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-94533072b538";
          model = "brother_dcpj105_printer_en.ppd";
        }
      ];
    };
  };
}
