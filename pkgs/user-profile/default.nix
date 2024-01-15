{ lib, buildEnv, nix, ... }:
buildEnv {
    name = "user-profile";
    paths = [
        nix
    ];
    pathsToLink = ["/bin" "/etc" "/share"];
}
