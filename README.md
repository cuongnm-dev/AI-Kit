<div align="center">

# AI Platform

**Tải phần mềm · Cài đặt · Cập nhật · Gỡ cài đặt · Hướng dẫn sử dụng**

_(Hướng dẫn cho máy Windows)_

[1. Tải phần mềm](#1-tải-phần-mềm) · [2. Cài đặt](#2-cài-đặt) · [3. Cập nhật](#3-cập-nhật) · [4. Gỡ cài đặt](#4-gỡ-cài-đặt) · [5. Hướng dẫn dùng](#5-hướng-dẫn-dùng)

</div>

---

## Trang này là gì?

Đây là trang **tải và cài đặt chính thức** bộ phần mềm **AI Platform** dùng trong công việc.  
Anh/chị **tự tải và tự cài** trên máy Windows của mình theo các bước bên dưới — chỉ cần kết nối internet.

---

## Anh/chị sẽ cài những gì?

| Phần mềm                                   | Việc làm trên máy                                                         |
| ------------------------------------------ | ------------------------------------------------------------------------- |
| **AI Studio**                              | Ứng dụng chính: làm việc với trợ lý AI, soạn thảo, quản lý phiên làm việc |
| **Bộ cài hỗ trợ** (chạy một lần bằng lệnh) | Cài cấu hình chung, mẫu tài liệu và công cụ phục vụ soạn hồ sơ / dự án    |
| **Tài liệu hướng dẫn**                     | Đọc sau khi cài xong (mục [5](#5-hướng-dẫn-dùng))                         |

**Thứ tự:** cài **AI Studio** trước, sau đó chạy **bộ cài hỗ trợ** (mục [2](#2-cài-đặt)).

---

## 1. Tải phần mềm

1. Mở link: **[Bản phát hành mới nhất](https://github.com/cuongnm-dev/ai-kit/releases/latest)**.
2. Chọn dòng bản mới (ví dụ `v1.11.6`).
3. Ở phần **Assets** (tệp đính kèm), tải file **`AI Studio-...-x64.exe`** (tên có chữ **x64**, đuôi **.exe**).

Lưu file vào thư mục **Tải xuống** (hoặc nơi anh/chị dễ tìm).

---

## 2. Cài đặt

### Bước 1 — Cài AI Studio

1. Mở thư mục **Tải xuống**.
2. **Nhấp đúp** file `AI Studio-...-x64.exe`.
3. Bấm **Next** → **Install** → **Finish**.
4. Lần đầu Windows có thể cảnh báo bảo mật — chọn **More info** → **Run anyway** (phần mềm nội bộ).
5. Mở **AI Studio** từ menu **Start**.

### Bước 2 — Cài bộ hỗ trợ (làm một lần)

Trước khi chạy lệnh, máy cần:

- **Node.js** (bản LTS) — [tải tại nodejs.org](https://nodejs.org), cài theo mặc định (Next → Next).
- **Docker Desktop** — [tải tại docker.com](https://www.docker.com/products/docker-desktop), cài xong **mở Docker** và đợi biểu tượng ở khay hệ thống chạy ổn định.

Tiếp theo:

1. Nhấn phím **Windows**, gõ `PowerShell`, mở **Windows PowerShell**.
2. Sao chép **nguyên dòng** dưới, dán vào cửa sổ, nhấn **Enter**:

```powershell
irm https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/bootstrap.ps1 | iex
```

3. Đợi chương trình chạy xong (có thể mất vài phút).
4. **Đóng** PowerShell, mở lại, gõ `ai-kit doctor` rồi Enter — nếu báo ổn là xong.

**Gặp lỗi:** xem [Xử lý sự cố](docs/troubleshooting.md) hoặc [Câu hỏi thường gặp](docs/faq.md).

---

## 3. Cập nhật

| Phần          | Cách làm                                                                                                                                             |
| ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| **AI Studio** | Trong app chọn **Kiểm tra cập nhật** — hoặc tải file `.exe` mới tại [Bản phát hành](https://github.com/cuongnm-dev/ai-kit/releases/latest) và cài đè |
| **Bộ hỗ trợ** | Mở PowerShell, gõ `ai-kit update` rồi Enter                                                                                                          |

---

## 4. Gỡ cài đặt

Dùng khi **đổi máy**, **cài lại**, hoặc **gỡ hẳn** phần mềm.

Lệnh gỡ chỉ xóa **phần mềm và cấu hình AI** — **không** xóa file Word, Excel, PDF trong ổ đĩa làm việc của anh/chị.

1. Mở **PowerShell** (Windows → gõ `PowerShell`).
2. Dán lần lượt từng khối, Enter sau mỗi khối.

**Xem trước** (chưa xóa gì):

```powershell
$i = "$env:TEMP\remove-all-products.ps1"
irm https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/remove-all-products.ps1 -OutFile $i
& $i -DryRun
```

**Gỡ thật** — khi màn hình hỏi, gõ **Y** rồi Enter:

```powershell
& $i
```

3. Vào **Cài đặt → Ứng dụng** — nếu còn **AI Studio**, chọn **Gỡ cài đặt**.

File lệnh gỡ: [remove-all-products.ps1](remove-all-products.ps1)

---

## 5. Hướng dẫn dùng

| Công việc                            | Tài liệu                                                |
| ------------------------------------ | ------------------------------------------------------- |
| Soạn hồ sơ, đề án, tài liệu nhà nước | [Bắt đầu — tài liệu nhà nước](docs/on-board-tailieu.md) |
| Làm dự án phần mềm                   | [Bắt đầu — SDLC](docs/on-board-sdlc.md)                 |
| Câu hỏi thường gặp                   | [FAQ](docs/faq.md)                                      |
| Lỗi, không chạy được                 | [Xử lý sự cố](docs/troubleshooting.md)                  |

Sau khi cài bộ hỗ trợ: mở PowerShell, gõ `ai-kit doc` để xem thêm tài liệu trên máy.

---

## Hỗ trợ

1. Đọc [Xử lý sự cố](docs/troubleshooting.md) và [FAQ](docs/faq.md).
2. Gửi [phản ánh lỗi](https://github.com/cuongnm-dev/ai-kit/issues): ghi rõ Windows 10 hay 11, bước đang làm, kèm ảnh màn hình (che nội dung mật).

---

<div align="center">

**AI Platform** — trợ lý AI phục vụ công việc hành chính, chuyên môn.

</div>
