# ADR-005 — Use OpenWA first with open-source connector fallbacks

- Status: Accepted for validation
- Date: 2026-07-15

## Context

The first version should avoid paid WhatsApp platform APIs while validating customer demand. OpenWA can expose WhatsApp Web as an API and webhook source, but it is unofficial and can break when WhatsApp Web changes.

Depending on only one unofficial library would increase recovery time if that library has a project-specific bug or delayed fix.

## Decision

Create a provider-neutral `WhatsAppConnector` contract.

Connector order:

1. **OpenWA** — primary connector for the first pilot.
2. **WPPConnect** — first open-source standby candidate to implement and test.
3. **whatsapp-web.js** — third candidate for compatibility experiments.
4. **Baileys** — research candidate only, not an MVP dependency because its lower-level socket approach would require more session and protocol ownership.
5. **Manual WhatsApp deep link** — operational fallback available from day one.
6. **Official WhatsApp Business Platform adapter** — later option when revenue or reliability justifies it.

## Adapter contract

```ts
interface WhatsAppConnector {
  connect(input: ConnectWhatsAppInput): Promise<ConnectionResult>;
  disconnect(accountId: string): Promise<void>;
  getStatus(accountId: string): Promise<ConnectionStatus>;
  sendMessage(input: SendWhatsAppMessageInput): Promise<SendResult>;
  normalizeInboundEvent(payload: unknown): Promise<NormalizedMessage[]>;
}
```

The core application stores only normalized events and provider references. It must not depend on OpenWA message objects or methods.

## Failover model

Use **active-passive**, not active-active:

- One connector actively owns an account session.
- Standby implementations are tested against disposable accounts.
- Switching providers is an explicit recovery workflow.
- Re-authentication by QR or link code may be required.
- The outbox pauses while connection ownership is uncertain.

Two unofficial libraries must not simultaneously send from the same account.

## Why WPPConnect is the first alternative

- It is open source.
- It offers a broad WhatsApp Web feature surface.
- It has an independently maintained implementation and stable public function names.
- It can reduce project-specific dependency risk compared with OpenWA alone.

It does **not** remove the shared upstream risk that both projects depend on WhatsApp Web behavior.

## Why not build our own connector now

Building and maintaining our own WhatsApp Web implementation would consume time on authentication, session persistence, protocol or page changes, media behavior, and compatibility before the sales product is validated.

A custom connector is reconsidered only after:

- Paid demand is proven.
- Connector outages become a measurable business problem.
- The team has capacity for continuous compatibility maintenance.

## Operational safeguards

- No bulk unsolicited messaging in the MVP.
- Human approval for customer-facing AI replies.
- Health checks and disconnect alerts.
- Idempotent inbound processing and outbound message keys.
- A transactional outbox for failed sends.
- Version pinning and staging tests before connector upgrades.
- Clear customer communication that the pilot connection is unofficial.

## Consequences

### Positive

- No platform messaging fee during validation.
- Faster path to a working WhatsApp experience.
- Provider abstraction lowers library lock-in.
- A standby library may reduce recovery time for implementation-specific problems.

### Negative

- All unofficial connectors share platform-policy and upstream-change risk.
- Accounts may require re-authentication.
- Reliability cannot be promised at official API service levels.
- Supporting multiple connectors increases test and maintenance work.
