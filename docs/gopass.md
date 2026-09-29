# Gopass

Password manager cá nhân, backend **age** (không dùng GPG), store là git repo sync lên Codeberg
(`levinhne/password-store`, private).

- Package: `home/dev/gopass.nix` — `gopass` 1.17.x + `gopass-jsonapi` từ `pkgs-unstable`, `age`, `ssh-to-age`,
  script `gopass-ssh-identity`.
- Browser: Chrome + extension [Gopass Bridge](https://chrome.google.com/webstore/detail/gopass-bridge/kkhfnlkhiapbiehimabddjbimfaijdhk);
  native-messaging manifest + wrapper do home-manager sinh ra.
- Store: `~/.password-store` (có `Makefile` riêng: `make -C ~/.password-store help`)
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

Recipients quản lý trong store (`.age-recipients`), không phụ thuộc `secrets/keys.nix`. Vì vậy:

- **Chỉ cần backup SSH key** (+ passphrase của nó). Mất file identities thì chạy lại `make identity`.
- Thêm máy/user = `make add KEY=...` (nhận `age1...`, `"ssh-ed25519 ..."` hoặc file `.pub`).
- Đánh đổi: một key dùng cho SSH + agenix + gopass — lộ key là lộ cả ba. Chỉ hỗ trợ ed25519.

## Setup (máy đầu tiên hoặc máy mới)

```bash
make gopass-init           # trong ~/nixos-dotfiles
```

Identity từ SSH key, rồi: remote có dữ liệu → `gopass clone` vào `~/.password-store`; remote trống →
`gopass init --path ~/.password-store`, chép `scripts/gopass-store.mk` vào store, commit, push.
Cuối cùng bật age agent. Máy mới dùng SSH key khác thì trước đó phải `make add KEY=...` ở máy đọc
được store. Makefile của store được track trong store; `scripts/gopass-store.mk` chỉ là bản gốc để init.

## Thêm máy / recipient

Trên máy đang đọc được store:

```bash
make -C ~/.password-store add KEY=~/path/to/new.pub   # hoặc KEY=age1... (age thuần)
make -C ~/.password-store sync
```

Trên máy mới: `make gopass-init` (SSH key). Age thuần: `gopass age identities keygen` rồi
`gopass clone --crypto age --path ~/.password-store <remote>`.

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
gopass sync                           # hoặc: make -C ~/.password-store sync
```

## Backup

- **SSH key ed25519** (`~/.ssh/id_ed25519`) + passphrase của nó — đủ để dựng lại identity.
- Store: đã có Codeberg; kiểm tra định kỳ bằng `gopass fsck`.
- File identities và passphrase gopass không bắt buộc phải backup (tạo lại được từ SSH key).

## Troubleshooting

| Lỗi | Nguyên nhân / cách xử lý |
|-----|--------------------------|
| `no identity matched any of the recipients` | Chưa có identity → `make identity`; hoặc key máy này chưa là recipient → `make add KEY=...` ở máy đọc được store |
| `incorrect passphrase` | Nhập nhầm passphrase gopass (khác passphrase SSH) |
| `Không đọc được ... (sai passphrase hoặc không phải ed25519)` | Sai passphrase SSH, hoặc key RSA |
| Extension không thấy gopass | `nrs`, restart Chrome, kiểm tra `~/.config/google-chrome/NativeMessagingHosts/com.justwatch.gopass.json` |
