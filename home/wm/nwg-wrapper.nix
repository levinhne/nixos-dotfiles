# nwg-wrapper: hiển thị GitHub Trending lên desktop
#
# Luồng: nwg-wrapper -s trending.sh  ->  markscribe trending.tpl (lấy RSS
# trending) -> in ra Pango markup -> nwg-wrapper vẽ lên layer nền.
#
# Lệnh khởi động được khai báo tập trung trong home/wm/common.nix (dùng chung
# cho cả Sway và Niri).
{ pkgs, config, fonts, ... }:

let
  c = config.lib.stylix.colors.withHashtag;

  # Feed RSS của GitHub Trending (mshibanami/GitHubTrendingRSS).
  # Đổi "all" thành ngôn ngữ cụ thể nếu muốn, ví dụ .../daily/rust.xml
  feedUrl = "https://mshibanami.github.io/GitHubTrendingRSS/daily/all.xml";
  itemCount = 10;

  # Template markscribe -> Pango markup.
  # Chỉ chèn {{ .Title }} (dạng "owner / repo"); các phần tĩnh không chứa '&'
  # nên script bên dưới escape '&' -> '&amp;' an toàn cho tên repo hiếm khi có.
  trendingTpl = ''
    <span font_weight="bold" foreground="${c.base0E}" font_size="13pt">GitHub Trending</span>
    <span foreground="${c.base03}" font_size="9pt">daily · all languages</span>
    {{ range rss "${feedUrl}" ${toString itemCount} }}
    <span foreground="${c.base0D}">•</span> <span foreground="${c.base05}">{{ .Title }}</span>
    {{- end }}
  '';

  trendingScript = ''
    #!/usr/bin/env bash
    ${pkgs.markscribe}/bin/markscribe "$HOME/.config/nwg-wrapper/trending.tpl" 2>/dev/null \
      | ${pkgs.gnused}/bin/sed 's/&/\&amp;/g'
  '';

  styleCss = ''
    window {
      background-color: ${c.base00}d9;
      color: ${c.base05};
      border: 1px solid ${c.base03};
      border-radius: 12px;
      padding: 14px 20px;
      font-family: "${fonts.ui}";
      font-size: 11pt;
    }
  '';
in
{
  xdg.configFile = {
    "nwg-wrapper/trending.tpl".text = trendingTpl;
    "nwg-wrapper/style.css".text = styleCss;
    "nwg-wrapper/trending.sh" = {
      text = trendingScript;
      executable = true;
    };
  };
}
