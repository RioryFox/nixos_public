{ lib, config, pkgs, ... }:

{
			#------IMPORTS------
  imports =
    	[
      		./hardware-configuration.nix
      		<home-manager/nixos>
	];

			#------BOOTLOADER------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModulePackages = with config.boot.kernelPackages ; [ amneziawg ] ; 	

			#------NETWORK-----
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

			#------USERS------
 users.users.rioryfox = {
    isNormalUser = true;
    description = "Riory Fox";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

			#------HOME MANAGER------
  home-manager.users.rioryfox = { pkgs, ...}: {
    home.packages = with pkgs; [ 
	python3
	git
	git-crypt
	gnupg
    ];
    home.stateVersion = "25.05";
    #---git---
    programs.git = {
      enable = true;
      userName = "Riory Fox";
      userEmail = "shesdow@icloud.com";
    };
   };

			#------PROGRAMS------
  #---firefox---
  programs.firefox  = {
	enable = true;
  };
  #---steam---
  programs.steam = {
  	enable = true;
  	remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  	dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  	localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  #---hyprland---
  programs.hyprland = {
	enable = true;
	withUWSM = true;
	xwayland.enable = true;
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget

			#------ENVIROMENR------
  environment.systemPackages = with pkgs; [
	#---wget---
	wget
	#---vim---
  	vim
	#---python---
	python3Full
	python3Packages.pip
	python3Packages.setuptools
	python313Packages.toolz
	#---vlc---
	vlc
	libvlc
	#---gimp---
	gimp
	#---visual studio code---
	vscode
	(vscode-with-extensions.override {
	vscodeExtensions = with vscode-extensions; [
			bbenoist.nix
			ms-python.python
			ms-azuretools.vscode-docker
			ms-vscode-remote.remote-ssh
		] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
		{
			name = "remote-ssh-edit";
			publisher = "ms-vscode-remote";
			version = "0.47.2";	
			sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
		}
		];
	})
	#---wine---
    	# support both 32-bit and 64-bit applicationswineWowPackages.stable
	#WineWowPackages.stable
    	# support 32-bit only
    	wine
    	# support 64-bit only
    	(wine.override { wineBuild = "wine64"; })
    	# support 64-bit only
    	wine64
    	# wine-staging (version with experimental features)
    	wineWowPackages.staging
    	# winetricks (all versions)
    	winetricks
    	# native wayland support (unstable)
    	wineWowPackages.waylandFull
	#---amnezia vpn---
	linuxKernel.packages.linux_zen.amneziawg
 	amnezia-vpn 	
	amneziawg-go
  	amneziawg-tools	
	#---libreoffice---
	libreoffice-qt
	hunspell
	hunspellDicts.uk_UA
	hunspellDicts.th_TH
	#---krita---
	krita
	#---kitty - for hyperland---
	kitty
	#---telegram---
	telegram-desktop
	#---hiddify---
	hiddify-app
	#---hyprpaper---
	hyprpaper
	#---picocom---
	picocom
	#---ampy---
	adafruit-ampy
	#--affine---
	affine
	#---nodejs---
	nodejs
	#---php---
	php
	#---open webui---
	open-webui
  ]; 

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
    services.openssh.enable = true;
			

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
	"vscode"
	"vscode-with-extensions"
	"vscode-extension-ms-vscode-remote-remote-ssh"
	"hiddify-app"
	"hiddify-core"
	"steam"
	"steam-unwrapped"
];
  #nixpkgs.config.allowUnfree = true;

			#------FIREWALL------
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

			#------SYTEM------
  system.stateVersion = "24.11"; # Did you read the comment? #Yes, I did :)
}
