<div align="center">

# AI Platform

**Trang tải phần mềm và hướng dẫn cài đặt cho cán bộ, nhân viên.**

[📥 Tải phần mềm](#-tải-phần-mềm) · [⚙️ Cài đặt](#️-cài-đặt) · [🔄 Cập nhật](#-cập-nhật) · [🗑️ Gỡ cài đặt](#️-gỡ-cài-đặt) · [📖 Hướng dẫn sử dụng](#-hướng-dẫn-sử-dụng)

</div>

---

## Trang này dùng để làm gì?

Đây là **cửa tải phần mềm chính thức** của bộ **AI Platform** — nơi anh/chị:

- **Tải** bản cài mới nhất (ứng dụng AI Studio và các thành phần kèm theo nếu đơn vị yêu cầu)
- **Xem** cách cài, cập nhật, gỡ phần mềm
- **Mở** tài liệu hướng dẫn sử dụng

Không cần cài server hay truy cập mã nguồn — chỉ cần trình duyệt và máy tính của mình.

---

## Bộ phần mềm gồm những gì?

| Tên                                          | Dùng để làm gì?                                                                | Ai thường dùng?                               |
| -------------------------------------------- | ------------------------------------------------------------------------------ | --------------------------------------------- |
| **AI Studio**                                | Ứng dụng trên máy — chat với trợ lý AI, soạn và quản lý công việc              | **Hầu hết cán bộ**                            |
| **Bộ cài đặt team** (cài tự động qua script) | Cài đủ công cụ nền cho đơn vị (kèm cập nhật mẫu tài liệu, trợ lý chuyên ngành) | Thường do **IT / quản trị** chạy giúp lần đầu |
| **Tài liệu hướng dẫn**                       | Cách dùng từng tình huống (soạn hồ sơ, làm dự án phần mềm, v.v.)               | Mọi người sau khi đã cài                      |

> Phần lớn cán bộ văn phòng **chỉ cần AI Studio**. Phần “bộ cài team” do bộ phận kỹ thuật hỗ trợ nếu đơn vị triển khai đầy đủ.

---

## 📥 Tải phần mềm

1. Mở trang **[Bản phát hành (Releases)](https://github.com/cuongnm-dev/ai-kit/releases/latest)**.
2. Chọn bản mới nhất (ví dụ: `v1.11.6`).
3. Kéo xuống mục **Assets** (Tệp đính kèm) và tải file phù hợp máy mình:

| Máy của bạn | File cần tải (tên gần đúng)                   |
| ----------- | --------------------------------------------- |
| **Windows** | `AI Studio-...-x64.exe`                       |
| **Mac**     | `AI Studio-...-arm64.dmg` hoặc `...-x64.dmg`  |
| **Linux**   | `AI Studio-...-x64.AppImage` hoặc file `.deb` |

Nếu không chắc bản nào: hỏi **bộ phận CNTT** của đơn vị hoặc gửi [yêu cầu hỗ trợ](https://github.com/cuongnm-dev/ai-kit/issues).

---

## ⚙️ Cài đặt

### Cách 1 — Chỉ cài AI Studio (đủ cho công việc văn phòng thông thường)

1. Tải file `.exe` (Windows) hoặc `.dmg` (Mac) như mục trên.
2. **Nhấp đúp** vào file vừa tải.
3. Làm theo hướng dẫn trên màn hình (Next → Install → Finish).
4. Lần đầu mở, Windows có thể hỏi “Ứng dụng không được công nhận” — chọn **Vẫn chạy** / **More info → Run anyway** (phần mềm nội bộ, chưa ký số công ty).

Mở **AI Studio** từ menu Start (Windows) hoặc thư mục Applications (Mac).

### Cách 2 — Cài đủ bộ cho team (do IT hỗ trợ)

Nếu đơn vị yêu cầu cài **toàn bộ** (ứng dụng + cấu hình team + công cụ nền), nhờ CNTT chạy **một trong hai lệnh** sau trên máy bạn:

**Windows** — mở **PowerShell** (chuột phải → Chạy với tư cách quản trị nếu được hướng dẫn), dán và Enter:

```powershell
irm https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/bootstrap.ps1 | iex
```

**Mac / Linux** — mở **Terminal**, dán và Enter:

```bash
curl -sL https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/bootstrap.sh | bash
```

Sau khi chạy xong, đóng cửa sổ lệnh, mở lại và kiểm tra theo hướng dẫn IT đưa (hoặc gõ `ai-kit status` nếu đã có lệnh này).

**Lưu ý:** Cách 2 cần máy đã có sẵn một số phần mềm nền (CNTT sẽ kiểm tra). Cán bộ văn phòng **không bắt buộc** tự làm nếu chỉ dùng AI Studio.

---

## 🔄 Cập nhật

| Việc cần làm                        | Cách làm                                                                                                                                                                         |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **AI Studio**                       | Mở app → tìm mục **Check for updates** (Kiểm tra cập nhật), **hoặc** tải bản `.exe` / `.dmg` mới tại [Releases](https://github.com/cuongnm-dev/ai-kit/releases/latest) và cài đè |
| **Bộ cài team** (nếu đã cài Cách 2) | Nhờ CNTT chạy lệnh cập nhật, hoặc trong cửa sổ lệnh gõ: `ai-kit update`                                                                                                          |

---

## 🗑️ Gỡ cài đặt

### Gỡ sạch toàn bộ trên máy (khuyến nghị khi đổi máy / cài lại)

Chúng tôi cung cấp **một tập lệnh gỡ** — xóa dữ liệu cài đặt AI Platform trên máy (ứng dụng, cấu hình, thư mục phụ).  
**Không xóa** tài liệu Word/Excel trong ổ đĩa của anh/chị; chỉ phần liên quan phần mềm AI.

| Máy         | File (có thể tải về chạy tay)                      |
| ----------- | -------------------------------------------------- |
| Windows     | [remove-all-products.ps1](remove-all-products.ps1) |
| Mac / Linux | [remove-all-products.sh](remove-all-products.sh)   |

#### Windows — từng bước

1. Mở **PowerShell** (Start → gõ `PowerShell`).
2. Dán **từng khối** dưới đây (Enter sau mỗi khối).

**Bước A — chỉ xem sẽ xóa gì, chưa xóa thật:**

```powershell
$i = "$env:TEMP\remove-all-products.ps1"
irm https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/remove-all-products.ps1 -OutFile $i
& $i -DryRun
```

**Bước B — xóa thật** (màn hình hỏi, gõ **Y** rồi Enter):

```powershell
& $i
```

**Bước C — nếu vẫn thấy “AI Studio” trong Cài đặt → Ứng dụng:**  
Vào **Cài đặt → Ứng dụng → AI Studio → Gỡ cài đặt**.

#### Mac / Linux — từng bước

**Chỉ xem trước:**

```bash
curl -sL https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/remove-all-products.sh | bash -s -- --dry-run
```

**Xóa thật** (gõ **Y** khi được hỏi):

```bash
curl -sL https://raw.githubusercontent.com/cuongnm-dev/ai-kit/main/remove-all-products.sh | bash
```

---

## 📖 Hướng dẫn sử dụng

Sau khi cài xong, mở tài liệu theo **công việc** của mình:

| Tôi làm việc gì?                                                   | Đọc file này                                            |
| ------------------------------------------------------------------ | ------------------------------------------------------- |
| Soạn **hồ sơ, đề án, tài liệu nhà nước** (Đề án CĐS, thầu CNTT, …) | [Hướng dẫn tài liệu nhà nước](docs/on-board-tailieu.md) |
| Làm **dự án phần mềm** (yêu cầu → thiết kế → kiểm thử)             | [Hướng dẫn SDLC](docs/on-board-sdlc.md)                 |
| **Câu hỏi thường gặp**                                             | [FAQ](docs/faq.md)                                      |
| **Lỗi, không mở được app**                                         | [Xử lý sự cố](docs/troubleshooting.md)                  |

Đã cài bộ team: trong cửa sổ lệnh có thể gõ `ai-kit doc` để xem danh sách tài liệu trên máy.

---

## Cần trợ giúp?

1. Hỏi **bộ phận CNTT** đơn vị (họ có quyền chạy script cài/gỡ).
2. Đọc [Xử lý sự cố](docs/troubleshooting.md).
3. Gửi [báo lỗi / yêu cầu hỗ trợ](https://github.com/cuongnm-dev/ai-kit/issues) — ghi rõ: hệ điều hành (Windows 10/11…), việc đang làm, ảnh chụp màn hình lỗi (che thông tin mật).

---

<div align="center">

**AI Platform** — hỗ trợ cán bộ làm việc hiệu quả hơn với trợ lý AI.

_Dành cho quản trị / IT: quy trình đăng bản mới lên trang tải → [RELEASE.md](RELEASE.md)_

</div>
