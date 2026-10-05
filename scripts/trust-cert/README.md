# Chứng chỉ ký số nội bộ ETC AI Platform

Các tệp này cũng được đóng gói thành `ai-studio-trust-cert.zip` trên **mọi** bản phát hành
(https://github.com/cuongnm-dev/AI-Kit/releases/latest/download/ai-studio-trust-cert.zip). Bản ở đây là
bản không nén, để có một đường dẫn không phụ thuộc vào bản phát hành nào.

| Tệp | Quyền | Phạm vi |
| --- | --- | --- |
| `trust-cert-user.ps1` | **không cần** Administrator | tài khoản Windows hiện tại (`CurrentUser\Root` + `CurrentUser\TrustedPublisher`) — **khuyên dùng** |
| `install-cert.ps1` | Administrator | mọi tài khoản trên máy (`LocalMachine\Root` + `LocalMachine\TrustedPublisher`) — máy dùng chung / IT |
| `uninstall-cert-user.ps1` / `uninstall-cert.ps1` | như trên | gỡ tương ứng |
| `etc-codesign.cer` | — | phần công khai của chứng chỉ, thumbprint SHA-1 `90845F3F36BEEB8D8C4ED2D067662F6832E4EA85`, hết hạn 2031-05-17 |

Vì sao cần: bộ cài **và mọi bản cập nhật tự động** AI Studio cho Windows đều được ký bằng chứng chỉ này.
Máy chưa tin thì AI Studio từ chối cập nhật tự động (*"this computer does not trust that certificate's root"*).

Cách làm: tải cả thư mục, chuột phải `trust-cert-user.ps1` → **Run with PowerShell**, chọn **Yes** nếu Windows hỏi,
rồi thoát hẳn và mở lại AI Studio. Nguồn: `packages/ai-kit/scripts/` trong monorepo AI-Platform.
