# OpenVPN 3 helpers cho waybar + rofi (openvpn3 lấy từ system PATH, chỉ có trên host bật programs.openvpn3)
{ pkgs, ... }:

let
  # Mỗi dòng: <session path>\t<config name>\t<status>
  listSessions = ''
    list_sessions() {
      openvpn3 sessions-list 2>/dev/null | awk '
        /^ *Path: /        { path = $2; name = "" }
        /^ *Config name: / { sub(/^ *Config name: /, ""); sub(/  \(.*$/, ""); name = $0 }
        /^ *Status: /      { sub(/^ *Status: /, ""); printf "%s\t%s\t%s\n", path, name, $0 }
      ' || true
    }

    # session_field <sessions> <config name> <field: 1=path, 3=status>
    session_field() {
      awk -F'\t' -v n="$2" -v f="$3" '$2 == n { print $f; exit }' <<<"$1"
    }
  '';

  # Waybar custom/vpn (return-type json); không in gì khi máy không có openvpn3
  vpnStatus = pkgs.writeShellApplication {
    name = "vpn-status";
    runtimeInputs = [ pkgs.gawk pkgs.jq pkgs.coreutils pkgs.gnugrep ];
    text = listSessions + ''
      command -v openvpn3 >/dev/null || exit 0

      sessions="$(list_sessions)"
      if [ -z "$sessions" ]; then
        jq -cn '{text: "󰦞", class: "disconnected", tooltip: "VPN: chưa kết nối"}'
        exit 0
      fi

      # 󰦞 md-shield_off: chưa kết nối, 󱆢 md-shield_sync: đang kết nối / chờ đăng nhập, 󰦝 md-shield_lock: đã kết nối
      if grep -q 'Client connected' <<<"$sessions"; then class=connected icon="󰦝"
      elif grep -q 'Web authentication' <<<"$sessions"; then class=auth icon="󱆢"
      else class=connecting icon="󱆢"
      fi

      jq -cn \
        --arg text "$icon $(cut -f2 <<<"$sessions" | paste -sd' ')" \
        --arg class "$class" \
        --arg tooltip "$(awk -F'\t' '{ print $2 ": " $3 }' <<<"$sessions")" \
        '{text: $text, class: $class, tooltip: $tooltip}'
    '';
  };

  # Chọn profile bằng rofi. Enter: kết nối nếu chưa có session, ngược lại ngắt kết nối.
  # Profile WEB_AUTH: openvpn3 tự mở trình duyệt, script chờ tới khi kết nối xong rồi báo.
  vpnRofi = pkgs.writeShellApplication {
    name = "vpn-rofi";
    runtimeInputs = [ pkgs.rofi pkgs.gawk pkgs.jq pkgs.coreutils pkgs.gnugrep pkgs.libnotify pkgs.procps pkgs.wl-clipboard ];
    text = listSessions + ''
      notify() { notify-send -a VPN -i network-vpn "$@"; }
      refresh_bar() { pkill -RTMIN+8 waybar || true; }

      if ! command -v openvpn3 >/dev/null; then
        notify "VPN" "OpenVPN 3 chưa được bật trên máy này"
        exit 0
      fi

      mapfile -t configs < <(openvpn3 configs-list --json | jq -r '.[].name' | sort -u)
      if [ "''${#configs[@]}" -eq 0 ]; then
        notify "VPN" "Chưa có profile, import bằng: openvpn3 config-import --config <file.ovpn> --name <tên> --persistent"
        exit 0
      fi

      sessions="$(list_sessions)"
      lines=()
      for name in "''${configs[@]}"; do
        status="$(session_field "$sessions" "$name" 3)"
        case "$status" in
          "")                     lines+=("󰦞  $name") ;;
          *"Client connected"*)   lines+=("󰦝  $name   (đã kết nối)") ;;
          *"Web authentication"*) lines+=("󱆢  $name   (chờ đăng nhập)") ;;
          *)                      lines+=("󱆢  $name   ($status)") ;;
        esac
      done

      idx="$(printf '%s\n' "''${lines[@]}" | rofi -dmenu -i -p "󰖂 VPN" -format i \
        -mesg "Enter: kết nối / ngắt kết nối")" || exit 0
      [ -n "$idx" ] || exit 0
      name="''${configs[$idx]}"

      path="$(session_field "$sessions" "$name" 1)"
      if [ -n "$path" ]; then
        openvpn3 session-manage --path "$path" --disconnect >/dev/null
        refresh_bar
        notify "VPN" "Đã ngắt kết nối $name"
        exit 0
      fi

      notify "VPN" "Đang kết nối $name…"
      if ! out="$(openvpn3 session-start --config "$name" --timeout 60 2>&1)"; then
        refresh_bar
        notify -u critical "VPN" "Kết nối $name thất bại: $(tail -n1 <<<"$out")"
        exit 1
      fi
      refresh_bar

      # openvpn3 không mở được trình duyệt: copy link đăng nhập
      if grep -q 'Could not open the URL' <<<"$out"; then
        url="$(grep -oE 'https?://[^[:space:]]+' <<<"$out" | head -n1)"
        printf '%s' "$url" | wl-copy
        notify "VPN" "Đã copy link đăng nhập $name, mở trên trình duyệt để hoàn tất"
      fi

      # Chờ tối đa 3 phút cho bước đăng nhập trên trình duyệt
      for _ in $(seq 90); do
        status="$(session_field "$(list_sessions)" "$name" 3)"
        case "$status" in
          *"Client connected"*)
            refresh_bar
            notify "VPN" "Đã kết nối $name"
            exit 0 ;;
          "")
            refresh_bar
            notify -u critical "VPN" "Session $name đã dừng"
            exit 1 ;;
        esac
        sleep 2
      done
      notify -u critical "VPN" "Hết thời gian chờ đăng nhập $name"
    '';
  };
in
{
  home.packages = [ vpnStatus vpnRofi ];
}
