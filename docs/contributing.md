---
title: Contributing — Đóng góp & Quy ước
order: 93
---

# Contributing

Hướng dẫn đóng góp vào ai-kit — CLI helper, SDLC engine, và tài liệu runtime trong monorepo **AI Platform**.

---

## Trước khi đóng góp

### Đọc qua

- [`docs/modules/ai-kit.md`](../../../../docs/modules/ai-kit.md) — vai trò runtime vs maintainer
- [`docs/adr/0004-ai-kit-encrypted-bundle.md`](../../../../docs/adr/0004-ai-kit-encrypted-bundle.md) — encrypted artifacts
- [`docs/adr/0009-artifacts-studio-maintainer-console.md`](../../../../docs/adr/0009-artifacts-studio-maintainer-console.md) — publish T0/T1 (maintainer)
- `decision-log.md` — quyết định nội bộ kit docs
- `glossary.md` — thuật ngữ thống nhất

### Set up dev env (monorepo)

```bash
cd /path/to/AI-Platform/packages/ai-kit
npm install
node bin/ai-kit.mjs help
node bin/ai-kit.mjs doctor
```

Chạy từ repo root (CI gates):

```bash
bun run --cwd packages/ai-kit test   # nếu có
node --test packages/ai-kit/bin/lib/path-env.test.mjs
```

**Product content** (agents, skills, commands) — maintainer chỉnh qua **artifacts-studio**, không commit plaintext bundle vào monorepo. **CLI code** (`bin/ai-kit.mjs`, `bin/lib/sdlc/`) — PR bình thường trong `packages/ai-kit/`.

---

## Loại đóng góp

### 1. Sửa lỗi CLI / SDLC (bug fix)

1. Branch `fix/kit-<short-desc>` trên monorepo
2. Sửa trong `packages/ai-kit/`
3. PR + reviewer; conventional commit

### 2. Agent / skill mới (product content)

Authoring target: **artifacts-studio** (planned) → encrypt → canonical store.

Cấu trúc tham chiếu (T0 bundle paths):

```
agent/<name>.md
skills/<name>/SKILL.md
commands/...
```

Không dùng `ai-kit publish` hay git-push dist làm luồng chính — đã retired (xem ADR-0009).

### 3. Sửa CLI (`bin/ai-kit.mjs`)

```bash
cd packages/ai-kit
node bin/ai-kit.mjs <command>
```

Nguyên tắc:

- Static UI (help/version/doctor) → Ink + `renderStaticLater()`
- Side-effect commands (update/mcp) → imperative output + `execaSync`
- File ~8800 dòng — **Grep trước**, patch nhỏ

### 4. Cập nhật MCP image (ai-mcp)

Code MCP: `packages/ai-mcp/` trong cùng monorepo.

1. Sửa code + test (`pytest`, `docker compose up --build`)
2. Bump `pyproject.toml` version
3. Build/push Docker image theo [`docs/RELEASE.md`](../../../../docs/RELEASE.md)
4. Fleet nhận revision qua studio canonical / client update — không qua git-push ai-kit dist

---

## Quy ước code

### Commit message

Conventional Commits (monorepo scope `kit`):

```
fix(kit): handle missing engine-config.enc in doctor
feat(kit): add sdlc verify scope for agent paths
docs(kit): refresh contributing for monorepo
```

### File encoding

- `.md`: UTF-8 không BOM, LF
- `.ps1`: UTF-8 **CÓ BOM**
- `.cmd`: ASCII-only
- `.mjs`, `.json`: UTF-8 không BOM, LF

### Tiếng Việt vs English

| Vị trí | Ngôn ngữ |
|---|---|
| Agent/skill body (system prompt) | **English** |
| User-facing CLI strings | Vietnamese hoặc English |
| `packages/ai-kit/docs/**/*.md` | **Vietnamese** (runtime asset) |
| Code comments | English |

---

## PR checklist

- [ ] Branch prefix: `feat/kit-`, `fix/kit-`, `docs/kit-`
- [ ] Conventional commit với scope `kit` khi chạm CLI
- [ ] `node bin/ai-kit.mjs help` không lỗi
- [ ] Không commit secrets / plaintext product bundle
- [ ] Docs link tới root `docs/adr/` khi đụng kiến trúc ship

---

## Maintainer-only

- Publish T0/T1 fleet content → **artifacts-studio** (ADR-0009)
- MCP image release → `packages/ai-mcp` + [`docs/RELEASE.md`](../../../../docs/RELEASE.md)
- Không dùng `ai-kit publish` làm luồng ship chính

---

## Liên hệ

- Issue trên monorepo
- Câu hỏi nhanh: kênh team
