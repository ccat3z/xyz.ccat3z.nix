apply-user-profile:
	nix build .#user-profile
	nix-env --set ./result
	
dump-dconf-nix:
	dconf dump / | dconf2nix > modules/nixos/home/dconf.nix