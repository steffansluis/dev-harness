# Paradigm: api-service

A backend HTTP API, GraphQL service, or microservice that exposes a programmatic
interface consumed by other services or clients. Has no rendered user interface;
user-facing text is minimal or absent. Focuses on contract stability, test coverage,
and documented endpoints.

## Use When

- The project exposes REST, GraphQL, gRPC, or similar endpoints
- There is no browser-rendered UI (responses are JSON, protobuf, etc.)
- Consumers depend on a stable public API contract
- The primary quality concern is correctness and reliability, not visual design

---

## Enabled Gates

| Gate | Enabled | Reason |
|------|---------|--------|
| design | no | API design is captured in OpenAPI/schema specs, not visual mockups |
| readme | yes | Endpoint changes and schema changes must be reflected in documentation |
| acceptance | yes | API contracts require integration/acceptance tests at the HTTP boundary |
| screenshots | no | No rendered UI — visual screenshots are not applicable |
| i18n | no | API responses are data structures; user-facing text is handled by the client |

---

## Stack Notes

Typical stacks: Node/Express, NestJS, Ruby on Rails API mode, Go (net/http, Gin), Python (FastAPI, Django REST).
Test runner: Supertest, RSpec request specs, httptest, pytest with httpx.
CI: acceptance tests run on push to main / PR open (remote).
