{ lib, buildEnv, nix, nixos-rebuild, ... }:
buildEnv {
    name = "user-profile";
    paths = [
        nix
        nixos-rebuild
    ];
    pathsToLink = ["/bin" "/etc" "/share"];
}
