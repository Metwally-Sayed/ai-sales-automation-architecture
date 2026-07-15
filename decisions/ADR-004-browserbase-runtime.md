# ADR-004 — Use Browserbase as the first managed browser runtime

- Status: Accepted with an escape path
- Date: 2026-07-15

## Context

The first pilot needs browser automation for Instagram and Facebook through Meta Business Suite without waiting for official API approval. The team also needs a practical way for each customer to log in, persist browser identity, inspect failed sessions, and re-authenticate.

Operating Chromium sessions, profiles, recordings, and remote login infrastructure ourselves would delay validation.

## Decision

Use Browserbase as the primary managed browser runtime for the prototype and first pilot.

Use:

- A separate Browserbase context per tenant and connected account.
- Playwright for deterministic workflows.
- Stagehand only for semantic extraction or recovery when a deterministic flow fails.
- Live browser access for customer login, 2FA, and re-authentication.
- Session replay and logs for debugging, with sensitive-data retention minimized.

The application accesses Browserbase through a `BrowserRuntime` interface. A self-hosted Playwright and Chromium implementation remains a supported future alternative.

## Important cost constraint

The free plan is suitable only for experiments. Browser usage must be metered by:

- Tenant.
- Channel account.
- Workflow.
- Session duration.
- Successful message read or action.

Before the first paid production customer, estimate the cost of expected polling or active-session behavior. Do not assume the free tier can operate customer inboxes continuously.

## Runtime interface

```ts
interface BrowserRuntime {
  createSession(input: CreateBrowserSessionInput): Promise<BrowserSession>;
  connectToContext(input: ConnectContextInput): Promise<BrowserSession>;
  terminateSession(sessionId: string): Promise<void>;
  getLiveLoginUrl(sessionId: string): Promise<string>;
}
```

Browser automation code must not depend on Browserbase-specific objects outside the infrastructure adapter.

## Consequences

### Positive

- Faster prototype and customer onboarding.
- Managed browser infrastructure and inspection tools.
- Easier handling of remote login and persistent contexts.
- Less initial DevOps work.

### Negative

- Usage cost can become significant.
- A third-party service temporarily holds authenticated browser contexts.
- Session limits and retention settings affect product behavior.
- Migration to self-hosted browsers may require operational work.

## Reconsideration triggers

Evaluate self-hosting or a second runtime when:

- Browserbase cost exceeds 20% of channel-related subscription revenue.
- A customer requires different data residency or security controls.
- Session limits block the target workflow.
- A platform behaves more reliably from a controlled browser environment.
