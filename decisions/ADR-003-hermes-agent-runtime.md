# ADR-003 — Use Hermes as the first agent runtime

- Status: Accepted with constraints
- Date: 2026-07-15

## Context

The product should be an AI automation system rather than a traditional CRM with a few AI buttons. It needs an agent runtime that can reason over conversations, use skills, and plan controlled workflows.

At the same time, the platform manages sensitive business conversations and authenticated browser sessions. An unrestricted general-purpose agent would create unacceptable tenant isolation, prompt injection, and accidental action risks.

## Decision

Use Hermes as an isolated agent worker behind the modular monolith.

Hermes is responsible for:

- Message classification and prioritization.
- Lead field extraction.
- Reply drafting.
- Follow-up planning.
- Conversation summaries.
- Daily business briefs.
- Multi-step planning using an allowlisted toolset.

The modular monolith remains responsible for:

- Tenant identity and authorization.
- Business state and database transactions.
- Policy and risk decisions.
- Human approval.
- Message outbox and idempotency.
- Browser and channel credentials.
- Audit history.

## Security constraints

- Hermes runs in an isolated worker or container.
- It receives task-specific context, never full tenant data.
- It does not receive raw cookies, passwords, connector tokens, or Browserbase context secrets.
- It cannot use unrestricted browser, terminal, or network tools in production.
- Every tool call is validated and tenant-bound by the core application.
- Customer-facing messages require approval during the pilot.

## Model strategy

Hermes is the runtime, not the model vendor contract. Models are called through an internal provider adapter so OpenAI can be used first without permanently coupling the domain to one provider.

## Consequences

### Positive

- Makes AI automation a core architectural capability.
- Supports skills and more complex workflows than isolated prompt calls.
- Preserves the ability to change model providers.
- Keeps policy and state under application control.

### Negative

- Adds another runtime to deploy and monitor.
- Requires strict tool design and prompt injection defenses.
- Hermes upgrades may change behavior and require regression testing.

## Pilot mode

The pilot uses Assist Mode:

- Internal low-risk categorization may run automatically.
- Hermes drafts replies and actions.
- A human approves customer-facing output.
