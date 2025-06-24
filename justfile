vm-connection := "qemu:///system"
vm-image := "/var/lib/libvirt/images/nixos.qcow2"
vm-iso := "/var/lib/libvirt/images/nixos-installer-x86_64-linux.iso"

install host ip user="nixos" port="22" build_on="auto":
  nix --extra-experimental-features nix-command --extra-experimental-features flakes run github:nix-community/nixos-anywhere  -- --flake .#{{ host }} \
  --disko-mode disko --extra-files extra-files/{{ host }} --disk-encryption-keys /tmp/luks-encryption.key <(cat extra-files/{{ host }}.luks-encryption.key) \
  --build-on {{ build_on }} \
  --ssh-port {{ port }} --target-host {{ user }}@{{ ip }} --generate-hardware-config nixos-facter {{ justfile_directory() }}/hosts/{{ host }}/facter.json

  #nix run github:nix-community/nixos-anywhere/9afe1f9fa36da6075fdbb48d4d87e63456535858  -- --flake .#{{ host }} \
vm-up:
  -virsh --connect {{ vm-connection }} net-start default
  virt-install --connect {{ vm-connection }} \
  --name=nixos --vcpus=4 \
  --boot uefi,firmware.feature0.name=secure-boot,firmware.feature0.enabled=no \
  --memory=8192 --cdrom={{ vm-iso }} --disk \
  {{ vm-image }},size=40,bus=sata --osinfo="nixos-unstable" &

vm-destroy:
  -virsh --connect {{ vm-connection }} destroy nixos
  -virsh --connect {{ vm-connection }} undefine --nvram --domain "nixos" --remove-all-storage

rebuild host ip:
   nixos-rebuild switch --target-host root@{{ ip }} --flake .#{{ host }}

develop:
   nix --extra-experimental-features nix-command --extra-experimental-features flakes develop

