# Makefile build NixOS cho nixos-dotfiles
# Dùng `make help` để xem danh sách lệnh

FLAKE   := ~/nixos-dotfiles
HOST    ?= $(shell hostname)

.DEFAULT_GOAL := help

.PHONY: help switch boot test build host-switch host-boot host-build \
        check update update-input gc gc-boot repl edit-secrets vm \
        gopass-init gopass-identity gopass-recipients gopass-remote gopass-sync cloudflared-add

help: ## Hiện danh sách lệnh
	@grep -E '^[a-zA-Z0-9_-]+:.*##' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*##"}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

switch: ## Rebuild + switch host hiện tại (HOST=$(HOST))
	sudo nixos-rebuild switch --flake $(FLAKE)\#$(HOST)

boot: ## Rebuild, áp dụng ở lần boot kế tiếp (không switch ngay)
	sudo nixos-rebuild boot --flake $(FLAKE)\#$(HOST)

test: ## Rebuild + switch tạm thời, mất khi reboot
	sudo nixos-rebuild test --flake $(FLAKE)\#$(HOST)

build: ## Build config, không switch/activate
	nixos-rebuild build --flake $(FLAKE)\#$(HOST)

host-switch: ## Rebuild + switch host chỉ định: make host-switch HOST=nixos-vinhlq21
	sudo nixos-rebuild switch --flake $(FLAKE)\#$(HOST)

host-boot: ## Rebuild boot cho host chỉ định: make host-boot HOST=nixos-vinhlq21
	sudo nixos-rebuild boot --flake $(FLAKE)\#$(HOST)

host-build: ## Build (không switch) cho host chỉ định
	nixos-rebuild build --flake $(FLAKE)\#$(HOST)

vm: ## Build và chạy thử trong VM (nixos-rebuild build-vm)
	nixos-rebuild build-vm --flake $(FLAKE)\#$(HOST)

check: ## Kiểm tra flake có lỗi cú pháp/eval không
	nix flake check $(FLAKE)

update: ## Update toàn bộ flake inputs
	nix flake update --flake $(FLAKE)

update-input: ## Update 1 input cụ thể: make update-input INPUT=nixpkgs
	nix flake lock --update-input $(INPUT) $(FLAKE)

gc: ## Xoá generation cũ + garbage collect
	sudo nix-collect-garbage -d

gc-boot: ## Xoá boot entries cũ sau khi gc
	sudo /run/current-system/bin/switch-to-configuration boot

edit-secrets: ## Sửa 1 secret agenix: make edit-secrets FILE=secrets/my-secret.age
	agenix -e $(FILE)

repl: ## Mở nix repl với flake này đã load sẵn
	nix repl --expr "builtins.getFlake \"$(FLAKE)\""

# --- Gopass (xem docs/gopass.md) ---

GOPASS_STORE   := ~/.local/share/gopass/stores/root
GOPASS_SSH_KEY ?= ~/.ssh/id_ed25519
# Recipients = user SSH keys trong secrets/keys.nix, đổi sang age1... bằng ssh-to-age.
GOPASS_KEYS = nix eval --raw --file $(FLAKE)/secrets/keys.nix users \
	--apply 'u: builtins.concatStringsSep "\n" (builtins.attrValues u)'

# Identity age suy ra từ SSH key (ssh-to-age) -> chỉ cần backup SSH key. Xem docs/gopass.md.
gopass-init: ## Init store mới, identity từ SSH key: make gopass-init [REMOTE=ssh://git@codeberg.org/...] [GOPASS_SSH_KEY=~/.ssh/id_ed25519]
	@test ! -e $(GOPASS_STORE) || { echo "Store đã tồn tại: $(GOPASS_STORE)"; exit 1; }
	gopass-ssh-identity $(GOPASS_SSH_KEY)
	gopass init --crypto age --storage gitfs "$$(ssh-to-age -i $(GOPASS_SSH_KEY).pub)"
	$(MAKE) gopass-recipients
	@if [ -n "$(REMOTE)" ]; then $(MAKE) gopass-remote REMOTE=$(REMOTE); fi

gopass-identity: ## Thêm identity từ SSH key vào gopass (máy mới / đổi key): make gopass-identity [GOPASS_SSH_KEY=...]
	gopass-ssh-identity $(GOPASS_SSH_KEY)

gopass-recipients: ## Thêm mọi user key trong secrets/keys.nix làm recipient (re-encrypt store)
	@keys=$$($(GOPASS_KEYS)) || exit 1; \
	printf '%s\n' "$$keys" | while read -r k; do \
		[ -n "$$k" ] || continue; \
		r=$$(printf '%s\n' "$$k" | ssh-to-age); \
		grep -qxF "$$r" $(GOPASS_STORE)/.age-recipients && continue; \
		echo "+ $$r ($${k##* })"; gopass --yes recipients add "$$r" </dev/tty; \
	done

gopass-remote: ## Set git remote cho store rồi push lần đầu: make gopass-remote REMOTE=ssh://git@codeberg.org/user/repo.git
	gopass git remote add origin $(REMOTE)
	gopass git push -u origin main

gopass-sync: ## Sync gopass store với git remote (pull + push)
	gopass sync

# --- Cloudflared ---

cloudflared-add: ## Thêm domain->port vào cloudflared + tạo DNS route trên Cloudflare: make cloudflared-add DOMAIN=foo.levinh.io.vn PORT=8080 [HOST=nixos-levinhne]
	@test -n "$(DOMAIN)" || { echo "Thiếu DOMAIN. VD: make cloudflared-add DOMAIN=foo.levinh.io.vn PORT=8080"; exit 1; }
	@test -n "$(PORT)" || { echo "Thiếu PORT. VD: make cloudflared-add DOMAIN=foo.levinh.io.vn PORT=8080"; exit 1; }
	@FILE=hosts/$(HOST)/cloudflared.nix; \
	test -f "$$FILE" || { echo "Không tìm thấy $$FILE"; exit 1; }; \
	grep -q '"$(DOMAIN)"' "$$FILE" && { echo "Domain $(DOMAIN) đã tồn tại trong $$FILE"; exit 1; } || true; \
	TUNNEL=$$(awk '/tunnels = \{/{getline; gsub(/^[ \t]*"|".*/, ""); print; exit}' "$$FILE"); \
	test -n "$$TUNNEL" || { echo "Không xác định được tunnel id/name trong $$FILE"; exit 1; }; \
	sed -i '/ingress = {/a\          "$(DOMAIN)" = "http://localhost:$(PORT)";' "$$FILE"; \
	echo "Đã thêm \"$(DOMAIN)\" -> http://localhost:$(PORT) vào $$FILE"; \
	echo "Tạo DNS route trên Cloudflare cho tunnel $$TUNNEL ..."; \
	cloudflared tunnel route dns "$$TUNNEL" "$(DOMAIN)" || { echo "Lỗi tạo DNS route. Kiểm tra 'cloudflared tunnel login' đã chạy chưa."; exit 1; }; \
	echo "Chạy 'make switch' (hoặc nrs) để áp dụng ingress mới."
