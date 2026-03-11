# Helper functions library for NixOS configuration
{ lib }:

{
  # Remove # prefix from hex colors
  # Usage: cleanHex "#282a36" -> "282a36"
  cleanHex = lib.removePrefix "#";

  # Generate workspace key bindings for window managers
  # Usage: mkWorkspaceBinds "Mod4" ["1" "2" "3"]
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
