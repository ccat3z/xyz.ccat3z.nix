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

nixos/gen-dconf:
	./modules/nixos/home/dconf-gen.py
	nix fmt ./modules/nixos/home/dconf.nix

nixos/diff-dconf:
	diff --color=always -u ./modules/nixos/home/dconf.ini <(dconf dump /) | less
