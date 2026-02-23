# Agenix - Quản lý Secrets trong NixOS

Agenix cho phép bạn mã hóa secrets (passwords, API keys, SSH keys, etc.) và lưu trữ an toàn trong Git repository.

---

## ⚠️ QUAN TRỌNG: Backup & Restore

### 🔑 Những gì CẦN BACKUP

**CHỈ CẦN BACKUP 2 HOST PRIVATE KEYS:**

```
1. /etc/ssh/ssh_host_ed25519_key
2. /etc/ssh/ssh_host_rsa_key
```

**Tại sao?**
- Host private keys dùng để **decrypt secrets khi system boot**
- Mất host keys = **KHÔNG thể decrypt secrets** = System lỗi!
- User key (`~/.ssh/id_rsa`) có thể tạo lại, không critical

**Lưu backup ở đâu?**
- ✅ USB drive (encrypted)
- ✅ Password manager (1Password, Bitwarden, KeePass)
- ✅ Encrypted cloud storage
- ❌ **KHÔNG** commit vào Git
- ❌ **KHÔNG** lưu plaintext

---

### 📦 BACKUP: Lưu host keys

```bash
# Tạo backup folder
BACKUP_DIR=~/agenix-backup-$(date +%Y%m%d)
mkdir -p "$BACKUP_DIR"

# Copy 2 host private keys
sudo cp /etc/ssh/ssh_host_ed25519_key "$BACKUP_DIR/"
sudo cp /etc/ssh/ssh_host_rsa_key "$BACKUP_DIR/"

# Fix permissions
sudo chown -R $USER:users "$BACKUP_DIR/"
chmod 600 "$BACKUP_DIR"/*

echo "✅ Backup tại: $BACKUP_DIR"
echo "⚠️  Copy folder này vào USB hoặc password manager NGAY!"
```

---

### 🔄 RESTORE: Khôi phục lên máy mới

#### Scenario: Cài NixOS lên máy ảo hoặc máy mới

**Bước 1: Cài NixOS**
- Cài đặt NixOS bình thường
- Clone nixos-dotfiles repo

**Bước 2: Restore host private keys**

```bash
cd /home/levinhne/nixos-dotfiles

# Copy backup keys từ USB/password manager vào home
# Giả sử backup ở ~/agenix-backup/

# Restore 2 host private keys
sudo cp ~/agenix-backup/ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key
sudo cp ~/agenix-backup/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key

# Set permissions đúng (QUAN TRỌNG!)
sudo chmod 600 /etc/ssh/ssh_host_ed25519_key
sudo chmod 600 /etc/ssh/ssh_host_rsa_key
sudo chown root:root /etc/ssh/ssh_host_ed25519_key
sudo chown root:root /etc/ssh/ssh_host_rsa_key

# Generate public keys từ private keys
sudo ssh-keygen -y -f /etc/ssh/ssh_host_ed25519_key | sudo tee /etc/ssh/ssh_host_ed25519_key.pub
sudo ssh-keygen -y -f /etc/ssh/ssh_host_rsa_key | sudo tee /etc/ssh/ssh_host_rsa_key.pub
```

**Bước 3: Rebuild NixOS**

```bash
sudo nixos-rebuild switch --flake .#nixos-levinhne
```

**Bước 4: Verify secrets đã decrypt**

```bash
# Kiểm tra secrets folder
ls -la /run/agenix/

# Nếu thấy secrets → Success! ✅
# Nếu rỗng → Có lỗi, check lại keys ❌
```

---

### 🆘 Troubleshooting: Mất backup hoặc keys không match

**Nếu bạn KHÔNG có backup hoặc muốn dùng keys mới:**

