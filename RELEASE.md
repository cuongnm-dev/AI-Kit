# Phát hành bản build lên kênh phân phối

Repo **ai-kit** là kênh phân phối công khai của AI Platform. Monorepo [AI-Platform](https://github.com/cuongnm-dev/AI-Platform) chỉ dùng để **build**; artifact **đăng tại đây**.

## Luồng tóm tắt

```text
1. Build trên máy maintainer (AI-Platform/)
2. Copy file từ release-dist/ → GitHub Release (repo ai-kit)
3. (Tuỳ chọn) Sync docs/ + scripts/ lên nhánh main
4. Tag release (vd. v1.11.6) — README và ai-kit update đều trỏ tag này
```

## 1. Build artifact

Trong monorepo `AI-Platform`:

```bash
# Chỉ ai-kit CLI (nhanh, mọi OS)
node scripts/build-release-local.mjs

# Thêm installer AI Studio cho OS hiện tại (chậm)
node scripts/build-release-local.mjs --studio

# Chỉ Studio
node scripts/build-release-local.mjs --studio-only
```

Output: `AI-Platform/release-dist/`

| File (ví dụ)                    | Nội dung                                      |
| ------------------------------- | --------------------------------------------- |
| `ai-kit-0.78.0.zip` / `.tar.gz` | CLI đóng gói + `docs/`                        |
| `AI Studio-1.11.6-x64.exe`      | Windows NSIS                                  |
| `AI Studio-1.11.6-arm64.dmg`    | macOS                                         |
| `AI Studio-1.11.6-x64.AppImage` | Linux                                         |
| `engine-config.enc`             | Bundle agents/skills (nếu có bước pack riêng) |

> macOS `.dmg` phải build trên Mac; Linux `.deb`/`.AppImage` trên Linux/WSL.

## 2. Tạo GitHub Release (repo ai-kit)

1. Vào **Releases → Draft a new release**
2. **Tag:** `v<ai-studio-version>` hoặc tag thống nhất team (vd. `v1.11.6`)
3. **Title:** `AI Platform v1.11.6` (hoặc mô tả ngắn)
4. **Attach binaries** — kéo thả toàn bộ file từ `release-dist/` (không commit vào git)
5. Publish

`ai-kit update` và script `install-ai-studio` đọc API:

`https://api.github.com/repos/cuongnm-dev/ai-kit/releases/latest`

## 3. Đồng bộ repo (nhánh main)

| Nguồn (monorepo)        | Đích (repo phân phối)                                  |
| ----------------------- | ------------------------------------------------------ |
| `packages/ai-kit/docs/` | `docs/`                                                |
| Script cài/gỡ đã chỉnh  | `scripts/install/`, `scripts/remove/`                  |
| Bootstrap               | `bootstrap.ps1`, `bootstrap.sh` (root — URL one-liner) |

Không đẩy file installer lớn vào git — chỉ Releases.

## 4. Checklist trước khi publish

- [ ] `ai-kit doctor` pass trên Windows + macOS mẫu
- [ ] AI Studio mở được sau cài từ Release
- [ ] `ai-kit update` nhận đúng tag mới
- [ ] Ghi changelog ngắn trong mô tả Release
- [ ] README tag/badge trùng version (nếu cập nhật tay)

## 5. Ghi chú bảo mật

- Release công khai: không đính kèm `.env`, key, `engine-config` chưa mã hoá nếu chứa bí mật team
- Installer chưa ký code → user chấp nhận cảnh báo SmartScreen/Gatekeeper lần đầu
