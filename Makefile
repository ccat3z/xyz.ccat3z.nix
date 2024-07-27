user/deploy:
	nix build .#user-profile
	nix-env --set ./result

nixos/deploy:
	nixos-rebuild switch --flake . --use-remote-sudo

nixos/test:
	nixos-rebuild test --flake . --use-remote-sudo

nixos/build:
	nixos-rebuild build --flake .

nixos/diff: nixos/build
	nix-diff --color=always /run/current-system ./result

nixos/gen-dconf:
	./modules/home/dconf-gen.py
	nix fmt ./modules/home/dconf.nix

nixos/diff-dconf:
	diff --color=always -u ./modules/home/dconf.ini <(dconf dump /) | less

nixos/history:
	sudo nix-env \
		--profile /nix/var/nix/profiles/system \
		--list-generations \

nixos/gc:
	sudo nix-env \
		--profile /nix/var/nix/profiles/system \
		--delete-generations 3d

secrets/updatekeys:
	nix run .#sops-updatekeys
