<div align="center">

# 🚀 AI Platform

**Bộ giải pháp Trợ lý AI toàn diện tích hợp sâu vào quy trình làm việc hành chính và kỹ thuật.**

*(Hỗ trợ đầy đủ cho máy Windows, macOS và Linux)*

[![Release](https://img.shields.io/github/v/release/cuongnm-dev/AI-Kit?color=blue&logo=github)](https://github.com/cuongnm-dev/AI-Kit/releases/latest)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-brightgreen)](#1-tải-phần-mềm)
[![License](https://img.shields.io/badge/license-MIT-orange)](#)

[1. Tải phần mềm](#1-tải-phần-mềm) • [2. Hướng dẫn cài đặt](#2-cài-đặt-và-kích-hoạt) • [3. Cơ chế cập nhật](#3-cơ-chế-cập-nhật) • [4. Hướng dẫn gỡ bỏ](#4-gỡ-cài-đặt) • [5. Tài liệu sử dụng](#5-hướng-dẫn-sử-dụng)

---

</div>

## 📌 Giới thiệu chung

**AI Platform** là hệ sinh thái công cụ hỗ trợ xử lý công việc bằng trí tuệ nhân tạo được tối ưu hóa cho doanh nghiệp và dự án. Khi cài đặt bộ giải pháp này, hệ thống sẽ tự động cấu hình và tích hợp sẵn 3 thành phần cốt lõi:

*   🖥️ **AI Studio**: Ứng dụng giao diện đồ họa (Desktop GUI) trực quan, cho phép tương tác trực tiếp với các mô hình ngôn ngữ lớn, soạn thảo tài liệu và quản lý các tác vụ AI.
*   ⚡ **AI Engine**: Nhân xử lý và điều phối tác vụ chạy ngầm dưới dạng sidecar service, đảm bảo hiệu năng xử lý cục bộ và bảo mật dữ liệu tối đa.
*   🛠️ **AI Kit**: Bộ công cụ dòng lệnh (CLI Helper - `ai-kit`) được tự động tích hợp trực tiếp vào biến môi trường hệ thống (`PATH`), hỗ trợ tự động hóa luồng công việc qua Terminal hoặc PowerShell.

---

## 💾 1. Tải phần mềm (Direct Download)

Anh/chị vui lòng bấm trực tiếp vào liên kết bên dưới phù hợp với hệ điều hành và phần cứng máy tính đang sử dụng:

| Hệ điều hành | Kiến trúc / Dòng chip | Định dạng bộ cài | Tải xuống trực tiếp |
| :--- | :--- | :---: | :--- |
| **Windows** | Intel / AMD (64-bit) | `.exe` | [📥 Tải xuống cho Windows (64-bit)](https://github.com/cuongnm-dev/AI-Kit/releases/latest/download/ai-studio-desktop-win-x64.exe) |
| **macOS** | Apple Silicon (M1 / M2 / M3...) | `.dmg` | [📥 Tải xuống cho Mac (Apple Silicon)](https://github.com/cuongnm-dev/AI-Kit/releases/latest/download/ai-studio-desktop-mac-arm64.dmg) |
| **macOS** | Intel Processor | `.dmg` | [📥 Tải xuống cho Mac (Intel)](https://github.com/cuongnm-dev/AI-Kit/releases/latest/download/ai-studio-desktop-mac-x64.dmg) |
| **Linux** | Standard x86_64 | `.AppImage` | [📥 Tải xuống định dạng AppImage](https://github.com/cuongnm-dev/AI-Kit/releases/latest/download/ai-studio-desktop-linux-x86_64.AppImage) |
| **Linux** | Debian / Ubuntu | `.deb` | [📥 Tải xuống định dạng DEB Package](https://github.com/cuongnm-dev/AI-Kit/releases/latest/download/ai-studio-desktop-linux-x86_64.deb) |

> [!TIP]
> Để xem tất cả các định dạng khác hoặc lịch sử thay đổi qua các phiên bản, anh/chị có thể truy cập trực tiếp vào [Trang phát hành của GitHub Releases](https://github.com/cuongnm-dev/AI-Kit/releases/latest).

---

## ⚙️ 2. Cài đặt và Kích hoạt

### Bước 1: Khởi chạy bộ cài đặt ứng dụng chính

*   💻 **Trên Windows**:
    1. Nhấp đúp vào tệp `.exe` vừa tải xuống.
    2. Bấm **Next** $\rightarrow$ **Install** $\rightarrow$ **Finish** để hoàn tất cài đặt.
    3. Do đây là phần mềm phân phối nội bộ, lần đầu khởi chạy nếu gặp thông báo *Windows Defender SmartScreen* $\rightarrow$ bấm chọn **More info** $\rightarrow$ chọn **Run anyway**.
*   🍎 **Trên macOS**:
    1. Nhấp đúp vào tệp `.dmg` đã tải về để mở ổ đĩa ảo.
    2. Kéo thả biểu tượng **AI Studio** vào thư mục **Applications** (Ứng dụng).
    3. Khi khởi chạy lần đầu, nếu hệ thống hiển thị cảnh báo từ chối ứng dụng chưa xác thực: Vào *Cài đặt hệ thống (System Settings) $\rightarrow$ Quyền riêng tư & Bảo mật (Privacy & Security)* $\rightarrow$ cuộn xuống mục bảo mật và chọn **Open Anyway** (Vẫn mở).
*   🐧 **Trên Linux**:
    1. Cấp quyền thực thi cho tệp `.AppImage` bằng dòng lệnh: `chmod +x ai-studio-desktop-linux-x86_64.AppImage`
    2. Nhấp đúp trực tiếp để mở và chạy ứng dụng.

---

### Bước 2: Xác thực cấu hình môi trường dòng lệnh (Chỉ làm một lần)

Khi khởi chạy **AI Studio** lần đầu tiên, ứng dụng sẽ tự động tích hợp bộ công cụ dòng lệnh `ai-kit` vào hệ điều hành. Để xác minh quá trình này hoàn tất thành công:

1. Khởi chạy một cửa sổ **PowerShell** (Windows) hoặc **Terminal** (macOS/Linux) **mới**.
2. Sao chép, dán lệnh sau và nhấn Enter:
   ```bash
   ai-kit doctor
   ```
3. Nếu màn hình hiển thị trạng thái kết nối thành công và các kiểm tra tích hợp đều đạt, hệ thống của bạn đã được cấu hình hoàn chỉnh.

*Nếu gặp bất kỳ thông báo lỗi hoặc cảnh báo nào, hãy tham khảo tài liệu [Xử lý sự cố](docs/troubleshooting.md).*

---

## 🔄 3. Cơ chế cập nhật (Auto Update)

Dự án áp dụng cơ chế tự động hóa phân phối cập nhật (tương tự như Microsoft VS Code và Cursor):

*   **Tự động kiểm tra**: Khi khởi động ứng dụng và định kỳ mỗi 10 phút, **AI Studio** sẽ tự động truy vấn thông tin phiên bản mới từ máy chủ lưu trữ chính thức tại repo `AI-Kit`.
*   **Cài đặt mượt mà**: Nếu phát hiện bản cập nhật mới, ứng dụng sẽ tự động tải ngầm. Người dùng chỉ cần bấm xác nhận khởi động lại ứng dụng khi có thông báo để hoàn tất nâng cấp.
*   **Đồng bộ thành phần phụ**: Các thành phần ngầm **AI Engine** và CLI **AI Kit** sẽ được tự động cập nhật đồng bộ tương ứng theo phiên bản mới của AI Studio khi khởi động lại.
*   *(Tùy chọn)* Bạn có thể chạy lệnh `ai-kit update` từ dòng lệnh bất cứ lúc nào để đồng bộ nhanh các mẫu template hoặc cấu hình.

---

## 🗑️ 4. Gỡ cài đặt (Uninstall)

Việc gỡ cài đặt chỉ gỡ bỏ bộ chương trình và các cấu hình chạy phụ trợ, hoàn toàn **không ảnh hưởng** đến các dữ liệu cá nhân hay tài liệu công việc của bạn.

#### 💻 Hướng dẫn cho Windows:
1. Mở công cụ **PowerShell** (bằng cách nhấn nút Windows và gõ `PowerShell`).
2. Sao chép và chạy lệnh sau để dọn dẹp triệt để cấu hình CLI:
   ```powershell
   $i = "$env:TEMP\remove-all-products.ps1"
   irm https://raw.githubusercontent.com/cuongnm-dev/AI-Kit/main/remove-all-products.ps1 -OutFile $i
   & $i
   ```
3. Truy cập vào mục *Settings (Cài đặt) $\rightarrow$ Apps (Ứng dụng)* trên máy tính và tiến hành uninstall **AI Studio** khỏi hệ thống.

#### 🍎 Hướng dẫn cho macOS / Linux:
1. Mở ứng dụng **Terminal**.
2. Thực thi lệnh sau để dọn dẹp cấu hình hệ thống:
   ```bash
   curl -sL https://raw.githubusercontent.com/cuongnm-dev/AI-Kit/main/remove-all-products.sh | bash
   ```
3. Xóa ứng dụng **AI Studio** khỏi thư mục **Applications** (Ứng dụng) bằng cách kéo thả vào Thùng rác (Trash).

---

## 📚 5. Hướng dẫn sử dụng

Anh/chị có thể tham khảo tài liệu hướng dẫn cụ thể theo từng nhóm nhiệm vụ công việc:

| Nhiệm vụ / Lĩnh vực | Tài liệu hướng dẫn chi tiết |
| :--- | :--- |
| **Hành chính công & Soạn thảo văn bản** | [📖 Tài liệu hướng dẫn Soạn thảo văn bản nhà nước](docs/on-board-tailieu.md) |
| **Phát triển và Quản lý Dự án Phần mềm** | [📖 Hướng dẫn ứng dụng AI trong quy trình SDLC](docs/on-board-sdlc.md) |
| **Các câu hỏi thường gặp** | [📖 FAQ - Giải đáp thắc mắc thường gặp](docs/faq.md) |
| **Khắc phục sự cố cài đặt/vận hành** | [📖 Hướng dẫn khắc phục sự cố chi tiết](docs/troubleshooting.md) |

> [!NOTE]
> Sau khi cài đặt thành công, bạn cũng có thể mở cửa sổ dòng lệnh và gõ `ai-kit doc` để tra cứu trực tiếp toàn bộ tài liệu hướng dẫn lưu cục bộ trên máy.

---

## 🤝 Hỗ trợ và Phản ánh lỗi

1. Đọc kỹ mục [Xử lý sự cố](docs/troubleshooting.md) và danh sách câu hỏi [FAQ](docs/faq.md).
2. Nếu sự cố vẫn tiếp diễn, vui lòng tạo một [Ticket phản ánh lỗi trên GitHub](https://github.com/cuongnm-dev/AI-Kit/issues). *Lưu ý: Mô tả rõ ràng các bước thực hiện, thông tin hệ điều hành và gửi kèm ảnh chụp màn hình lỗi (vui lòng che các dữ liệu hoặc thông tin nhạy cảm).*

---

<div align="center">

**AI Platform** — Giải pháp công nghệ nâng cao hiệu suất làm việc văn phòng chuyên nghiệp.

</div>

