{
  description = "Shell for kubernetes editing";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          age
          fluxcd
          k3d
          kube-linter
          kubectl
          kubernetes-helm
          kubeseal
          kubeval
          kustomize
          kustomize-sops
          sops
        ];
      };
    };
}
