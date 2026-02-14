# Subscription Mong (구독멍)

This is the bootstrap repository for restarting the Subscription Mong service.
Current focus is to lock down team operating documents and MVP technical principles first; Flutter Web app implementation will continue in the next phase.

## Reframing Direction

1. Keep the service name as `구독멍`.
2. Separate branding/design from existing assets and redefine with a new standard.
3. Fix architecture to a single Flutter Web app.
4. Store all data in `localStorage` with no backend server or database.
5. Exclude external integrations (API, batch workers, third-party SDKs) from MVP scope.

## MVP Technical Principles

- Runtime: Flutter Web
- Data persistence: Browser `localStorage`
- Data sync: None (local-device only)
- Auth / authorization: None (single local user assumption)
- Network dependency: None

## Initial App Scope

- Create / update / delete subscription items
- Manage subscription states (`active`, `paused`, `review`)
- View upcoming payment date and amount lists
- Local backup/restore (JSON import/export)

## Out of Scope (MVP Exclusion)

- Server APIs
- Database
- Push notifications / batch jobs
- External catalog / price ingestion integrations
- Payment processor / login integrations

## Documentation Paths

- Operating standards: `.codex/agents/team.md`
- Execution runbook: `.codex/agents/runbook.md`
- Backlog: `.codex/TODO/backlog.md`
- Changelog: `.codex/changelog/CHANGELOG.md`
