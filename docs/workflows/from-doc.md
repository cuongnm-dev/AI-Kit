---
title: Workflow — Từ SRS/BRD → Tài liệu Office
order: 11
---

# Workflow — Từ SRS/BRD → Tài liệu Office (TKKT, TKCS, HDSD, ...)

Pipeline 3 bước: **`/from-doc` → SDLC → `/generate-docs`**.

## Khi nào dùng

- Có SRS / BRD / yêu cầu nghiệp vụ dạng tài liệu
- Cần sinh nhiều features cùng lúc (vd: 1 SRS có 7 features)
- Cuối cùng cần xuất Office files (DOCX, XLSX) cho nghiệm thu

## Tiền điều kiện

- File nguồn: `.docx`, `.pdf`, `.md`, hoặc ảnh wireframe
- Docker đang chạy (cho MCP `ai-mcp`)
- Đã chạy `ai-kit update` để có config mới nhất

## Quy trình

### 1. Phân tích tài liệu (ai-engine)

```
/from-doc <path-to-srs.docx>
```

Skill thực hiện:
1. Đọc + OCR + phân tích semantic
2. Phát hiện modules, features, roles, screens
3. Hỏi xác nhận pipeline split (1 pipeline cho cả vs split per module)
4. Tạo `docs/intel/doc-brief.md` + initial intel artifacts (actor-registry seeds, feature-catalog với confidence levels)
5. Sinh `_state.md` + `feature-brief.md` cho mỗi feature (status: planned)

Output:
- `docs/intel/{actor-registry,feature-catalog,sitemap}.json`
- `docs/intel/doc-brief.md`
- `docs/features/F-NNN/_state.md` (per pipeline)

### 2. Chạy SDLC cho từng module (Cursor) — entry mặc định

Mỗi module sau hand-off cần BA elaborate AC + SA design + Tech-lead wave plan + Dev + QA. Lặp lệnh sau cho TỪNG module trong handoff list:

```
/resume-module M-001
/resume-module M-002
...
```

Lệnh `/resume-module` sẽ:
- Đọc `docs/modules/M-NNN-{slug}/_state.md` (aggregate root post-ADR-006)
- PM agent dispatch ba/sa/tech-lead/dev/qa/reviewer per `stages_queue`
- Auto-loop tới done hoặc blocked, cover module-level + feature-level work cho mọi feature trong module

**Khi nào dùng `/resume-feature F-NNN` thay vì `/resume-module`**: chỉ khi muốn dispatch RIÊNG 1 feature (skip pipeline các feature khác cùng module). 90% post-handoff dùng `/resume-module` đúng — đây là default.

Status check không dispatch: `/feature-status` để xem queue + dependency order.

### 3. Sinh tài liệu Office (ai-engine)

Sau khi feature `done` → `/generate-docs`:

```
/generate-docs
```

Pipeline 6 stages:
1. **Preflight** — verify intel layer fresh
2. **Discovery** — load feature-catalog, sitemap
3. **Analysis** — gap analysis (test-evidence completeness)
4. **Capture** — screenshots qua Playwright (chỉ features thiếu evidence)
5. **Synthesis** — sinh content-data.json
6. **Quality + Delivery** — render Office files qua ai-mcp MCP

Output (tại `docs/generated/{slug}/output/`):
- `tkkt.docx` — Thiết kế Kiến trúc
- `tkcs.docx` — Thiết kế Cơ sở (NĐ 45/2026 Đ13)
- `tkct.docx` — Thiết kế Chi tiết
- `hdsd.docx` — Hướng dẫn Sử dụng (kèm screenshots)
- `test-cases.xlsx` — Bộ test case (BM.QT.04.04)

## Ví dụ thực tế

```bash
# 1. Phân tích SRS
User: /from-doc D:/Projects/be-portal/docs/source/SRS-v0.3.docx
> Detected: 2 modules, 7 features, 3 roles, 12 screens
> Pipeline split: 1 pipeline (modules ≤3) — confirm? [y]
> Generated: F-001..F-007

# 2. SDLC từng module (Cursor) — entry mặc định
/resume-module M-001    → ba → sa → tech-lead → dev-wave-1 → qa-wave-1 → reviewer → done
/resume-module M-002    (lặp cho từng module trong handoff list)

# 3. Sinh tài liệu (Claude)
/generate-docs
> 7 features, 6 stages
> Stage 4f: 84 test cases assembled (passed: 84/84)
> Render: tkkt.docx (1.2MB), tkcs.docx (2.5MB), ...
> Output: docs/generated/be-portal/output/

# 4. Bàn giao
/zip-disk
> be-portal-ban-giao-20260429.zip created
```

## Quick reference — bridge canonical intel

`docs/intel/` là single-source-of-truth giữa 3 skills (I-001):

```
/from-doc       → seeds (actor-registry, feature-catalog planned, sitemap planned)
SDLC stages     → enrich (description, AC, routes, entities, test-evidence)
/generate-docs  → consume only (read-only on intel)
```

## Liên quan

- new-feature — Single feature thay vì batch
- from-code — Khi codebase có sẵn
- maintainer — Update team config
- troubleshooting
