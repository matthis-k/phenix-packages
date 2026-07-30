{ lib }:
{
  mkPhenixWrapper = import ./mk-phenix-wrapper.nix { inherit lib; };
}
