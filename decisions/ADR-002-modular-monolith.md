# ADR-002 — Use a modular monolith for the core application

- Status: Accepted
- Date: 2026-07-15

## Context

The product domain, customer workflow, and automation rules will change quickly during discovery. A microservice architecture would add deployment, tracing, networking, consistency, and coordination cost before the boundaries are proven.

The connector and browser runtimes have different security and reliability requirements from the business domain.

## Decision

Build the business application as one NestJS modular monolith containing:

- Authentication, tenants, and RBAC.
- Contacts and identity matching.
- Conversations.
- Leads and pipeline.
- Tasks and follow-ups.
- Approval and policy rules.
- Tenant knowledge.
- Reporting.
- Transactional outbox.

Run these components as separate processes outside the monolith:

- OpenWA and alternative WhatsApp connector workers.
- Browserbase automation workers.
- Hermes workers.
- BullMQ job workers when isolation is useful.

## Boundary rules

- Modules may not access another module's database tables through private repositories.
- Cross-module work uses application services, domain events, or explicit internal contracts.
- External connectors communicate through normalized commands and events.
- Database transactions remain inside the monolith where possible.

## Consequences

### Positive

- Faster development and simpler local operation.
- Easier transactional consistency.
- Lower infrastructure and observability overhead.
- Easier refactoring while the domain is uncertain.

### Negative

- A careless implementation can become tightly coupled.
- The application scales as one unit until modules are extracted.
- Strict module ownership requires discipline and architecture tests.

## Extraction triggers

A module becomes a service only when it requires independent scaling, isolation, ownership, deployment cadence, or technology that cannot be handled cleanly inside the monolith.
