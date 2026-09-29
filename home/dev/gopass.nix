{ pkgs, pkgs-unstable, ... }:

let
  # Chrome gọi wrapper này qua native messaging (extension "Gopass Bridge").
  # Store dùng age (không phải GPG) nên không cần gpg-agent.
  jsonapiWrapper = pkgs.writeShellScript "gopass-jsonapi-wrapper" ''
    export PATH="${pkgs-unstable.gopass}/bin:$PATH"
    exec ${pkgs-unstable.gopass-jsonapi}/bin/gopass-jsonapi listen
  '';

  # Thêm age identity suy ra từ SSH key ed25519 vào gopass (gộp với identity sẵn có),
  # in ra recipient age1... tương ứng. Dùng bởi `make gopass-init` (dotfiles) / `make identity` (store).
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

  # gopass (go-pinentry) gọi binary tên `pinentry` để hỏi passphrase age identities
  # khi không có TTY (vd. chạy từ rofi) → trỏ về pinentry-rofi cho đồng bộ giao diện.
  pinentry = pkgs.writeShellScriptBin "pinentry" ''
    exec ${pkgs.pinentry-rofi}/bin/pinentry-rofi "$@"
  '';

  # Chọn secret bằng rofi. Enter: copy password (tự xoá sau core.cliptimeout),
  # Alt+t: gõ password vào cửa sổ hiện tại, Alt+u: copy username, Alt+o: copy OTP,
  # Alt+n (hoặc Enter với tên chưa tồn tại): tạo secret mới.
  gopassRofi = pkgs.writeShellApplication {
    name = "gopass-rofi";
    runtimeInputs = [ pkgs-unstable.gopass pkgs.rofi pkgs.wtype pkgs.wl-clipboard pkgs.libnotify pinentry pkgs.coreutils pkgs.gnugrep ];
    text = ''
      ask() {
        local p="$1" m="''${2:-}"; shift 2 || shift
        if [ -n "$m" ]; then set -- -mesg "$m" "$@"; fi
        rofi -dmenu -i -p "$p" "$@" </dev/null
      }

      add_secret() {
        name="$1"
        [ -n "$name" ] || name="$(ask " Tên secret" "vd. web/github.com")" || exit 0
        [ -n "$name" ] || exit 0

        mode="$(printf '%s\n' "Generate (24 ký tự)" "Nhập tay" | rofi -dmenu -i -p " $name")" || exit 0
        case "$mode" in
          Generate*) pass="$(gopass pwgen 24 1 | head -n1 | tr -d '[:space:]')" ;;
          *)         pass="$(ask " Password" "" -password)" || exit 0 ;;
        esac
        [ -n "$pass" ] || { notify-send "gopass" "Password rỗng, huỷ"; exit 0; }

        user="$(ask " Username" "Để trống nếu không cần")" || user=""

        { printf '%s\n' "$pass"; [ -z "$user" ] || printf 'login: %s\n' "$user"; } \
          | gopass insert -f "$name"
        unset pass
        gopass show -c "$name"
        notify-send "gopass" "Đã tạo $name (password đã copy)"
      }

      set +e
      list="$(gopass ls --flat)"
      entry="$(printf '%s\n' "$list" | rofi -dmenu -i -p " Pass" \
        -mesg "Enter: copy · Alt+t: type · Alt+u: user · Alt+o: OTP · Alt+n: thêm mới" \
        -kb-custom-1 "Alt+t" -kb-custom-2 "Alt+u" -kb-custom-3 "Alt+o" -kb-custom-4 "Alt+n")"
      rc=$?
      set -e

      if [ "$rc" -eq 13 ]; then add_secret "$entry"; exit 0; fi
      [ -n "$entry" ] || exit 0
      if ! grep -qxF -- "$entry" <<<"$list"; then add_secret "$entry"; exit 0; fi

      case $rc in
        0)  gopass show -c "$entry" ;;
        10) sleep 0.2; gopass show -o "$entry" | tr -d '\n' | wtype - ;;
        11)
          user="$(gopass show "$entry" login 2>/dev/null || gopass show "$entry" username 2>/dev/null || basename "$entry")"
          printf '%s' "$user" | wl-copy
          notify-send "gopass" "Đã copy username của $entry" ;;
        12) gopass otp -c "$entry" ;;
        *)  exit 0 ;;
      esac
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
    gopassRofi
    pinentry
  ];

  # Cache age identities trong RAM để không phải nhập passphrase mỗi lần gọi gopass.
  # Cần bật một lần: `gopass config age.agent-enabled true`.
  systemd.user.services.gopass-age-agent = {
    Unit = {
      Description = "gopass age agent";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs-unstable.gopass}/bin/gopass age agent start";
      Environment = [ "PATH=${pinentry}/bin:${pkgs.rofi}/bin" ];
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  xdg.configFile."google-chrome/NativeMessagingHosts/com.justwatch.gopass.json".text = nativeHost;
}
