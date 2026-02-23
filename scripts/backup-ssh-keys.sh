#!/usr/bin/env bash
#
# Backup SSH private keys for agenix
# These keys are CRITICAL - without them you cannot decrypt secrets!
#

set -e

BACKUP_DIR="${HOME}/ssh-keys-backup-$(date +%Y%m%d)"
HOSTNAME=$(hostname)

echo "🔐 Backing up SSH private keys for agenix..."

# Create backup directory
mkdir -p "$BACKUP_DIR"
chmod 700 "$BACKUP_DIR"

# Backup user SSH key
if [ -f ~/.ssh/id_rsa ]; then
    cp ~/.ssh/id_rsa "$BACKUP_DIR/user_id_rsa"
    chmod 600 "$BACKUP_DIR/user_id_rsa"
    echo "✅ Backed up: ~/.ssh/id_rsa"
else
    echo "⚠️  Not found: ~/.ssh/id_rsa"
fi

if [ -f ~/.ssh/id_ed25519 ]; then
    cp ~/.ssh/id_ed25519 "$BACKUP_DIR/user_id_ed25519"
    chmod 600 "$BACKUP_DIR/user_id_ed25519"
    echo "✅ Backed up: ~/.ssh/id_ed25519"
fi

# Backup host SSH keys (requires sudo)
echo ""
echo "Backing up host keys (requires sudo)..."

if sudo test -f /etc/ssh/ssh_host_ed25519_key; then
    sudo cp /etc/ssh/ssh_host_ed25519_key "$BACKUP_DIR/host_ed25519_key"
    sudo chown $USER:users "$BACKUP_DIR/host_ed25519_key"
    chmod 600 "$BACKUP_DIR/host_ed25519_key"
    echo "✅ Backed up: /etc/ssh/ssh_host_ed25519_key"
else
    echo "⚠️  Not found: /etc/ssh/ssh_host_ed25519_key"
fi

if sudo test -f /etc/ssh/ssh_host_rsa_key; then
    sudo cp /etc/ssh/ssh_host_rsa_key "$BACKUP_DIR/host_rsa_key"
    sudo chown $USER:users "$BACKUP_DIR/host_rsa_key"
    chmod 600 "$BACKUP_DIR/host_rsa_key"
    echo "✅ Backed up: /etc/ssh/ssh_host_rsa_key"
else
    echo "⚠️  Not found: /etc/ssh/ssh_host_rsa_key"
fi

# Create README
cat > "$BACKUP_DIR/README.txt" << EOF
SSH Keys Backup for Agenix - $HOSTNAME
Created: $(date)

⚠️  CRITICAL BACKUP - KEEP SAFE! ⚠️

These SSH private keys are required to decrypt all your agenix secrets.
If you lose these keys, you will LOSE ACCESS to all encrypted secrets!

Files in this backup:
- user_id_rsa           : User SSH private key
- user_id_ed25519       : User SSH private key (ED25519)
- host_ed25519_key      : Host SSH private key
- host_rsa_key          : Host SSH private key (RSA)

How to restore:
1. Copy user keys back to ~/.ssh/
2. Copy host keys back to /etc/ssh/ (requires sudo)
3. Set correct permissions:
   chmod 600 ~/.ssh/id_rsa
   sudo chmod 600 /etc/ssh/ssh_host_*_key

Storage recommendations:
- USB drive (encrypted)
- Password manager (1Password, Bitwarden)
- Secure cloud storage (encrypted)
- Print QR codes (for air-gapped backup)

DO NOT:
- Store in Git repository
- Store in unencrypted cloud storage
- Email to yourself
- Store on same disk as system
EOF

echo ""
echo "✅ Backup completed!"
echo "📁 Location: $BACKUP_DIR"
echo ""
echo "⚠️  IMPORTANT: Copy this folder to a SAFE location:"
echo "   - USB drive (encrypted)"
echo "   - Password manager"
echo "   - Secure cloud storage"
echo ""
echo "📋 Read: $BACKUP_DIR/README.txt for restore instructions"
