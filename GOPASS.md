# Gopass - Password Manager với Age Encryption

Gopass là password manager dòng lệnh mạnh mẽ, tương tự `pass` nhưng với nhiều tính năng hơn. Kết hợp với `age` encryption thay vì GPG để đơn giản và an toàn hơn.

## Tại sao dùng Gopass + Age?

- ✅ **Đơn giản hơn GPG**: Không cần quản lý GPG keys phức tạp
- ✅ **Tích hợp với agenix**: Dùng chung SSH keys
- ✅ **Git-based**: Sync passwords qua Git
- ✅ **Team-friendly**: Chia sẻ passwords an toàn
- ✅ **Cross-platform**: Linux, macOS, Windows

---

## Setup Gopass với Age

### 1. Cài đặt (đã có trong system packages)

Gopass và Age đã được cài đặt qua `modules/dev/packages.nix`:
- `gopass` - Password manager
- `age` - Encryption tool

### 2. Khởi tạo Gopass với Age

```bash
# Tạo age identity key (hoặc dùng SSH key có sẵn)
age-keygen -o ~/.config/age/key.txt

# Lấy public key
age-keygen -y ~/.config/age/key.txt

# Output: age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### 3. Init gopass store với age

```bash
# Initialize gopass với age encryption
gopass init --crypto age --storage gitfs

# Nó sẽ hỏi age public key, paste key từ bước 2

# Hoặc dùng SSH key trực tiếp (khuyên dùng)
gopass init --crypto age --storage gitfs "$(cat ~/.ssh/id_rsa.pub)"
```

### 4. Configure gopass

```bash
# Set age private key path
gopass config age.identities ~/.config/age/key.txt

# Hoặc dùng SSH private key
gopass config age.identities ~/.ssh/id_rsa

# Enable autosync với Git (optional)
gopass config autosync true
gopass config autopush true
```

---

## Sử dụng Gopass

### Thêm password mới

```bash
# Thêm password (gopass sẽ generate password random)
gopass insert -g github.com/username

# Thêm password manual
gopass insert github.com/username

# Thêm với multiline (username, password, URL, notes)
gopass insert -m work/email
# Nhập:
# Password: ********
# Username: user@company.com
# URL: https://mail.company.com
# Notes: Work email account
```

### Lấy password

```bash
# Show password
gopass show github.com/username

# Copy password vào clipboard (không show ra màn hình)
gopass show -c github.com/username

# Show chỉ password (không metadata)
gopass show -o github.com/username

# Show tất cả info (multiline)
gopass show -f github.com/username
```

### Quản lý passwords

```bash
# List tất cả passwords
gopass ls

# Search password
gopass search github

# Edit password
gopass edit github.com/username

# Delete password
gopass rm github.com/username

# Generate password mới (không save)
gopass generate 20

# Copy username
gopass show -c github.com/username username
```

### Sync với Git

```bash
# Add git remote
cd ~/.local/share/gopass/stores/root
git remote add origin git@github.com:username/password-store.git

# First push
git push -u origin main

# Sau đó gopass tự sync (nếu bật autosync)
# Hoặc manual:
gopass sync
```

---

## Tích hợp với Agenix

Gopass và Agenix có thể dùng chung SSH keys!

### Setup chung SSH key

```bash
# Gopass dùng SSH private key để encrypt
gopass config age.identities ~/.ssh/id_rsa

# Agenix cũng dùng SSH keys (đã setup trong secrets/secrets.nix)
# → Cùng 1 key, 2 công cụ!
```

### Workflow kết hợp

**Gopass**: Passwords cá nhân (GitHub, email, banks, etc.)
**Agenix**: System secrets (API keys, certificates, system configs)

```
~/.ssh/id_rsa (private key)
    ↓
    ├── Gopass → ~/.local/share/gopass/ (personal passwords)
    └── Agenix → /run/agenix/ (system secrets)
```

---

## Advanced Usage

### Multiple stores (work/personal)

```bash
# Create work store
gopass init --store work --crypto age --storage gitfs

# Add password to work store
gopass insert --store work company/vpn

# List stores
gopass stores

# Switch between stores
gopass ls work/
gopass ls
```

### Templates

```bash
# Create template cho database credentials
gopass insert -m templates/database
# Content:
# Password: {{.Password}}
# Host: localhost
# Port: 5432
# Username: admin
# Database: mydb

