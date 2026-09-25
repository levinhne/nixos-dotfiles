# Gopass

Password manager cá nhân, backend **age** (không dùng GPG), store là git repo sync lên Codeberg
(`levinhne/password-store`, private).

- Package: `home/dev/gopass.nix` — `gopass` 1.17.x + `gopass-jsonapi` từ `pkgs-unstable`, `age`, `ssh-to-age`,
  script `gopass-ssh-identity`.
- Browser: Chrome + extension [Gopass Bridge](https://chrome.google.com/webstore/detail/gopass-bridge/kkhfnlkhiapbiehimabddjbimfaijdhk);
  native-messaging manifest + wrapper do home-manager sinh ra.
- Store: `~/.local/share/gopass/stores/root`
- Identity: `~/.config/gopass/age/identities` (age, mã hoá bằng passphrase gopass).

## Identity suy ra từ SSH key

gopass không nhận SSH key trực tiếp làm identity (`gopass init <ssh pubkey>` báo
`none of the recipients has a secret key`, đã thử 1.16.1 và 1.17.3). Thay vào đó dùng
[`ssh-to-age`](https://github.com/Mic92/ssh-to-age) để đổi SSH key **ed25519** thành age key một cách
tất định:

- `ssh-to-age -i ~/.ssh/id_ed25519.pub` → recipient `age1...`
- `ssh-to-age -private-key -i ~/.ssh/id_ed25519` → identity `AGE-SECRET-KEY-...`

`gopass-ssh-identity [key]` hỏi passphrase SSH, suy ra identity và **gộp** vào file identities
(không ghi đè identity cũ), rồi in recipient `age1...`.

Recipients của store = các user key trong `secrets/keys.nix` (dùng chung với agenix). Vì vậy:

- **Chỉ cần backup SSH key** (+ passphrase của nó). Mất file identities thì chạy lại `make gopass-identity`.
- Thêm máy/user = thêm SSH key vào `secrets/keys.nix` rồi `make gopass-recipients`.
- Đánh đổi: một key dùng cho SSH + agenix + gopass — lộ key là lộ cả ba. Chỉ hỗ trợ ed25519.

## Setup máy đầu tiên

```bash
# Repo private trống trên Codeberg, rồi:
make gopass-init REMOTE=ssh://git@codeberg.org/levinhne/password-store.git
```

Prompt lần lượt: passphrase SSH key → đặt passphrase gopass (2 lần) → mở identity khi re-encrypt
(passphrase gopass). `gopass-init` = `gopass-ssh-identity` + `gopass init <age1 của máy này>`
+ `gopass-recipients` + `gopass-remote`.

## Thêm máy thứ hai

SSH key của máy đó phải có trong `secrets/keys.nix` → `users` (và `make gopass-recipients` đã chạy ở
máy đang đọc được store, rồi `gopass sync`). Trên máy mới:

```bash
make gopass-identity
gopass clone ssh://git@codeberg.org/levinhne/password-store.git
```

## Chuyển store đang dùng age key riêng của gopass sang SSH key

```bash
make gopass-identity                 # thêm identity từ SSH key (giữ identity cũ)
make gopass-recipients               # thêm recipients từ secrets/keys.nix + re-encrypt
gopass recipients remove age1...     # (tuỳ chọn) bỏ key age cũ khỏi recipients
gopass age identities rm             # (tuỳ chọn) bỏ key age cũ khỏi identities
gopass sync
```

## Dùng hằng ngày

```bash
gopass insert website.com/user        # nhập tay
gopass generate website.com/user 24   # sinh password
gopass edit website.com/user          # thêm dòng "user: ...", "url: ...", "totp: otpauth://..."
gopass show -c website.com/user       # copy password (tự xoá clipboard sau 45s)
gopass show -c website.com/user user  # copy field "user"
gopass otp -c website.com/user        # copy mã TOTP
gopass ls / gopass find github
gopass rm website.com/user
gopass sync                           # hoặc: make gopass-sync
```

## Backup

- **SSH key ed25519** (`~/.ssh/id_ed25519`) + passphrase của nó — đủ để dựng lại identity.
- Store: đã có Codeberg; kiểm tra định kỳ bằng `gopass fsck`.
- File identities và passphrase gopass không bắt buộc phải backup (tạo lại được từ SSH key).

## Troubleshooting

| Lỗi | Nguyên nhân / cách xử lý |
|-----|--------------------------|
| `no identity matched any of the recipients` | Chưa có identity → `make gopass-identity`; hoặc key máy này chưa là recipient → `make gopass-recipients` ở máy đọc được store |
| `incorrect passphrase` | Nhập nhầm passphrase gopass (khác passphrase SSH) |
| `Không đọc được ... (sai passphrase hoặc không phải ed25519)` | Sai passphrase SSH, hoặc key RSA |
| Extension không thấy gopass | `nrs`, restart Chrome, kiểm tra `~/.config/google-chrome/NativeMessagingHosts/com.justwatch.gopass.json` |
