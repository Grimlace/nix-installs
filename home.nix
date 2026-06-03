{ pkgs, zen-browser, system, ... }: {

  home.username      = "skarr";
  home.homeDirectory = "/home/skarr";
  home.stateVersion  = "24.05";
  programs.home-manager.enable = true;

  home.packages =
    (import ./packages/cli.nix { inherit pkgs; }) ++
    (import ./packages/dev.nix { inherit pkgs; }) ++
    (import ./packages/gui.nix { inherit pkgs; }) ++
    (import ./packages/gui-external.nix { inherit zen-browser system; });
}
