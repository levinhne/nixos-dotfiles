# Helper functions library for NixOS configuration
{ lib }:

{
  mkHost = import ./mkHost.nix;

  # Remove # prefix from hex colors
  cleanHex = lib.removePrefix "#";

  # Generate workspace key bindings for window managers
  mkWorkspaceBinds = modifier: keys:
    builtins.listToAttrs (map
      (key: {
        name = "${modifier}+${key}";
        value = "workspace number ${key}";
      })
      keys);

  # Generate move to workspace key bindings
  mkMoveToWorkspaceBinds = modifier: keys:
    builtins.listToAttrs (map
      (key: {
        name = "${modifier}+Shift+${key}";
        value = "move container to workspace number ${key}";
      })
      keys);
}
