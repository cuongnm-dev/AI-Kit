> **Historical record only.** Migration B-110 (2026-05-12 to 2026-05-22) when ai-kit shipped to 3 vendors. **As of 2026-05-25, ai-kit ships ONLY to ai-engine.** Claude Code + Cursor deploy targets retired.

# Migration Guide — 3-Vendor Specialization (B-110)

**Date**: 2026-05-12
**Affects**: All ai-kit members who use Claude SDLC pipeline
**ADRs**: ADR-023, ADR-024, ADR-025

## TL;DR

Sau khi `ai-kit update`:

1. **Claude side**: SDLC agents/skills xóa khỏi `~/.claude/`. SDLC chuyển sang **Cursor canonical** (`~/.cursor/`).
2. **Cursor side**: Không thay đổi (đã canonical cho SDLC).
3. **OpenCode side mới**: `~/.config/opencode/` — full superset cho vibe-studio runtime.
4. **Windsurf + Kilo**: Ngừng pack từ 2026-05-12. Files trên máy không bị xóa.

## Breaking changes

### 1. Claude SDLC pipeline NGỪNG hoạt động

Sau khi `ai-kit update`, các skill sau **KHÔNG còn ở Claude side**:
- `/resume-module`, `/resume-feature`
- `/new-feature`, `/new-module`
- `/close-feature`, `/close-module`
- `/update-feature`, `/update-module`
- `/run-all-modules`
- `/strategic-critique`
- `/triage-pr`

Các agents `sdlc-*` cũng xóa: `sdlc-pm`, `sdlc-ba`, `sdlc-sa`, `sdlc-tech-lead`, `sdlc-dev`, `sdlc-fe-dev`, `sdlc-qa`, `sdlc-reviewer`, `sdlc-designer`, `sdlc-security`, `sdlc-devops`, `sdlc-release-manager`, `sdlc-sre-observability`, `sdlc-data-governance`, `sdlc-telemetry` + 5 `-pro` escalation tier.

**Workaround**: Dùng Cursor cho SDLC. Cursor có pair tương đương cho TẤT CẢ agents trên với tên bare (không có `sdlc-` prefix).

### 2. Claude side giữ lại

- Intel flow: `/from-code`, `/from-doc`, `/from-idea`, `/intel-refresh`, `/intel-fill`
- Doc generation: `/generate-docs`, `tdoc-*` agents
- Doc admin: `doc-*` agents
- Strategy: `/new-strategic-document`, `policy-researcher`, `strategy-analyst`, `structure-advisor`
- Workspace: `/new-workspace`, `/zip-disk`

### 3. Backup tự động

`ai-kit update` SAU 2026-05-12 KHÔNG tự động backup. Nếu user đang chạy mid-pipeline với Claude SDLC, recommend chạy backup TRƯỚC update:

```bash
# Backup ~/.claude/ before update
cp -r ~/.claude ~/.claude.bak.pre-b110
ai-kit update
```

Nếu cần khôi phục:
```bash
rm -rf ~/.claude
mv ~/.claude.bak.pre-b110 ~/.claude
# Note: Sẽ thiếu các update sau B-110. Chỉ rollback emergency.
```

## Action items per member

### Maintainer (cuongnm1@etc.vn)

- [x] Phase 0-4 complete + published (2026-05-12)
- [ ] Phase 5 execute behavior parity tests (separate session)
- [ ] Phase 6 monitor member feedback

### Active SDLC users

1. **Trước khi `ai-kit update`**:
   - Close hoặc commit current SDLC feature pipeline ở Claude side
   - Note current `_state.md` của module đang chạy
   - Backup `~/.claude/` per recommendation trên

2. **Sau khi `ai-kit update`**:
   - Chuyển sang Cursor: `/resume-module M-NNN` ở Cursor IDE
   - Verify Cursor pm/ba/sa/tech-lead/dev/qa/reviewer agents available

3. **Nếu blocked**:
   - Restore từ backup (xem step 3 ở trên)
   - Report blocker qua JOURNAL append

### vibe-studio users

- vibe-studio container tự động pull bundle mới sau khi maintainer publish.
- Container reset OpenCode bundle on next `ai-kit update`
- No member action needed

### Windsurf / Kilo users

- Files trên máy KHÔNG bị xóa
- `ai-kit update` không re-pack từ ~/.codeium/windsurf/ hoặc ~/.config/kilo/
- Nếu vẫn dùng Windsurf/Kilo: tự quản lý, không có sync auto
- Reactivation path: contact maintainer

## Verification checklist post-update

```bash
# 1. Verify ai-kit version
ai-kit doctor

# 2. Verify directory structure
ls -la ~/.claude/agents/sdlc-*.md     # Expect: NO FILES
ls -la ~/.cursor/agents/pm.md          # Expect: EXISTS (canonical)
ls -la ~/.config/opencode/agent/      # Expect: ~65 files (full superset)

# 3. Verify Cursor SDLC pipeline
# Open Cursor → /resume-module M-001 on a test workspace
# Expect: pipeline drives through stages

# 4. Verify Claude intel still works
# Open Claude Code → /from-code <small-project>
# Expect: intel layer generated correctly

# 5. Verify ai-kit deploy 3-way
ai-kit update --vendor claude  # only Claude
ai-kit update --vendor cursor  # only Cursor
ai-kit update --vendor opencode # only OpenCode
ai-kit update                   # default = all 3
```

## Support

Blocker / questions: Slack maintainer (anh Cường) hoặc mở issue tại `cuongnm-dev/ai-kit`. Template:

```
### B-110 migration blocker
- Vendor: claude | cursor | opencode
- Symptom: <description>
- Workspace: <path>
- Stage: <current SDLC stage if any>
```

Maintainer responds within 1 business day.

## Reference

Các ADR và plan dưới đây thuộc maintainer governance hub (private meta-repo), không ship trong ai-kit dist. Liên hệ maintainer nếu cần truy cập:

- ADR-023 — 3-vendor specialization
- ADR-024 — 3-namespace routing
- ADR-025 — Subagent recursion governance
- B-110 master plan + Phase 1 migration audit + behavior parity test suite
