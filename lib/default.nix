{ lib }:
{
  mkPhenixProgram = import ./mk-phenix-program.nix { inherit lib; };
}
