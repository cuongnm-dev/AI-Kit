---
title: ai-kit CLI — Reference
order: 20
---

> **Lưu ý (2026-05-25):** ai-kit chỉ deploy tới ai-engine (`~/.config/engine/` hoặc sandbox managed). Claude Code và Cursor không còn là deploy targets. Lịch sử 3-vendor: `docs/migration-3-vendor.md`.

# ai-kit CLI — 16 Commands Reference

```
Layout: ~/.ai-kit/              ← repo cloned tại root (flat)
├── .git/                       ← repo state
├── bin/ai-kit                  ← launcher in PATH
├── ai-engine/                  ← nguồn duy nhất (deployed to ~/.config/engine/)
│   ├── agent/                  ← agent bodies (kit://agent/)
│   ├── skills/                 ← skill bodies (kit://skills/)
│   ├── commands/               ← slash command definitions
│   ├── plugins/                ← plugin configs
│   └── tools/                  ← tool definitions
├── mcp/                        ← MCP container compose
├── package.json                ← Node deps manifest
└── node_modules/               ← npm install --omit=dev
```

Deploy target duy nhất: `~/.config/engine/` (ai-engine runtime config home).

## User commands

### `install`
First-time setup. Dùng `bootstrap.{sh,ps1}` thay thế — `install` chỉ tồn tại để symmetry.

### `update` | `up`
Pull team config mới + redeploy ai-engine + refresh MCP image.

```bash
ai-kit update
ai-kit up         # alias
```

Internal flow:
1. `git pull --ff-only` team config
2. Deploy `ai-engine/` → `~/.config/engine/` (agent, skills, commands, tools)
3. `docker compose down → pull → up -d` để áp image MCP mới
4. Backup tự động ở `~/ai-config-backup-<timestamp>/`
5. Lần đầu chạy sau pivot sole-target (2026-05-25): hỏi dọn dẹp các deploy path cũ (xem `--cleanup-legacy`)

#### Option: `--cleanup-legacy=yes|no|skip`
Dọn dẹp các thư mục deploy legacy (multi-vendor). Chỉ xoá deploy directories — không đụng user config (`~/.claude/settings.json`, `~/.claude/CLAUDE.md`, `~/.claude/projects/`).

```bash
ai-kit update --cleanup-legacy=yes    # tự động xoá không hỏi
ai-kit update --cleanup-legacy=no     # giữ nguyên
ai-kit update --cleanup-legacy=skip   # bỏ qua lần này, hỏi lại update sau
```

Các path được dọn (nếu tồn tại):
- `~/.claude/skills/`
- `~/.claude/agents/`
- `~/.cursor/skills/`
- `~/.cursor/agents/`
- `~/.cursor/rules/00-agent-behavior.mdc`
- `~/.cursor/rules/90-delivery-pipeline.mdc`

### `status` | `st`
Hiển thị phiên bản repo, số lượng đã deploy vào `~/.config/engine/`, trạng thái MCP container.

```bash
ai-kit status
ai-kit st
```

### `logs`
Tail MCP container logs (= `ai-kit mcp logs`).

```bash
ai-kit logs       # Ctrl+C để thoát
```

### `doctor` | `dr`
Kiểm tra deps + paths (`git`, `docker`, `python`, `curl`, `rsync` — Mac/Linux only, `bin/` in PATH).

```bash
ai-kit doctor
```

### `version` | `-v` | `--version`
Hiển thị phiên bản ai-kit + team-config sha + MCP image tag.

```bash
ai-kit version
ai-kit -v
ai-kit --version
```

### `help` | `-h` | `--help` | `/?`
Hiển thị tất cả commands.

## MCP control

### `mcp <verb>`

| Verb | Action |
|---|---|
| `start` | `docker compose up -d` |
| `stop` | `docker compose down` |
| `restart` | `docker compose restart` |
| `logs` | `docker compose logs -f ai-mcp` |
| `pull` | `compose down → pull → up -d` (force new image) |
| `status` / `ps` | `docker compose ps` |

```bash
ai-kit mcp logs
ai-kit mcp pull
ai-kit mcp restart
```

## Backup management

### `list-backups` | `backups`
Liệt kê các backup dưới `~/ai-config-backup-*` theo thời gian giảm dần.

### `rollback [N]`
Restore từ backup #N (default 1 = newest). Xác nhận trước khi overwrite.

```bash
ai-kit list-backups
ai-kit rollback         # newest
ai-kit rollback 3       # backup #3
```

### `clean [--keep N]`
Xóa backup cũ (giữ N gần nhất, default 3) + `docker image prune`.

```bash
ai-kit clean
ai-kit clean --keep 5
```

## Maintainer

### `pack` (retired)

**Retired** — product content không còn mirror plaintext `ai-engine/` trong client repo. Maintainer author qua artifacts-studio.

### `publish "<msg>"` (retired)

**Retired** — không dùng git push dist làm ship chính. Maintainer publish: artifacts-studio → canonical store (monorepo `docs/adr/0009-artifacts-studio-maintainer-console.md`).

### `diff`
Hiển thị file delta trong repo working tree (git status + git diff --stat). Hữu ích để xem ai sửa local trước khi publish.

```bash
ai-kit diff
```

Output: git working-tree diff so với HEAD trong REPO_DIR (`~/.ai-kit/`).

> Để kiểm tra drift giữa deploy và source, dùng `ai-kit verify` — xem bên dưới.

### `verify`
Kiểm tra toàn vẹn `~/.config/engine/` bằng manifest SHA256. Phát hiện local drift so với snapshot cuối cùng.

```bash
ai-kit verify
```

### `edit`
Mở ai-kit repo trong VS Code (nếu có), fallback `$EDITOR` → Explorer.

```bash
ai-kit edit
```

## Khác

### `uninstall`
Xóa `~/.ai-kit` (CLI + repo). **Không** xóa `~/.config/engine/` (deployed config). Yêu cầu xác nhận.

```bash
ai-kit uninstall
ai-kit uninstall --yes    # bỏ qua xác nhận
```

## Environment variables

| Var | Mặc định | Tác dụng |
|---|---|---|
| `AI_KIT_HOME` | `$HOME/.ai-kit` | Override install dir |
| `ENGINE_CONFIG_HOME` | `$HOME/.config/engine` | Override ai-engine config home |
| `AI_KIT_FORCE_CLEAN` | unset | `=1` → bootstrap discard local repo edits |
| `AI_KIT_AUTO_INSTALL` | unset | `=1` → bootstrap auto-install missing tools |
| `REPO_URL` | `https://github.com/cuongnm-dev/ai-kit.git` | Override repo URL |

> `CLAUDE_HOME` và `CURSOR_HOME` đã bị loại bỏ (legacy multi-vendor deploy). Không có tác dụng.

## Exit codes

- `0` — success
- `1` — error (missing deps, invalid input, dirty repo, ...)
- Other — propagated từ sub-process (docker, git)

## Liên quan

- maintainer guide
- troubleshooting
- `docs/migration-3-vendor.md` — lịch sử 3-vendor deploy (legacy)
