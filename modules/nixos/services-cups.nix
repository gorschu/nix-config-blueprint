{
  pkgs,
  lib,
  ...
}: let
  hpHostName = "officejet8730.fritz.box";
in {
  services.printing = {
    enable = true;
    startWhenNeeded = true;
    drivers = with pkgs; [
      hplipWithPlugin
      cups-filters
      # ${pkgs.cups-filters}/bin/driverless cat driverless:ipps://officejet8730.fritz.box/ > ~/nix-config/hosts/common/optional/cups/hp-officejet-8730-driverless.ppd
      (writeTextDir "share/cups/model/hp-officejet-8730-driverless.ppd" (builtins.readFile ./ppd/hp-officejet-8730-driverless.ppd))
    ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hardware = let
    hpPostScript = "HP_Officejet_8730_Postscript";
    hpDriverless = "HP_Officejet_8730_Driverless";
  in {
    printers = {
      # for color to monochrome conversion to work, use:
      # lpadmin -p HP_Officejet_8730_Postscript -o pdftops-renderer-default=gs
      # (and probably turn off HPPJLColorAsGray option)
      ensureDefaultPrinter = hpDriverless;
      ensurePrinters = [
        {
          name = hpPostScript;
          deviceUri = "hp:/net/HP_OfficeJet_Pro_8730?hostname=${hpHostName}";
          model = "HP/hp-officejet_pro_8730-ps.ppd.gz";
          description = lib.replaceStrings ["_"] [" "] hpPostScript;
          location = "Home Office";
          ppdOptions = {
            PageSize = "A4";
            Collate = "true";
            MediaType = "Plain";
            Duplex = "DuplexNoTumble";
            HPPJLColorAsGray = "yes";
          };
        }
        {
          name = hpDriverless;
          deviceUri = "socket://${hpHostName}:9100";
          model = "hp-officejet-8730-driverless.ppd";
          description = lib.replaceStrings ["_"] [" "] hpDriverless;
          location = "Home Office";
          ppdOptions = {
            PageSize = "A4";
            Collate = "true";
            MediaType = "Plain";
            Duplex = "DuplexNoTumble";
          };
        }
      ];
    };
  };
}