```bash
# 1. Lấy host public key từ máy mới
cat /etc/ssh/ssh_host_ed25519_key.pub

# Output: ssh-ed25519 AAAA... root@hostname

# 2. Add vào secrets/secrets.nix
# Mở file secrets/secrets.nix, thêm:
nixos-new-machine = "ssh-ed25519 AAAA... root@hostname";
allHosts = [ nixos-levinhne nixos-new-machine ];  # Thêm vào list

# 3. Re-encrypt TẤT CẢ secrets với keys mới
cd secrets
for file in *.age; do
  nix run github:ryantm/agenix -- -r -e "$file"
done

# 4. Commit changes
git add secrets/*.age secrets/secrets.nix
git commit -m "Add new host key and re-encrypt secrets"

# 5. Rebuild
sudo nixos-rebuild switch --flake .#nixos-levinhne
```

---

### 📊 Hiểu về Keys trong Agenix

| Key Type | Path | Public Key | Dùng để? | Backup? |
|----------|------|------------|----------|---------|
| **User key** | `~/.ssh/id_rsa` | `~/.ssh/id_rsa.pub` | Developer encrypt/decrypt manual | ❌ Không (tạo lại được) |
| **Host key ED25519** | `/etc/ssh/ssh_host_ed25519_key` | `.pub` | System decrypt khi boot | ✅ **PHẢI!** |
| **Host key RSA** | `/etc/ssh/ssh_host_rsa_key` | `.pub` | System decrypt (fallback) | ✅ **PHẢI!** |

**Workflow:**
1. Encrypt với **PUBLIC keys** (cả user + host)
2. Developer decrypt bằng **user private key** (manual)
3. System decrypt bằng **host private keys** (auto khi boot)

---

## Cấu trúc

```
nixos-dotfiles/
├── secrets/
│   ├── secrets.nix              # Định nghĩa ai có thể decrypt
│   ├── ssh-key-example.age      # File đã mã hóa (example)
│   ├── github-token.age         # File đã mã hóa
│   └── wifi-password.age        # File đã mã hóa
├── system/
│   └── secrets.nix              # System module cho agenix
└── flake.nix                    # Đã tích hợp agenix
```

## Cách sử dụng

### 1. Tạo hoặc chỉnh sửa secret mới

```bash
cd /home/levinhne/nixos-dotfiles

# Tạo/edit secret mới
nix run github:ryantm/agenix -- -e secrets/my-secret.age

# Hoặc dùng agenix từ flake
nix run .#agenix -- -e secrets/my-secret.age
```

**Lưu ý:** Editor mặc định là `vim`. Để đổi editor:
```bash
EDITOR=nano nix run github:ryantm/agenix -- -e secrets/my-secret.age
```

### 2. Thêm secret vào `secrets/secrets.nix`

```nix
# Trong secrets/secrets.nix
{
  "my-secret.age".publicKeys = allKeys;  # Ai có thể decrypt
}
```

### 3. Sử dụng secret trong NixOS config

Mở file `system/secrets.nix` và uncomment + customize:

```nix
age.secrets.my-secret = {
  file = ../secrets/my-secret.age;     # Path đến file .age
  path = "/run/agenix/my-secret";      # Nơi file được decrypt
  mode = "600";                         # Permissions
  owner = "levinhne";                   # Owner
  group = "users";                      # Group
};
```

### 4. Sử dụng decrypted secret

Sau khi rebuild, secret sẽ được decrypt tại `/run/agenix/`:

```bash
# Đọc secret
cat /run/agenix/my-secret

# Dùng trong config
environment.variables.MY_SECRET = config.age.secrets.my-secret.path;

# Dùng trong script
#!/bin/bash
SECRET=$(cat ${config.age.secrets.my-secret.path})
```

## Examples

### Mã hóa SSH private key

```bash
# 1. Tạo secret cho SSH key
nix run github:ryantm/agenix -- -e secrets/ssh-private-key.age

# 2. Paste nội dung SSH key vào editor, save và exit

# 3. Add vào secrets/secrets.nix
"ssh-private-key.age".publicKeys = allKeys;

# 4. Configure trong system/secrets.nix
age.secrets.ssh-private-key = {
  file = ../secrets/ssh-private-key.age;
  path = "/home/levinhne/.ssh/id_rsa_encrypted";
  mode = "600";
  owner = "levinhne";
};
```

