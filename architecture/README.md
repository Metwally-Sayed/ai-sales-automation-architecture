# Architecture Editing Guide

The architecture is stored in two editable formats.

## 1. Structurizr DSL

File:

```text
architecture/workspace.dsl
```

This is the architecture model and the main source of truth.

It currently contains:

- people,
- external systems,
- platform containers,
- relationships,
- a System Context view,
- a Container view.

### Open it locally

From the repository root:

```bash
docker pull structurizr/structurizr
docker run -it --rm \
  -p 8080:8080 \
  -v "$PWD/architecture:/usr/local/structurizr" \
  structurizr/structurizr local
```

Then open:

```text
http://localhost:8080
```

Changes to `workspace.dsl` can be reviewed through GitHub commits and Pull Requests.

## 2. D2 presentation views

Folder:

```text
architecture/d2/
```

Each file contains one focused diagram:

1. `01-system-context.d2`
2. `02-container-architecture.d2`
3. `03-channel-connectors.d2`
4. `04-inbound-message-flow.d2`
5. `05-ai-approval-flow.d2`
6. `06-deployment.d2`

These views are intentionally small. Do not combine them into one large diagram.

## Editing rule

Every diagram should answer one question only.

- System Context: who uses the system?
- Containers: what are the main runtime parts?
- Connectors: how do we access each channel?
- Inbound Flow: what happens when a message arrives?
- AI Approval: what can the AI execute?
- Deployment: where does each process run?

## Collaboration workflow

1. Edit a DSL or D2 file in a branch.
2. Update the related ADR when a technology decision changes.
3. Update the matching README diagram when the model changes.
4. Review the change in a Pull Request.
5. Merge only after the architecture is accepted.