# Sử dụng template
gopass generate -t templates/database dev/postgres
```

### OTP (2FA)

```bash
# Add TOTP secret
gopass insert -m github.com/username
# Password: ********
# TOTP: otpauth://totp/GitHub:username?secret=JBSWY3DPEHPK3PXP

# Get OTP code
gopass otp github.com/username

# Copy OTP to clipboard
gopass otp -c github.com/username
```

### Sharing passwords (team)

```bash
# Add recipient (teammate's age public key)
gopass recipients add --store work age1xxxxxxxxxxxxx

# All passwords in 'work' store now encrypted cho cả 2 người
```

---

## Integration với Browser

### Setup gopass-jsonapi

```bash
# Install browser extension
# Firefox: https://addons.mozilla.org/en-US/firefox/addon/gopass-bridge/
# Chrome: https://chrome.google.com/webstore/detail/gopass-bridge/

# Setup jsonapi
gopass jsonapi configure

# Test
gopass jsonapi listen
```

Bây giờ browser có thể autofill passwords từ gopass!

---

## Backup & Restore

### Backup

Gopass store là Git repository, đã có version control!

```bash
# Store location
ls -la ~/.local/share/gopass/stores/root/

# Backup entire store
tar -czf gopass-backup-$(date +%Y%m%d).tar.gz ~/.local/share/gopass/

# Push to Git (best backup)
cd ~/.local/share/gopass/stores/root
git push origin main
```

### Restore

```bash
# Clone store từ Git
gopass clone git@github.com:username/password-store.git

# Hoặc restore từ backup
tar -xzf gopass-backup-YYYYMMDD.tar.gz -C ~/

# Set age identity
gopass config age.identities ~/.ssh/id_rsa
```

**⚠️ QUAN TRỌNG**: Backup age private key (hoặc SSH private key)!
- Nếu mất private key = mất tất cả passwords!
- Backup giống như agenix (xem `secrets/README.md`)

---

## Migration từ GPG sang Age

Nếu bạn đang dùng `pass` với GPG:

```bash
# Export passwords từ pass
pass git log --all > /tmp/pass-backup.txt

# Init gopass với age
gopass init --crypto age

# Import từ pass
gopass convert pass-to-gopass
```

---

## Security Best Practices

1. **Backup private keys**: Age key hoặc SSH key
2. **Use strong master password**: Nếu dùng age key với passphrase
3. **Git over SSH**: Dùng SSH authentication cho Git remote
4. **Private repository**: Đừng push passwords lên public repo!
5. **Audit history**: Kiểm tra git log định kỳ
6. **Rotate passwords**: Đổi passwords quan trọng định kỳ

---

## Commands Cheat Sheet

```bash
# Init
gopass init --crypto age --storage gitfs

# Add password
gopass insert -g website.com/username

# Get password
gopass show -c website.com/username

# List all
gopass ls

# Search
gopass search keyword

# Edit
gopass edit website.com/username

# Delete
gopass rm website.com/username

# Generate random password
gopass generate 20

# Sync
gopass sync

# Git operations
gopass git status
gopass git log
```

---

## Troubleshooting

### Lỗi: "failed to decrypt"

```bash
# Kiểm tra age identity
gopass config age.identities

# Set lại
gopass config age.identities ~/.ssh/id_rsa
```

### Lỗi: "no recipients"

```bash
# Add recipient (your age public key)
gopass recipients add age1xxxxxxxxxxxxx

# Hoặc re-init
gopass init --crypto age
```

### Show config

```bash
gopass config

# Reset về default
gopass config --reset
```

---

## So sánh: Gopass vs Agenix

| Feature | Gopass | Agenix |
|---------|--------|--------|
| **Use case** | Personal passwords | System secrets |
| **Location** | `~/.local/share/gopass/` | `/run/agenix/` |
| **Encryption** | Age (user key) | Age (host key) |
| **Access** | Manual (`gopass show`) | Auto decrypt khi boot |
| **Sync** | Git | Git (config files) |
| **Best for** | Passwords, credentials | API keys, certs, configs |

**Recommendation**: Dùng cả 2!
- **Gopass**: GitHub tokens, email passwords, bank passwords
- **Agenix**: System API keys, SSH keys, certificates

---

## Resources

- [Gopass Documentation](https://github.com/gopasspw/gopass)
- [Age Encryption](https://github.com/FiloSottile/age)
- [Gopass with Age](https://github.com/gopasspw/gopass/blob/master/docs/backends/age.md)
