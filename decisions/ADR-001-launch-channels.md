# ADR-001 — Launch with WhatsApp and Meta Business channels

- Status: Accepted
- Date: 2026-07-15

## Context

The product vision is omnichannel, but supporting every social platform in the first pilot would increase authentication, browser automation, testing, and operational complexity before product-market validation.

The first customers are expected to receive meaningful sales conversations through WhatsApp, Instagram, and Facebook.

## Decision

The first pilot supports:

1. WhatsApp through the `WhatsAppConnector` abstraction.
2. Instagram Direct through Meta Business Suite browser automation.
3. Facebook and Messenger conversations through Meta Business Suite browser automation.

TikTok, Telegram, email, web chat, and official platform APIs are deferred.

## Consequences

### Positive

- Covers the most important initial customer journey across social discovery and WhatsApp closing.
- Meta Business Suite can provide one browser surface for Instagram and Facebook during validation.
- Limits connector and QA scope.
- Allows the product to validate unified identity, lead creation, AI triage, and follow-up.

### Negative

- Browser automation does not provide the same stability or event guarantees as official APIs.
- Some channel-specific features and statuses may be unavailable.
- TikTok leads require manual entry or a later connector.

## Validation criteria

Add a new channel only when at least one is true:

- Three paying pilot customers request it.
- At least 15% of qualified leads are being lost because the channel is unsupported.
- The channel integration can be added without delaying the core sales workflow.
