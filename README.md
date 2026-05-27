<div align="center">

# AI Platform — Kênh phân phối

**Repo GitHub công khai này là nơi team tải bản build, chạy cài đặt và gỡ sản phẩm.** Không có máy chủ riêng — chỉ [Releases](https://github.com/cuongnm-dev/ai-kit/releases) + script trong repo.

[![Latest release](https://img.shields.io/github/v/release/cuongnm-dev/ai-kit?label=release&sort=semver)](https://github.com/cuongnm-dev/ai-kit/releases/latest)

[Tải bản build](#-tải-bản-build) · [Cài đặt](#-cài-đặt) · [Gỡ toàn bộ](#-gỡ-cài-đặt) · [Hướng dẫn](#-hướng-dẫn) · [Phát hành](RELEASE.md)

</div>

---

## Repo này là gì?

| Vai trò             | Mô tả                                                                                        |
| ------------------- | -------------------------------------------------------------------------------------------- |
| **Kênh phân phối**  | File cài (ai-studio, ai-kit, engine-config, MCP image…) đăng lên **GitHub Releases**         |
| **Script vận hành** | Cài: `bootstrap.*` · Gỡ: [`remove-all-products.*`](#-gỡ-cài-đặt) · chi tiết trong `scripts/` |
| **Trang hướng dẫn** | `README.md` (file này) + `docs/` sau khi đồng bộ từ monorepo                                 |

Mã nguồn phát triển nằm ở monorepo nội bộ [AI-Platform](https://github.com/cuongnm-dev/AI-Platform). **Người dùng cuối không cần clone monorepo** — chỉ cần repo này.

```
  AI-Platform (dev)                    ai-kit repo (phân phối)
  ─────────────────                    ───────────────────────
  build local / CI  ──copy artifacts──►  GitHub Releases
  packages/ai-kit/docs ──sync────────►  docs/
  (tùy chọn) scripts ──copy──────────►  scripts/install|remove/
```

---

## Bộ sản phẩm phân phối qua repo này

| Sản phẩm          | Định dạng trên Releases                                                                  | Cài bằng                                                                                        |
| ----------------- | ---------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| **AI Studio**     | `.exe` / `.dmg` / `.zip` / `.AppImage` / `.deb` — tên `AI Studio-<version>-<arch>.<ext>` | Tải tay hoặc [`scripts/install/install-ai-studio.*`](scripts/install/)                          |
| **ai-kit**        | `ai-kit-<version>.zip` / `.tar.gz`                                                       | [`bootstrap.ps1`](bootstrap.ps1) / [`bootstrap.sh`](bootstrap.sh) hoặc giải nén + `install.ps1` |
| **engine-config** | `engine-config.enc` (bundle agents/skills)                                               | Kèm release; `ai-kit update` tải tự động                                                        |
| **ai-mcp**        | Docker image tag (qua `ai-kit mcp`)                                                      | Bootstrap / `ai-kit update`                                                                     |

**ai-engine** không ship installer riêng — chạy qua ai-studio (sidecar) hoặc stack do ai-kit triển khai.

---

## Tải bản build

Vào **[Releases](https://github.com/cuongnm-dev/ai-kit/releases/latest)** → chọn tag (vd. `v1.11.6`) → tải file theo OS:

| OS          | AI Studio                           | ai-kit CLI        |
| ----------- | ----------------------------------- | ----------------- |
| **Windows** | `AI Studio-*-x64.exe` (hoặc arm64)  | `ai-kit-*.zip`    |
| **macOS**   | `AI Studio-*-arm64.dmg` / `x64.dmg` | `ai-kit-*.tar.gz` |
| **Linux**   | `AI Studio-*-x64.AppImage` / `.deb` | `ai-kit-*.tar.gz` |

> Bản build được **copy từ** `AI-Platform/release-dist/` (sau `node scripts/build-release-local.mjs`) lên Release. Quy trình maintainer: [RELEASE.md](RELEASE.md).

---

## Cài đặt

### Cách 1 — Cả stack team (ai-kit + engine + MCP) — khuyến nghị lần đầu

**Windows**

```powershell
irm https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/bootstrap.ps1 | iex
```

**macOS / Linux**

```bash
curl -sL https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/bootstrap.sh | bash
```

Yêu cầu: Node.js ≥ 18, Docker, git. Sau cài: `ai-kit doctor`.

### Cách 2 — Chỉ AI Studio (desktop)

Tải installer từ Releases, chạy file cài — hoặc:

```powershell
# Windows
irm https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/scripts/install/install-ai-studio.ps1 | iex
```

```bash
# macOS / Linux
curl -sL https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/scripts/install/install-ai-studio.sh | bash
```

### Cách 3 — Chỉ ai-kit (đã có bản zip/tar.gz)

Giải nén release, chạy `install.ps1` / `install.sh` trong gói, hoặc thêm `bin/` vào PATH.

### Cập nhật sau khi đã cài

```bash
ai-kit update          # engine-config + MCP theo release mới nhất
ai-kit check-update    # chỉ kiểm tra
```

AI Studio: mở app → Check for updates, hoặc tải installer mới từ Releases.

---

## Gỡ cài đặt

### Gỡ toàn bộ sản phẩm (khuyến nghị)

Script ở **thư mục gốc** — xóa toàn bộ cài đặt và config toàn cục: ai-kit, AI Studio, ai-engine, ai-mcp, OpenCode/engine legacy (`~/.ai-kit`, `~/.config/ai-*`, AppData, registry trên Windows, …).

| File                                                 | Mô tả                                  |
| ---------------------------------------------------- | -------------------------------------- |
| [`remove-all-products.ps1`](remove-all-products.ps1) | Windows — xóa thư mục + registry HKCU  |
| [`remove-all-products.sh`](remove-all-products.sh)   | macOS / Linux — xóa app, config, cache |

**One-liner**

```powershell
# Windows — tải và chạy (khuyến nghị khi cần -DryRun / -Yes)
$i = "$env:TEMP\remove-all-products.ps1"
irm https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/remove-all-products.ps1 -OutFile $i

# Xem trước, không xóa
& $i -DryRun

# Xóa thật (nhập Y khi được hỏi)
& $i

# Bỏ qua xác nhận
& $i -Yes
```

```bash
# macOS / Linux — xem trước
curl -sL https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/remove-all-products.sh | bash -s -- --dry-run

# macOS / Linux — xóa thật
curl -sL https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/remove-all-products.sh | bash

# macOS / Linux — bỏ qua xác nhận
curl -sL https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/remove-all-products.sh | bash -s -- --yes
```

**Tham số**

| Tham số                     | `remove-all-products.ps1` | `remove-all-products.sh` |
| --------------------------- | ------------------------- | ------------------------ |
| Xem trước, không xóa        | `-DryRun`                 | `--dry-run`              |
| Bỏ qua xác nhận             | `-Yes`                    | `--yes`                  |
| Thư mục user giả lập (test) | `-Root <path>`            | `--root <path>`          |

> Sau khi gỡ, gỡ app AI Studio trong **Settings → Apps** (Windows) nếu installer NSIS vẫn còn mục trong danh sách ứng dụng.

### Gỡ từng phần (tùy chọn)

| Phạm vi                    | Windows                                                                      | macOS / Linux                                                              |
| -------------------------- | ---------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| Stack + MCP container      | [`scripts/remove/remove-all.ps1`](scripts/remove/remove-all.ps1)             | [`scripts/remove/remove-all.sh`](scripts/remove/remove-all.sh)             |
| Chỉ ai-kit (`~/.ai-kit`)   | [`scripts/remove/remove-ai-kit.ps1`](scripts/remove/remove-ai-kit.ps1)       | [`scripts/remove/remove-ai-kit.sh`](scripts/remove/remove-ai-kit.sh)       |
| Chỉ AI Studio (data / app) | [`scripts/remove/remove-ai-studio.ps1`](scripts/remove/remove-ai-studio.ps1) | [`scripts/remove/remove-ai-studio.sh`](scripts/remove/remove-ai-studio.sh) |

Đã cài CLI: `ai-kit uninstall --yes` — chỉ gỡ `~/.ai-kit`, không dọn Studio hay config engine.

---

## Hướng dẫn

Tài liệu dùng nằm trong [`docs/`](docs/) (đồng bộ từ `AI-Platform/packages/ai-kit/docs`). Trên máy đã cài: `ai-kit doc`.

| Nhu cầu           | File                                                                                |
| ----------------- | ----------------------------------------------------------------------------------- |
| Bắt đầu SDLC      | [`docs/on-board-sdlc.md`](docs/on-board-sdlc.md)                                    |
| Tài liệu nhà nước | [`docs/on-board-tailieu.md`](docs/on-board-tailieu.md)                              |
| FAQ / lỗi         | [`docs/faq.md`](docs/faq.md) · [`docs/troubleshooting.md`](docs/troubleshooting.md) |

---

## Cấu trúc repo

```
.
├── README.md                      ← Trang phân phối (file này)
├── RELEASE.md                     ← Quy trình đăng bản build lên Releases
├── bootstrap.ps1 / .sh            ← Cài stack team
├── remove-all-products.ps1 / .sh  ← Gỡ toàn bộ sản phẩm + config (trang chủ)
├── scripts/
│   ├── install/                   ← Cài Studio, ai-kit, bootstrap
│   └── remove/                    ← Gỡ từng phần (remove-ai-kit, remove-ai-studio, …)
├── docs/                          ← Hướng dẫn (sync từ monorepo)
└── (không commit .exe/.dmg — chỉ trên Releases)
```

---

## Hỗ trợ

1. `ai-kit doctor` (nếu đã cài stack CLI)
2. [`docs/troubleshooting.md`](docs/troubleshooting.md)
3. [Issues](https://github.com/cuongnm-dev/ai-kit/issues)

---

<div align="center">

**AI Platform** — một kênh GitHub, đủ bản build và script cho cả team.

</div>
