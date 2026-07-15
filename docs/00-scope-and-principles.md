# 00 — Scope and Architecture Principles

## Product direction

The product is an **AI-first omnichannel sales automation system** for service businesses.

It connects customer conversations from channels such as WhatsApp, Instagram, Facebook, and later TikTok, converts them into structured sales opportunities, and uses AI to classify, extract, prioritize, draft, follow up, and report.

The product is not positioned as a generic CRM with an AI button. The intended positioning is:

> An AI sales operator that watches every customer conversation, keeps the pipeline updated, and helps the team take the next best action.

## What this repository covers

- System boundaries and service responsibilities.
- Channel access and browser automation.
- AI automation and approval policies.
- Data ownership and message lifecycle.
- Multi-tenancy and security.
- Deployment and cost strategy.
- Architecture Decision Records (ADRs).
- Risks and unresolved questions.

## What this repository does not cover yet

- UI screens or visual design.
- Branding and marketing website.
- Detailed frontend component architecture.
- Final pricing.
- Production infrastructure sizing.

## MVP business capabilities

1. Connect one WhatsApp account through OpenWA.
2. Connect one browser-based social inbox, initially Instagram or Meta Business Suite.
3. Import unread conversations into a unified internal conversation model.
4. Create or update contacts and leads automatically.
5. Extract structured lead information using AI.
6. Suggest replies using company knowledge and conversation context.
7. Require human approval before sending replies.
8. Schedule and surface follow-up tasks.
9. Generate a daily sales operations brief.
10. Preserve an audit trail for every automated recommendation and action.

## Architecture principles

### 1. The CRM is the source of truth

External channels are transports, not databases. Contacts, leads, assignments, tasks, pipeline stages, and automation history live in our platform.

### 2. Every channel is replaceable

The core application must not know whether a WhatsApp message arrived through OpenWA, an official API, or a browser connector.

### 3. Deterministic automation before agent autonomy

Use stable code for repeated workflows. Use semantic browser automation or an agent only when the interface cannot be handled reliably with deterministic logic.

### 4. Human approval before risky actions

The first release drafts and recommends. Automatic sending is limited to explicitly approved low-risk workflows.

### 5. A channel failure must not stop the business system

If WhatsApp or a browser session disconnects, the pipeline, tasks, history, reports, and manual workflows continue working.

### 6. Start as a modular monolith

Keep the business core simple to develop and deploy. Isolate browser and WhatsApp runtimes into separate workers because they have different failure and resource profiles.

### 7. Multi-tenancy is a first-class concern

Every record, event, secret, browser context, queue job, and AI tool call must be scoped to a tenant.

## Initial success criteria

The architecture is successful when it can support a paid pilot with 1–3 companies while allowing us to replace any connector later without rebuilding the core sales system.
