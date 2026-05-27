# Cài AI Studio trên Windows

## Bước 1: Cài cert tin cậy ETC (1 lần duy nhất, cần quyền Admin)

ETC ký AI Studio bằng certificate nội bộ. Để Windows không cảnh báo "Unknown publisher" mỗi lần update, cài cert vào máy 1 lần:

```powershell
# Mở PowerShell as Administrator
cd <thư-mục-chứa-ai-studio-scripts>
Set-ExecutionPolicy -Scope Process Bypass -Force
.\install-cert.ps1
```

Script sẽ import cert vào `LocalMachine\Root` + `LocalMachine\TrustedPublisher`. Sau bước này, SmartScreen sẽ tin cậy mọi build ký bởi "ETC AI Platform".

> **Lưu ý**: Chỉ cài cert **một lần duy nhất** trên máy. Nếu đổi máy, làm lại bước này.

## Bước 2: Tải installer

Tải file `.exe` từ [Releases](https://github.com/cuongnm-dev/ai-kit/releases) → mục **AI Studio**.

## Bước 3: Cài đặt

Double-click `AI-Studio-*-x64.exe` → next-next-finish.

Nếu SmartScreen vẫn cảnh báo:
1. Kiểm tra đã chạy `install-cert.ps1` bước 1 chưa
2. Right-click installer → **Properties** → tab **General** → tick **Unblock** → OK
3. Hoặc click **More info** → **Run anyway**

## Bước 4: Cài AI Engine (lần đầu)

Mở AI Studio sẽ thấy thông báo "Engine chưa cài". Mở terminal mới:

```powershell
ai-kit install engine
```

Quay lại AI Studio, refresh.

## Bước 5: Cấp API key

Liên hệ maintainer team để nhận Anthropic API key. Dán vào AI Studio settings.

> ⛔ **KHÔNG dùng** tài khoản Claude Pro/Max cá nhân.

## Verify chữ ký (tùy chọn)

```powershell
Get-AuthenticodeSignature .\AI-Studio-*.exe | Format-List
```

Kết quả mong đợi:
```
SignerCertificate : [Subject]
                      CN=ETC AI Platform, O=ETC, C=VN
Status            : Valid
```

## Gỡ cài đặt

```powershell
# Gỡ AI Studio: Settings → Apps → Installed apps → AI Studio → Uninstall
# Gỡ cert (nếu muốn dọn sạch):
Get-ChildItem Cert:\LocalMachine\Root | Where-Object Subject -match 'ETC AI Platform' | Remove-Item
Get-ChildItem Cert:\LocalMachine\TrustedPublisher | Where-Object Subject -match 'ETC AI Platform' | Remove-Item
```

## Q&A

**Có cần Admin mỗi lần update không?**
Không. Cert chỉ cài 1 lần. Update binary qua AI Studio's auto-update hoặc tải installer mới — không cần admin.

**Cert hết hạn?**
Maintainer sẽ thông báo + phân phối cert mới. Chạy lại `install-cert.ps1` với file mới.

**Liên hệ**: maintainer team ETC.
