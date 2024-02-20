user/deploy:
	nix build .#user-profile
	nix-env --set ./result

nixos/deploy:
	nixos-rebuild switch --flake . --use-remote-sudo

nixos/test:
	nixos-rebuild test --flake . --use-remote-sudo

nixos/diff:
	nixos-rebuild build --flake .
	nix-diff /run/current-system ./result
