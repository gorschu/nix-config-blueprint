{
#  disks ? ["/dev/nvme0n1"],
  disks ? ["/dev/sda"],
  ...
}: {
  disko.devices = {
    disk = {
      disk0 = {
        type = "disk";
        #        device = "/dev/nvme0n1";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              size = "10G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                extraArgs = ["-n" "ESP"];
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypt-system";
                extraFormatArgs = ["--label crypt-system"];
		passwordFile = "/tmp/luks-encryption.key";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  mountpoint = "/.btrfs-root";
                  extraArgs = ["-f" "--label" "btrfs-root"];
                  postCreateHook = ''
		    MNTPOINT=$(mktemp -d)
		    mount "/dev/disk/by-label/btrfs-root" "$MNTPOINT" -o subvolid=5
		    trap 'umount $MNTPOINT; rm -rf $MNTPOINT' EXIT
	            btrfs subvolume snapshot -r $MNTPOINT/system/root $MNTPOINT/system/snapshots/root.blank
		  '';
              subvolumes = {
                "system" = {};
                "system/root" = {
                  mountpoint = "/";
                  mountOptions = ["defaults" "compress=zstd" "noatime"];
                };
                "system/snapshots" = {
                  mountpoint = "/.snapshots";
                  mountOptions = ["defaults" "compress=zstd" "noatime"];
                };
                "system/nix" = {
                  mountpoint = "/nix";
                  mountOptions = ["defaults" "compress=zstd" "noatime"];
                };
                "system/var-log" = {
                  mountpoint = "/var/log";
                  mountOptions = ["defaults" "compress=zstd" "noatime"];
                };
                "data" = {};
                "data/home" = {
                  mountpoint = "/home";
                  mountOptions = ["defaults" "compress=zstd" "relatime"];
                };
                "data/persist" = {
                  mountpoint = "/persist";
                  mountOptions = ["defaults" "compress=zstd" "noatime"];
                };
              };
            };
          };
        };
      };
    };
  };
};
};
}
