# Makefile cho gopass store (age + git). Dùng `make help` để xem lệnh.
# Identity age suy ra từ SSH key ed25519 (ssh-to-age) -> chỉ cần backup SSH key.
# `gopass-ssh-identity` do nixos-dotfiles cài (home/dev/gopass.nix).
# Bootstrap store (init/clone): `make gopass-init` trong ~/nixos-dotfiles.

STORE   := $(CURDIR)
SSH_KEY ?= ~/.ssh/id_ed25519

.DEFAULT_GOAL := help

.PHONY: help identity add rm list sync fsck

help: ## Hiện danh sách lệnh
	@grep -E '^[a-zA-Z0-9_-]+:.*##' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*##"}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

identity: ## Thêm identity từ SSH key (máy mới / đổi key): make identity [SSH_KEY=...]
	gopass-ssh-identity $(SSH_KEY)

# KEY nhận: age1..., "ssh-ed25519 AAAA...", hoặc đường dẫn file .pub
add: ## Thêm recipient + re-encrypt store: make add KEY=age1...|"ssh-ed25519 ..."|path.pub
	@test -n "$(KEY)" || { echo "Thiếu KEY"; exit 1; }
	@k='$(KEY)'; [ -f "$$k" ] && k=$$(cat "$$k"); \
	case "$$k" in age1*) r="$$k" ;; *) r=$$(printf '%s\n' "$$k" | ssh-to-age) || exit 1 ;; esac; \
	if grep -qxF "$$r" $(STORE)/.age-recipients; then echo "Đã có: $$r"; exit 0; fi; \
	echo "+ $$r"; gopass --yes recipients add "$$r" </dev/tty

rm: ## Gỡ recipient + re-encrypt store: make rm R=age1...
	@test -n "$(R)" || { echo "Thiếu R"; exit 1; }
	gopass --yes recipients remove "$(R)" </dev/tty

list: ## Liệt kê recipients
	@cat $(STORE)/.age-recipients

sync: ## Sync với remote (pull + push)
	gopass sync

fsck: ## Kiểm tra store
	gopass fsck
