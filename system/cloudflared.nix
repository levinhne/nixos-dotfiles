{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "<TUNNEL_UUID>" = {
        # Đường dẫn tuyệt đối tới file credentials.json mà bạn đã sinh ra
        credentialsFile = "/var/lib/cloudflared/credentials.json";

        # Định tuyến các request
        ingress = {
          "api.yourdomain.com" = "http://localhost:8080";
        };
        default = "http_status:404";
      };
    };
  };
}
