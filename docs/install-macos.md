# Cài AI Studio trên macOS

AI Studio cho macOS được **ad-hoc signed** (chữ ký nội bộ không qua Apple Developer Program). Gatekeeper sẽ chặn lần đầu chạy — làm theo các bước dưới để bypass.

## Bước 1: Tải installer

Tải file `.dmg` từ [Releases](https://github.com/cuongnm-dev/ai-kit/releases):

- **Apple Silicon (M1/M2/M3/M4)**: `AI-Studio-*-arm64.dmg`
- **Intel (x86_64)**: `AI-Studio-*-x64.dmg`

## Bước 2: Cài đặt

1. Double-click `.dmg` → mount
2. Kéo "AI Studio" vào folder **Applications**
3. Eject DMG

## Bước 2 (sửa): trước khi mount DMG, gỡ quarantine

⚠️ **Đừng double-click file `.dmg` ngay**. Nếu mount rồi double-click "AI Studio" trong cửa sổ DMG → macOS show dialog `"AI Studio" bị hỏng và không thể mở được. Bạn nên tháo ảnh đĩa này.` Đây là Gatekeeper chặn binary ad-hoc signed có quarantine attribute (Chrome/Safari đặt khi download).

Mở Terminal (⌘+Space → gõ "Terminal" → Enter), chạy **TRƯỚC** khi mount:

```bash
xattr -dr com.apple.quarantine ~/Downloads/AI-Studio-*.dmg
```

Sau đó mount DMG, drag "AI Studio" → folder **Applications**, eject DMG. Mở AI Studio bình thường.

## Bước 3 (recovery): nếu trót mở DMG → gặp dialog "bị hỏng"

Có 2 phiên bản dialog tuỳ tình huống:
- `"AI Studio" bị hỏng và không thể mở được. Bạn nên tháo ảnh đĩa này.` — khi double-click app trong DMG
- `"AI Studio" bị hỏng và không thể mở được. Bạn nên di chuyển ứng dụng vào Thùng rác.` — khi mở app đã install trong Applications

**Cả 2 case**: click **Hủy** (đừng click "Tháo Ảnh đĩa" / "Chuyển vào Thùng rác").

Recovery:

1. Nếu chưa drag vào Applications: drag "AI Studio" từ DMG → **Applications** → Eject DMG
2. Terminal:
   ```bash
   xattr -dr com.apple.quarantine /Applications/AI\ Studio.app
   ```
3. Mở AI Studio bình thường

### Tại sao macOS Sequoia bắt buộc Terminal?

Trên macOS Sonoma 13 trở xuống, member có thể workaround bằng **right-click → Open** → dialog cảnh báo → click **Open**.

macOS Sequoia (14+) đã **bỏ option này** cho ad-hoc signed apps có quarantine. Apple chỉ cho phép apps notarized bypass dialog. Nên tạm thời phải dùng `xattr` qua Terminal cho tới khi maintainer enroll Apple Developer Program.

> Lưu ý: dùng `-dr` (recursive) thay vì `-d` vì AI Studio là `.app` bundle (directory chứa nhiều file con). Mỗi lần download bản update phải chạy lại lệnh này.

## Bước 4: Cài AI Engine (lần đầu)

Mở AI Studio sẽ báo "Engine chưa cài". Mở Terminal:

```bash
ai-kit install engine
```

Quay lại AI Studio, refresh.

## Bước 5: Cấp API key

Liên hệ maintainer team để nhận Anthropic API key.

> ⛔ **KHÔNG dùng** tài khoản Claude Pro/Max cá nhân.

## Verify chữ ký (tùy chọn)

```bash
codesign --verify --deep --verbose=2 /Applications/AI\ Studio.app
codesign --display --verbose=2 /Applications/AI\ Studio.app
```

Kết quả mong đợi: `valid on disk` + `Authority=-` (ad-hoc signature).

## Q&A

**Vì sao không qua Apple Developer Program (Developer ID)?**
ETC chưa đăng ký Apple Developer Org ($99/yr + D-U-N-S). Bản preview dùng ad-hoc sign (miễn phí, hợp lệ Mach-O signature) — đủ cho internal use. Bản chính thức sẽ có Developer ID.

**Gatekeeper vẫn chặn sau khi xattr?**
Apple Silicon đôi khi cache state. Restart Mac hoặc:
```bash
sudo spctl --add /Applications/AI\ Studio.app
```

**Update mới có cần xattr lại?**
Có. Mỗi installer download mới sẽ có `com.apple.quarantine` flag. AI Studio auto-update sẽ tự xử lý in-place (không cần xattr lại).

**Liên hệ**: maintainer team ETC.
