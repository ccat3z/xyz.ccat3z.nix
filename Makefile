apply-user-profile:
	nix build .#user-profile
	nix-env --set ./result

deploy-nixos:
	nixos-rebuild switch --flake . --use-remote-sudo

test-nixos:
	nixos-rebuild test --flake . --use-remote-sudo

diff-nixos:
	nixos-rebuild build --flake .
	nix-diff ./result /run/current-system
