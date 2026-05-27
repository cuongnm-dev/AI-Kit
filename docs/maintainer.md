---
title: Maintainer workflow
order: 13
---

# Maintainer workflow

Trang này dành cho **maintainer platform** — không phải end-user ai-studio.

## Ship product content (T0 / T1)

Luồng chính (target):

1. **artifacts-studio** — author agents, skills, commands, org policy overlay
2. Encrypt → `engine-config.enc` + canonical ingest trên ai-studio server
3. Bump `revision` → SSE `ai-studio:config-revision` → clients apply

ADR:

- [`docs/adr/0009-artifacts-studio-maintainer-console.md`](../../../../docs/adr/0009-artifacts-studio-maintainer-console.md)
- [`docs/adr/0008-enterprise-config-control-plane.md`](../../../../docs/adr/0008-enterprise-config-control-plane.md)
- [`docs/adr/0004-ai-kit-encrypted-bundle.md`](../../../../docs/adr/0004-ai-kit-encrypted-bundle.md)

**Retired:** `ai-kit publish`, git-push dist repo, separate `ai-kit-source` repo làm SoT.

## Ship CLI code

Source: `packages/ai-kit/` trong monorepo AI Platform.

- PR + CI như package khác
- Bump `packages/ai-kit/package.json` version khi đổi CLI surface
- [`docs/RELEASE.md`](../../../../docs/RELEASE.md) — matrix release

## Ship MCP (ai-mcp)

Source: `packages/ai-mcp/`. Xem [`docs/RELEASE.md`](../../../../docs/RELEASE.md) § ai-mcp.

## Member (team)

Không cần đọc trang này. Bắt đầu tại:

- `on-board.md`
- `install-windows.md` / `install-macos.md`
- `troubleshooting.md`
- `workflows/`

Cập nhật client: fleet revision (enterprise) hoặc `ai-kit update` (legacy transitional).
