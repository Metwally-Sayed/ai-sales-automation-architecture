# AI Sales Automation Architecture

Living architecture repository for an AI-first omnichannel sales automation platform.

This repository is intentionally focused on **system architecture, technology choices, risks, and decisions** — not UI design.

## Accepted MVP direction

- Launch channels: WhatsApp, Instagram, and Facebook through Meta Business Suite.
- Core shape: NestJS modular monolith.
- Agent runtime: Hermes behind a restricted application tool gateway.
- Browser runtime: Browserbase with Playwright first and Stagehand as semantic recovery.
- WhatsApp: OpenWA primary, WPPConnect standby candidate, manual fallback.
- Official platform APIs: deferred until demand, cost, or reliability justifies them.

## Architecture documents

1. [`00 — Scope and principles`](docs/00-scope-and-principles.md)
2. [`01 — System context`](docs/01-system-context.md)
3. [`02 — Container architecture`](docs/02-container-architecture.md)
4. [`03 — Message lifecycle`](docs/03-message-lifecycle.md)
5. [`04 — Hermes AI automation runtime`](docs/04-ai-automation-runtime.md)
6. [`05 — Selected technology map`](docs/05-selected-technology-map.md)

## Accepted decisions

- [`ADR-001 — Launch channels`](decisions/ADR-001-launch-channels.md)
- [`ADR-002 — Modular monolith`](decisions/ADR-002-modular-monolith.md)
- [`ADR-003 — Hermes runtime`](decisions/ADR-003-hermes-agent-runtime.md)
- [`ADR-004 — Browserbase runtime`](decisions/ADR-004-browserbase-runtime.md)
- [`ADR-005 — WhatsApp connectors`](decisions/ADR-005-whatsapp-connectors.md)

## Collaboration workflow

1. Architecture changes are proposed in a branch.
2. Every meaningful change is reviewed in a Pull Request.
3. Technology choices are documented as Architecture Decision Records.
4. Mermaid diagrams are rendered directly by GitHub and remain editable as text.
5. Accepted decisions are merged only after review.

## Current review

Architecture v0.1 is being reviewed in Pull Request #1.
