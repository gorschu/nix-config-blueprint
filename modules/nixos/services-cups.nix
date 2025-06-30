{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.gorschu.services.cups;
  homeHostName = "wf4830dtwf.fritz.box";
in
{
  options.gorschu.services.cups = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable and configure cups";
    };
  };
  config = lib.mkIf cfg.enable {
    services.printing = {
      enable = true;
      startWhenNeeded = true;
      drivers = with pkgs; [
        epson-escpr2
        cups-filters
        # ${pkgs.cups-filters}/bin/driverless cat driverless:ipps://officejet8730.fritz.box/ > ~/nix-config/hosts/common/optional/cups/hp-officejet-8730-driverless.ppd
        # (writeTextDir "share/cups/model/hp-officejet-8730-driverless.ppd" (builtins.readFile ./ppd/hp-officejet-8730-driverless.ppd))
      ];
    };
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    hardware =
      let
        epsonWF4830Ipp = "Epson_Workforce_4830_Series";
      in
      {
        printers = {
          # for color to monochrome conversion to work, use:
          # lpadmin -p HP_Officejet_8730_Postscript -o pdftops-renderer-default=gs
          # (and probably turn off HPPJLColorAsGray option)
          ensureDefaultPrinter = epsonWF4830Ipp;
          ensurePrinters = [
            {
              name = epsonWF4830Ipp;
              deviceUri = "ipps://${homeHostName}:631/ipp/print";
              model = "epson-inkjet-printer-escpr2/Epson-WF-4830_Series-epson-escpr2-en.ppd";
              description = lib.replaceStrings [ "_" ] [ " " ] epsonWF4830Ipp;
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
  };
}
