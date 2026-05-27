<div align="center">

# AI Platform

**Tải phần mềm · Cài đặt · Cập nhật · Gỡ cài đặt · Hướng dẫn sử dụng**

_(Hỗ trợ cho máy Windows, macOS và Linux)_

[1. Tải phần mềm](#1-tải-phần-mềm) · [2. Cài đặt](#2-cài-đặt) · [3. Cập nhật](#3-cập-nhật) · [4. Gỡ cài đặt](#4-gỡ-cài-đặt) · [5. Hướng dẫn dùng](#5-hướng-dẫn-dùng)

</div>

---

## Trang này là gì?

Đây là trang **tải và cài đặt chính thức** bộ phần mềm **AI Platform** dùng trong công việc.  
Anh/chị chọn hướng dẫn phù hợp với hệ điều hành đang dùng (Windows, macOS hoặc Linux) để thực hiện cài đặt.

---

## Anh/chị sẽ cài những gì?

| Phần mềm | Việc làm trên máy |
| --- | --- |
| **AI Studio** | Ứng dụng chính: làm việc với trợ lý AI, soạn thảo, quản lý phiên làm việc |
| **Bộ hỗ trợ (CLI)** | Cài cấu hình chung, mẫu tài liệu và công cụ phục vụ soạn hồ sơ / dự án |
| **Tài liệu hướng dẫn** | Đọc sau khi cài xong (mục [5](#5-hướng-dẫn-dùng)) |

**Thứ tự:** cài **AI Studio** trước, sau đó chạy **bộ cài hỗ trợ** (mục [2](#2-cài-đặt)).

---

## 1. Tải phần mềm

1. Mở link: **[Bản phát hành mới nhất](https://github.com/cuongnm-dev/ai-kit/releases/latest)**.
2. Chọn phiên bản mới nhất (ví dụ `v1.11.6`).
3. Tải tệp cài đặt phù hợp với máy của bạn trong phần **Assets** (tệp đính kèm):
   * **Windows:** Tải file **`AI Studio-...-x64.exe`** (đuôi `.exe`).
   * **macOS:** Tải file **`AI Studio-...-arm64.dmg`** (cho chip Apple M1/M2/M3) hoặc **`AI Studio-...-x64.dmg`** (cho chip Intel).
   * **Linux:** Tải file **`AI Studio-...-x64.AppImage`** hoặc **`.deb`**.

---

## 2. Cài đặt

### Bước 1 — Cài AI Studio

* **Windows:**
  1. Nhấp đúp file `.exe` đã tải.
  2. Bấm **Next** → **Install** → **Finish**.
  3. Lần đầu mở ứng dụng có thể gặp cảnh báo SmartScreen $\rightarrow$ chọn **More info** $\rightarrow$ **Run anyway** (do đây là phần mềm nội bộ).
* **macOS:**
  1. Nhấp đúp file `.dmg` đã tải.
  2. Kéo thả biểu tượng **AI Studio** vào thư mục **Applications** (Ứng dụng).
  3. Lần đầu mở ứng dụng, nếu gặp cảnh báo bảo mật, hãy vào *System Settings (Cài đặt hệ thống) $\rightarrow$ Privacy & Security (Quyền riêng tư & Bảo mật)* và chọn **Open Anyway**.
* **Linux:**
  1. Cấp quyền thực thi cho file `.AppImage` (`chmod +x`).
  2. Nhấp đúp để chạy ứng dụng ngay.

---

### Bước 2 — Cài bộ hỗ trợ (làm một lần)

Trước khi chạy lệnh, máy của bạn cần cài đặt **Node.js** (phiên bản LTS) tại [nodejs.org](https://nodejs.org) (cài đặt theo mặc định: Next $\rightarrow$ Next).

#### 💻 Cho Windows:
1. Nhấn phím **Windows**, gõ `PowerShell` và mở **Windows PowerShell**.
2. Sao chép và chạy lệnh sau (nhấn Enter):
   ```powershell
   irm https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/bootstrap.ps1 | iex
   ```
3. Đợi chương trình chạy xong, đóng PowerShell và mở lại. Chạy lệnh `ai-kit doctor` để xác nhận thành công.

#### 🍎 Cho macOS / Linux:
1. Mở ứng dụng **Terminal** trên máy.
2. Sao chép và chạy lệnh sau (nhấn Enter):
   ```bash
   curl -sL https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/bootstrap.sh | bash
   ```
3. Mở một cửa sổ Terminal mới, chạy lệnh `ai-kit doctor` để xác nhận thành công.

**Gặp lỗi:** xem [Xử lý sự cố](docs/troubleshooting.md) hoặc [Câu hỏi thường gặp](docs/faq.md).

---

## 3. Cập nhật

| Hệ điều hành | AI Studio | Bộ hỗ trợ (CLI) |
| --- | --- | --- |
| **Windows** | Chọn **Kiểm tra cập nhật** trong app hoặc tải `.exe` cài đè | Chạy lệnh `ai-kit update` trong **PowerShell** |
| **macOS / Linux** | Chọn **Kiểm tra cập nhật** trong app hoặc tải `.dmg` cài đè | Chạy lệnh `ai-kit update` trong **Terminal** |

---

## 4. Gỡ cài đặt

Lưu ý: Việc gỡ cài đặt chỉ xóa phần mềm và các tệp cấu hình AI, **không** ảnh hưởng đến các file tài liệu cá nhân (Word, Excel, Code...) của bạn.

#### 💻 Cho Windows:
1. Mở **PowerShell** (Windows $\rightarrow$ gõ `PowerShell`).
2. Sao chép và chạy lệnh sau:
   ```powershell
   $i = "$env:TEMP\remove-all-products.ps1"
   irm https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/remove-all-products.ps1 -OutFile $i
   & $i
   ```
3. Vào *Settings (Cài đặt) $\rightarrow$ Apps (Ứng dụng)* và gỡ cài đặt **AI Studio** nếu còn.

#### 🍎 Cho macOS / Linux:
1. Mở ứng dụng **Terminal**.
2. Sao chép và chạy lệnh sau (nhấn Enter):
   ```bash
   curl -sL https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/remove-all-products.sh | bash
   ```
3. Xóa biểu tượng ứng dụng **AI Studio** trong thư mục **Applications** (Ứng dụng).

---

## 5. Hướng dẫn dùng

| Công việc | Tài liệu |
| --- | --- |
| Soạn hồ sơ, đề án, tài liệu nhà nước | [Bắt đầu — tài liệu nhà nước](docs/on-board-tailieu.md) |
| Làm dự án phần mềm | [Bắt đầu — SDLC](docs/on-board-sdlc.md) |
| Câu hỏi thường gặp | [FAQ](docs/faq.md) |
| Lỗi, không chạy được | [Xử lý sự cố](docs/troubleshooting.md) |

Sau khi cài bộ hỗ trợ: mở PowerShell hoặc Terminal, gõ `ai-kit doc` để xem thêm tài liệu trên máy.

---

## Hỗ trợ

1. Đọc [Xử lý sự cố](docs/troubleshooting.md) và [FAQ](docs/faq.md).
2. Gửi [phản ánh lỗi](https://github.com/cuongnm-dev/ai-kit/issues): ghi rõ hệ điều hành, bước đang làm, kèm ảnh màn hình (che thông tin nhạy cảm).

---

<div align="center">

**AI Platform** — trợ lý AI phục vụ công việc hành chính, chuyên môn.

</div>
