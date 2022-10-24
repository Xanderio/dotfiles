{ pkgs
, lib
, ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "hex";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.video.hidpi.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
    vaapiIntel
    libvdpau-va-gl
    vaapiVdpau
    intel-ocl
  ];
  environment.etc."openal/alsoft.conf".source = pkgs.writeText "alsoft.conf" "drivers=pulse";
  environment.variables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  services.openvpn.servers.office = {
    config = ''
      config /var/lib/cyberus-openvpn/openvpn.conf
    '';
    updateResolvConf = false;
    up = "${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved";
    down = "${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved";
  };
  nix.settings = {
    substituters = [
      "https://binary-cache.vpn.cyberus-technology.de"
      "http://binary-cache-v2.vpn.cyberus-technology.de"
    ];
    trusted-public-keys = [
      "binary-cache.vpn.cyberus-technology.de:qhg25lVqyCT4sDOqxY6GJx8NF3F86eAJFCQjZK/db7Y="
      "cyberus-1:0jjMD2b+guloGW27ZToxDQApCoWj+4ONW9v8VH/Bv0Q=" # v2 cache
    ];
  };

  home-manager.users.xanderio.xanderio = {
    git = {
      enable = true;
      email = "alexander.sieg@cyberus-technology.de";
      gpgFormat = "ssh";
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKSDJ6zHzaKb+bdDPm6iOplsLao/YJAepUr5Ja86gjN6";
    };
    sway.scale = "1.5";
  };
}