### Mã hóa GitHub token

```bash
# 1. Tạo secret
echo "ghp_xxxxxxxxxxxxx" | nix run github:ryantm/agenix -- -e secrets/github-token.age

# 2. Configure
age.secrets.github-token = {
  file = ../secrets/github-token.age;
  path = "/run/agenix/github-token";
  mode = "600";
  owner = "levinhne";
};

# 3. Dùng trong script
git config --global credential.helper "store --file=$(cat /run/agenix/github-token)"
```

### Mã hóa WiFi password

```bash
# 1. Tạo secret
nix run github:ryantm/agenix -- -e secrets/wifi-password.age

# 2. Configure
age.secrets.wifi-password = {
  file = ../secrets/wifi-password.age;
  path = "/run/agenix/wifi-password";
  mode = "600";
  owner = "root";
};

# 3. Dùng trong NetworkManager
networking.wireless.networks."MyWiFi".pskRaw = 
  builtins.readFile config.age.secrets.wifi-password.path;
```

## Quản lý keys

### Thêm host key mới (máy mới)

```bash
# 1. Lấy host key từ máy mới
ssh-keyscan hostname

# 2. Hoặc copy trực tiếp
cat /etc/ssh/ssh_host_ed25519_key.pub

# 3. Add vào secrets/secrets.nix
nixos-new-host = "ssh-ed25519 AAAA... root@nixos-new-host";
```

### Thêm user key mới

```bash
# 1. Lấy user SSH public key
cat ~/.ssh/id_rsa.pub

# 2. Add vào secrets/secrets.nix
newuser = "ssh-rsa AAAA... newuser@hostname";
allUsers = [ levinhne newuser ];
```

### Re-encrypt secrets khi thay đổi keys

```bash
# Re-encrypt tất cả secrets với keys mới
cd secrets
for file in *.age; do
  nix run github:ryantm/agenix -- -r -e "$file"
done
```

## Troubleshooting

### Lỗi: "no such file or directory: /etc/ssh/ssh_host_ed25519_key"

Máy chưa có host key. Tạo host key:

```bash
sudo ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
```

### Lỗi: "can't decrypt secret"

- Kiểm tra SSH key đã được add vào `secrets/secrets.nix` chưa
- Kiểm tra path đến SSH private key trong `system/secrets.nix`
- Re-encrypt secret với keys đúng

### Xem secret đã được decrypt chưa

```bash
ls -la /run/agenix/
```

## Best Practices

1. **KHÔNG commit SSH private keys** vào Git (chỉ commit `.age` files)
2. **Backup SSH private keys** dùng để encrypt (nếu mất keys, mất hết secrets)
3. **Dùng `.gitignore`** cho `*.age.bak` (backup files)
4. **Test trên máy dev** trước khi deploy lên production
5. **Document secrets** - ghi chú secret nào dùng để làm gì
6. **Rotate secrets** định kỳ và re-encrypt

## Commands cheat sheet

```bash
# Create/edit secret
nix run github:ryantm/agenix -- -e secrets/NAME.age

# Re-encrypt all secrets
nix run github:ryantm/agenix -- -r -e secrets/NAME.age

# Decrypt secret manually (debug)
age --decrypt -i ~/.ssh/id_rsa secrets/NAME.age

# List decrypted secrets
ls -la /run/agenix/

# Rebuild với secrets
sudo nixos-rebuild switch --flake .#nixos-levinhne
```

## Security Notes

- Secrets được decrypt vào RAM (`/run/agenix/`) khi boot
- Secrets bị xóa khi shutdown/reboot
- Chỉ owner có thể đọc secrets (mode 600)
- Host keys ở `/etc/ssh/` cần được protect
