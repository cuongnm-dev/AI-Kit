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

Chỉ cần tải và cài đặt một gói duy nhất: **AI Studio**.  
Bộ cài đặt này sẽ tự động tích hợp và cài đặt sẵn:
* **AI Studio** – Ứng dụng giao diện chính.
* **AI Engine** – Nhân xử lý và chạy các trợ lý AI đi kèm (bundled sidecar runtime).
* **AI Kit** – Bộ công cụ hỗ trợ dạng dòng lệnh (CLI helper) được cấu hình tự động vào biến môi trường hệ thống.

---

## 1. Tải phần mềm

1. Mở link: **[Bản phát hành mới nhất](https://github.com/cuongnm-dev/ai-kit/releases/latest)**.
2. Chọn phiên bản mới nhất (ví dụ `v1.11.6`).
3. Tải tệp cài đặt phù hợp với máy của bạn trong phần **Assets** (tệp đính kèm):
   * **Windows:** Tải file **`AI Studio-...-x64.exe`** (đuôi `.exe`).
   * **macOS:** Tải file **`AI Studio-...-arm64.dmg`** (cho chip Apple M1/M2/M3) hoặc **`AI Studio-...-x64.dmg`** (cho chip Intel).
   * **Linux:** Tải file **`AI Studio-...-x64.AppImage`** hoặc **`.deb`**.

---

## 2. Cài đặt và Kích hoạt

### Bước 1 — Cài đặt AI Studio

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

### Bước 2 — Mở ứng dụng và kiểm tra (làm một lần)

Khi bạn mở ứng dụng **AI Studio** lần đầu tiên, chương trình sẽ tự động thiết lập và cài đặt bộ hỗ trợ CLI (`ai-kit`) và đưa đường dẫn lệnh vào biến môi trường `PATH` của máy bạn.

Để kiểm tra xem mọi thứ đã được thiết lập thành công:
1. Mở một cửa sổ **PowerShell** (Windows) hoặc **Terminal** (macOS/Linux) **MỚI**.
2. Sao chép và chạy lệnh sau (nhấn Enter):
   ```bash
   ai-kit doctor
   ```
3. Nếu lệnh hiển thị thông tin kiểm tra thành công, bạn đã hoàn tất quá trình cài đặt.

**Gặp lỗi:** xem [Xử lý sự cố](docs/troubleshooting.md) hoặc [Câu hỏi thường gặp](docs/faq.md).

---

## 3. Cập nhật

Khi có phiên bản mới, bạn chỉ cần thực hiện cập nhật cho ứng dụng chính **AI Studio**:
* Chọn **Kiểm tra cập nhật** trực tiếp trong ứng dụng hoặc tải bản cài đặt `.exe` / `.dmg` mới nhất để cài đè lên phiên bản cũ.
* Các thành phần đi kèm như **AI Engine** và **AI Kit** sẽ tự động được ứng dụng cập nhật đồng bộ lên phiên bản mới nhất khi khởi chạy phiên bản mới.
* *(Tùy chọn)* Đối với cấu hình CLI và template, bạn vẫn có thể chạy lệnh `ai-kit update` trong Terminal/PowerShell để đồng bộ nhanh.

---

## 4. Gỡ cài đặt

Lưu ý: Việc gỡ cài đặt chỉ xóa phần mềm và các tệp cấu hình AI, **không** ảnh hưởng đến các file tài liệu cá nhân (Word, Excel, Code...) của bạn.

#### 💻 Cho Windows:
1. Mở **PowerShell** (Windows $\rightarrow$ gõ `PowerShell`).
2. Sao chép và chạy lệnh sau để dọn dẹp các tệp cấu hình CLI:
   ```powershell
   $i = "$env:TEMP\remove-all-products.ps1"
   irm https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/remove-all-products.ps1 -OutFile $i
   & $i
   ```
3. Vào *Settings (Cài đặt) $\rightarrow$ Apps (Ứng dụng)* và gỡ cài đặt **AI Studio** khỏi hệ thống.

#### 🍎 Cho macOS / Linux:
1. Mở ứng dụng **Terminal**.
2. Sao chép và chạy lệnh sau để dọn dẹp cấu hình (nhấn Enter):
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
