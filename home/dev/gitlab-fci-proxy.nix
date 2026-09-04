# Proxy CHỈ cho gitlab.fci.vn (git + Chrome), qua proxy nội bộ.
# Mọi traffic khác vẫn đi thẳng (DIRECT). Chỉ áp dụng cho host nixos-vinhlq21.
#
# Yêu cầu: máy phải "nhìn thấy" được proxy 10.36.252.45:8080
#          (trong mạng nội bộ, hoặc đang bật VPN).
#
# Sau khi sửa file này: `home-manager switch` (hoặc rebuild host) là đủ để
# cài đặt/gỡ bỏ — không cần script install/uninstall như bản macOS, vì Nix
# tự dọn các file cũ khi option đổi hoặc bị tắt.
{ lib, pkgs, config, hostname, ... }:

let
  enable = hostname == "nixos-vinhlq21";

  proxyHost = "10.36.252.45";
  proxyPort = "8080";
  gitHost = "gitlab.fci.vn";
  pacPort = 8099;

  pacFileName = "gitlab-fci.pac";
  pacDir = "${config.xdg.configHome}/proxy";
  pacPath = "${pacDir}/${pacFileName}";

  pacFileContent = ''
    function FindProxyForURL(url, host) {
      // Chỉ ${gitHost} đi qua proxy nội bộ, còn lại đi thẳng
      if (dnsDomainIs(host, "${gitHost}")) {
        return "PROXY ${proxyHost}:${proxyPort}";
      }
      return "DIRECT";
    }
  '';

  pacServer = pkgs.writeText "gitlab-fci-pacserver.py" ''
    #!/usr/bin/env python3
    """Serve PAC file on 127.0.0.1:${toString pacPort} with correct MIME type."""
    import http.server, socketserver, pathlib

    PAC = pathlib.Path("${pacPath}")

    class Handler(http.server.BaseHTTPRequestHandler):
        def do_GET(self):
            try:
                body = PAC.read_bytes()
            except OSError:
                self.send_error(404); return
            self.send_response(200)
            self.send_header("Content-Type", "application/x-ns-proxy-autoconfig")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)

        def log_message(self, *a):
            pass

    socketserver.TCPServer.allow_reuse_address = True
    with socketserver.TCPServer(("127.0.0.1", ${toString pacPort}), Handler) as httpd:
        httpd.serve_forever()
  '';
in
lib.mkIf enable {
  # ------------------------------------------------------------------------
  # 1) Terminal (git) — proxy chỉ cho đúng URL gitlab.fci.vn, không set
  #    http.proxy toàn cục nên các remote khác không bị ảnh hưởng.
  # ------------------------------------------------------------------------
  programs.git.settings = {
    http."https://${gitHost}/".proxy = "http://${proxyHost}:${proxyPort}";
    http."http://${gitHost}/".proxy = "http://${proxyHost}:${proxyPort}";
  };

  # ------------------------------------------------------------------------
  # 2) File PAC — Chrome đọc file này để quyết định host nào đi proxy.
  # ------------------------------------------------------------------------
  xdg.configFile."proxy/${pacFileName}".text = pacFileContent;

  # ------------------------------------------------------------------------
  # 3) PAC server — Chrome trên Linux đọc được file:// qua --proxy-pac-url,
  #    nhưng dùng luôn HTTP server nhỏ cho đồng nhất & dễ debug qua
  #    `systemctl --user status gitlab-fci-pacserver`.
  # ------------------------------------------------------------------------
  systemd.user.services.gitlab-fci-pacserver = {
    Unit = {
      Description = "PAC server for gitlab.fci.vn split-proxy";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${pkgs.python3}/bin/python3 ${pacServer}";
      Restart = "always";
      RestartSec = 2;
    };
    Install.WantedBy = [ "default.target" ];
  };

  # ------------------------------------------------------------------------
  # 4) Chrome launcher — phải THOÁT HẲN Chrome (không chỉ đóng cửa sổ)
  #    trước khi chạy lệnh này, vì --proxy-pac-url chỉ ăn lúc khởi động.
  # ------------------------------------------------------------------------
  home.file.".local/bin/chrome-gitlab-fci-proxy" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Mở Chrome dùng PAC: chỉ ${gitHost} đi qua ${proxyHost}:${proxyPort}
      # Lưu ý: phải thoát hẳn Chrome (không chỉ đóng cửa sổ) thì flag mới có hiệu lực.
      exec ${pkgs.google-chrome}/bin/google-chrome-stable \
        --proxy-pac-url="http://127.0.0.1:${toString pacPort}/${pacFileName}" "$@"
    '';
  };
}
