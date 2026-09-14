{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              name = "ESP";
              size = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings = {
                  allowDiscards = true;
                  bypassWorkqueues = true;
                };
                extraFormatArgs = [
                  "--type" "luks2"
                  "--cipher" "aes-xts-plain64"
                  "--key-size" "512"
                  "--hash" "sha512"
                  "--pbkdf" "argon2id"
                ];
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"];
                  postCreateHook = ''
                    mount -t btrfs /dev/mapper/crypted /mnt
                    btrfs subvolume shapshot -r /mnt/root /mnt/root-blank
                    umount /mnt
                  '';
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "subvol=root"
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "subvol=nix"
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [
                        "subvol=persist"
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/swap" = {
                      swap.swapfile.size = "34G";
                      mountpoint = "/swap";
                      mountOptions = [
                        "subvol=swap"
                        "noatime"
                        "nodatacow"
                        "compress=no"
                      ];
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
  fileSystems."/persist".neededForBoot = true;
}
