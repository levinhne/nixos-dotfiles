# Makefile build NixOS cho nixos-dotfiles
# Dùng `make help` để xem danh sách lệnh

FLAKE   := ~/nixos-dotfiles
HOST    ?= $(shell hostname)

.DEFAULT_GOAL := help

.PHONY: help switch boot test build host-switch host-boot host-build \
        check fmt lint update update-input gc gc-boot repl edit-secrets vm \
        gopass-init cloudflared-add

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

fmt: ## Format toàn bộ file .nix (nix fmt -> nixpkgs-fmt)
	cd $(FLAKE) && nix fmt .

lint: ## Tìm anti-pattern (statix) + code chết (deadnix)
	nix run nixpkgs#statix -- check $(FLAKE)
	nix run nixpkgs#deadnix -- --fail $(FLAKE)

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
# Chỉ bootstrap store; lệnh hằng ngày nằm trong Makefile của store: make -C ~/.password-store help

GOPASS_STORE   := $(HOME)/.password-store
GOPASS_REMOTE  ?= ssh://git@codeberg.org/levinhne/password-store.git
GOPASS_SSH_KEY ?= ~/.ssh/id_ed25519

gopass-init: ## Setup gopass store ~/.password-store (remote có dữ liệu -> clone, trống -> init mới): make gopass-init [GOPASS_SSH_KEY=...]
	@test ! -e $(GOPASS_STORE)/.age-recipients || { echo "Store đã setup: $(GOPASS_STORE)"; exit 1; }
	gopass-ssh-identity $(GOPASS_SSH_KEY)
	@if git ls-remote --exit-code --heads $(GOPASS_REMOTE) >/dev/null 2>&1; then \
		echo "Remote có dữ liệu -> clone"; \
		test ! -e $(GOPASS_STORE) || mv $(GOPASS_STORE) $(GOPASS_STORE).bak.$$(date +%s); \
		gopass clone --crypto age --path $(GOPASS_STORE) $(GOPASS_REMOTE); \
	else \
		echo "Remote trống -> init mới"; \
		gopass init --crypto age --storage gitfs --path $(GOPASS_STORE) "$$(ssh-to-age -i $(GOPASS_SSH_KEY).pub)"; \
		git -C $(GOPASS_STORE) remote get-url origin >/dev/null 2>&1 || git -C $(GOPASS_STORE) remote add origin $(GOPASS_REMOTE); \
		cp $(FLAKE)/scripts/gopass-store.mk $(GOPASS_STORE)/Makefile; \
		git -C $(GOPASS_STORE) add Makefile && git -C $(GOPASS_STORE) commit -m "Add Makefile"; \
		git -C $(GOPASS_STORE) push -u origin main; \
	fi
	gopass config age.agent-enabled true

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
