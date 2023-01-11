{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  name = "k8s-static";
  buildInputs = with pkgs; [
    kind
    k9s
    kubectl
    terraform
  ];
}
