# Integration — ai-kit ↔ ai-studio

Cross-package contract between the **ai-kit CLI helper** and **ai-studio** in the AI Platform monorepo.

## Direction

- **ai-studio** is the end-user client (web + Electron) and hosts the **canonical config store** on its server ([ADR-0008](../../../../docs/adr/0008-enterprise-config-control-plane.md)).
- **ai-kit** is the **runtime CLI helper** on the client: decrypts `engine-config.enc` in memory and exposes product commands to LLM workflows ([ADR-0004](../../../../docs/adr/0004-ai-kit-encrypted-bundle.md)).
- **Maintainer publish** (T0/T1 product content) is **artifacts-studio** → canonical store — not `ai-kit publish` ([ADR-0009](../../../../docs/adr/0009-artifacts-studio-maintainer-console.md)).

ai-studio does not import ai-kit source. ai-kit does not import ai-studio or ai-engine internals.

## What ai-kit provides at runtime

| Surface | Purpose |
|---------|---------|
| `bin/ai-kit*` | CLI launcher on client `AI_KIT_HOME` |
| `engine-config.enc` | Encrypted T0 bundle (agents, skills, commands, tools, `AGENTS.md`, `engine.json`) |
| `mcp/ai-mcp/` | Docker compose templates for local ai-mcp MCP |
| `packages/ai-kit/docs/` | Runtime docs loaded via `REPO_DIR` |

## What ai-studio consumes

- Encrypted product artifact delivered via fleet revision (canonical store + SSE in managed mode).
- Compatible ai-kit CLI surface for spawn helpers and MCP lifecycle where wired.
- `@ai-engine/sdk/v2` only for engine coupling — never ai-kit modules in-process.

## Release coupling

- Platform code ships from the **AI Platform monorepo** (`packages/ai-kit/`, `packages/ai-studio/`).
- Product **content** revision is independent of CLI code revision — encrypted artifact + canonical `revision` id.
- Breaking changes to engine spawn CLI or plugin contract require coordinated bumps in ai-studio and fleet apply logic.

## Pinned contracts

- Client install: `AI_KIT_HOME` (default `~/.ai-kit/`).
- `REPO_DIR === AI_KIT_HOME` in `bin/ai-kit.mjs`.
- Managed enterprise mode: `AI_STUDIO_MANAGED_MODE=1` — engine sandbox + canonical store; no user-home policy writes.

## References

- [`docs/modules/ai-kit.md`](../../../../docs/modules/ai-kit.md)
- [`docs/modules/ai-studio.md`](../../../../docs/modules/ai-studio.md)
- [`docs/architecture/ecosystem-map.md`](../../../../docs/architecture/ecosystem-map.md)
