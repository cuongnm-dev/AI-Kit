---
title: ai-mcp MCP — Reference
order: 24
---

# ai-mcp MCP Server

Container chạy localhost:8001 — render Office docs (DOCX/XLSX) qua MCP `/jobs` API.

## Image

- Public: `o0mrblack0o/ai-mcp:v3.0.0`
- Multi-arch: `linux/amd64` + `linux/arm64` (Mac M1/M2 + Intel Mac + Linux x86)
- Source: `github.com/cuongnm-dev/ai-mcp`

## Compose config

`mcp/ai-mcp/docker-compose.yml`:

```yaml
services:
  ai-mcp:
    image: ${ai_mcp_IMAGE:-o0mrblack0o/ai-mcp:latest}
    ports:
      - "${AI_MCP_PORT:-8001}:8000"
    volumes:
      - ./data:/data           # bind mount (Docker Desktop handles permissions)
    healthcheck:
      test: curl -sf http://localhost:8000/healthz
```

## Endpoints

| Path | Method | Mục đích |
|---|---|---|
| `/healthz` | GET | Health check |
| `/readyz` | GET | Readiness probe |
| `/uploads` | POST | Multipart upload `content_data.json` |
| `/jobs` | POST | Create render job `{type: tkct\|tkcs\|tkkt\|hdsd\|xlsx, upload_id}` |
| `/jobs/{id}` | GET | Poll status |
| `/jobs/{id}/files/{name}` | GET | Download rendered file |
| `/mcp` | (SSE) | MCP streamable-http transport |
| `/sse` | (SSE) | MCP SSE transport (legacy) |

## Quản lý qua ai-kit

```bash
ai-kit mcp status          # docker compose ps
ai-kit mcp logs            # tail -f
ai-kit mcp restart         # restart container
ai-kit mcp pull            # force pull new image + restart
ai-kit mcp stop / start    # down / up
```

## Pin version trong team

`mcp/ai-mcp/.env.example`:
```
ai_mcp_IMAGE=o0mrblack0o/ai-mcp:v3.0.0
```

Mỗi `ai-kit update` sẽ pull đúng version này (nếu khác local).

## Build + push image (maintainer only)

Quy trình release MCP image do maintainer thực hiện trong meta-repo:

```powershell
pwsh scripts/release-mcp.ps1 v3.1.0 -BumpTeam -Yes
```

Script tự động: build multi-arch (amd64+arm64) → push registry → bump version trong `packages/ai-mcp/` → release theo [`docs/RELEASE.md`](../../../../docs/RELEASE.md).

Team chỉ cần chạy `ai-kit update` là có image mới.

## Storage volume

Bind mount `./data:/data`:
- Vị trí: `~/.ai-kit/mcp/ai-mcp/data/`
- Subdirs:
  - `_jobs/uploads/{id}/` — temporary uploads (TTL 30m)
  - `_jobs/jobs/{id}/` — render outputs awaiting download (TTL 1h)
  - Project data theo project-slug

Restart container → data persist (bind mount).
Reset hoàn toàn:
```bash
ai-kit mcp stop
rm -rf ~/.ai-kit/mcp/ai-mcp/data
ai-kit mcp start
```

## Troubleshooting

### Container restart loop
```
docker logs ai-mcp
```
Common causes:
- `Permission denied: /data/_jobs` → bind mount permission. Mac/Win Docker Desktop handles automatically. Linux: `chmod 777 ~/.ai-kit/mcp/ai-mcp/data`.
- Port 8001 conflict → đổi `.env`: `AI_MCP_PORT=8002`, update `~/.config/engine/engine.json` MCP URL.

### healthz fails
```bash
curl -sv http://localhost:8001/healthz
```
- Container chưa start xong: `start_period: 30s`. Đợi 30s sau pull.
- Image mismatch: `ai-kit mcp pull` to force latest.

### "no matching manifest for linux/arm64"
Image cũ chỉ có `amd64`. Maintainer rebuild:
```powershell
.\release-mcp.ps1 v3.x.y -BumpTeam -Yes
```
Team `ai-kit update`.

### Logs không thấy traceback rõ
```bash
ai-kit mcp logs | grep -i error
docker logs ai-mcp --tail 100
```

## T-003 (canonical rule)

> All Office rendering goes through ai-mcp MCP `/jobs` API. Render engines bundled inside MCP image. Templates trong image. **Cấm Python subprocess** từ Claude/Cursor side.

Forbidden patterns:
- ❌ `python render_docx.py`
- ❌ `python fill_xlsx_engine.py`
- ❌ Local templates/*.docx reads

→ MCP down → BLOCK. Skill phải instruct user `ai-kit mcp start` rồi retry.

## Liên quan

- maintainer guide
- ai-kit reference
- troubleshooting
