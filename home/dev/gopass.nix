{ pkgs, pkgs-unstable, ... }:

let
  # Chrome gọi wrapper này qua native messaging (extension "Gopass Bridge").
  # Store dùng age (không phải GPG) nên không cần gpg-agent.
  jsonapiWrapper = pkgs.writeShellScript "gopass-jsonapi-wrapper" ''
    export PATH="${pkgs-unstable.gopass}/bin:$PATH"
    exec ${pkgs-unstable.gopass-jsonapi}/bin/gopass-jsonapi listen
  '';

  # Thêm age identity suy ra từ SSH key ed25519 vào gopass (gộp với identity sẵn có),
  # in ra recipient age1... tương ứng. Dùng bởi `make gopass-init` / `make gopass-identity`.
  gopassSshIdentity = pkgs.writeShellApplication {
    name = "gopass-ssh-identity";
    runtimeInputs = [ pkgs.ssh-to-age pkgs.age pkgs.openssh pkgs.gnugrep pkgs.gnused pkgs.coreutils ];
    text = ''
      key="''${1:-$HOME/.ssh/id_ed25519}"
      ids="''${XDG_CONFIG_HOME:-$HOME/.config}/gopass/age/identities"

      if ssh-keygen -y -P "" -f "$key" >/dev/null 2>&1; then
        pass=""
      else
        read -rsp "Passphrase SSH key $key: " pass </dev/tty; echo >&2
      fi
      sk="$(SSH_TO_AGE_PASSPHRASE="$pass" ssh-to-age -private-key -i "$key" 2>/dev/null)" \
        || { echo "Không đọc được $key (sai passphrase hoặc không phải ed25519)" >&2; exit 1; }
      unset pass

      old=""
      if [ -e "$ids" ]; then
        echo "Mở identities hiện có (passphrase gopass):" >&2
        old="$(age -d "$ids")"
      fi
      if grep -qxF "$sk" <<<"$old"; then
        echo "Identity đã có sẵn." >&2
      else
        mkdir -p "$(dirname "$ids")"
        echo "Đặt passphrase gopass cho identities (có thể giữ như cũ):" >&2
        printf '%s\n' "$old" "$sk" | sed '/^$/d' | age -p -o "$ids.tmp"
        chmod 600 "$ids.tmp" && mv "$ids.tmp" "$ids"
      fi
      ssh-to-age -i "$key.pub"
    '';
  };

  nativeHost = builtins.toJSON {
    name = "com.justwatch.gopass";
    description = "Gopass wrapper to search and return passwords";
    path = "${jsonapiWrapper}";
    type = "stdio";
    allowed_origins = [ "chrome-extension://kkhfnlkhiapbiehimabddjbimfaijdhk/" ];
  };
in
{
  home.packages = [
    pkgs-unstable.gopass
    pkgs-unstable.gopass-jsonapi
    pkgs.age
    pkgs.ssh-to-age
    gopassSshIdentity
  ];

  xdg.configFile."google-chrome/NativeMessagingHosts/com.justwatch.gopass.json".text = nativeHost;
}
