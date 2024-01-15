apply-user-profile:
	nix build .#user-profile
	nix-env --set ./result
	