# Inbound webhooks

An inbound webhook endpoint is a URL that an outside system, such as Linear, GitHub or the organisation's own tool, posts events to.
Onbox verifies each delivery with the endpoint's signing secret and logs it.
Webhook events do not start runs yet: an `on_webhook` trigger is stored and listed, and starts nothing until event dispatch ships.

Only an admin manages endpoints, in Settings, Webhooks, with the webhook endpoint tools, or with the `onbox webhook-endpoints` commands.
A member is refused.

## Endpoints

| Field   | Meaning                                                                                                                             |
| ------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Slug    | The name an `on_webhook` trigger gives as its `source`. Lowercase letters, digits and dashes. It cannot be changed.                 |
| Scheme  | How Onbox checks the signature: `linear`, `github` or `hmac_sha256` (a custom tool). It cannot be changed.                          |
| URL     | Unique to the endpoint. Onbox registers nothing in the outside system: paste the URL there yourself. A new endpoint gets a new URL. |
| Secret  | Write-only. Onbox never shows it again, and a new one replaces the old one at once.                                                 |
| Enabled | When off, the URL answers `404` and nothing is stored.                                                                              |

Onbox refuses every delivery until the secret is set.

## Setting one up

| Sender | Where the URL goes                                                                           | Who chooses the secret                                                       |
| ------ | -------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| Linear | Linear workspace settings, API, new webhook. Choose the data to send.                        | Linear generates it. Copy it from the webhook in Linear and set it in Onbox. |
| GitHub | Repository or organization settings, Webhooks, add webhook, content type `application/json`. | You do. Generate one in Onbox, then paste the same value in GitHub.          |
| Custom | Your tool posts JSON to the URL.                                                             | You do. Generate one in Onbox and give it to your tool.                      |

From a terminal, the same steps:

```bash
onbox webhook-endpoints create --slug linear --scheme linear
pbpaste | onbox webhook-endpoints update linear --secret @-
onbox webhook-endpoints deliveries list linear
```

`--secret @-` reads the secret from standard input (here the macOS clipboard), so it stays out of the shell history and the process list.

To check the setup, send a test event from the sender, such as GitHub's ping or a change in Linear, then open the endpoint in Settings and select Refresh under Recent deliveries.
The event should be listed as Received.

## Signatures

| Scheme        | Signature                                                                        | Delivery id                 | Event type                                                 |
| ------------- | -------------------------------------------------------------------------------- | --------------------------- | ---------------------------------------------------------- |
| `linear`      | `Linear-Signature`, hex HMAC SHA-256 of the raw body                             | `Linear-Delivery`           | `<type>.<action>` from the body, such as `Issue.update`    |
| `github`      | `X-Hub-Signature-256`, `sha256=` and the hex HMAC SHA-256                        | `X-GitHub-Delivery`         | `<X-GitHub-Event>.<action>`, such as `pull_request.closed` |
| `hmac_sha256` | The header you name, hex HMAC SHA-256 of the raw body, `sha256=` prefix optional | The header you name, if any | The header you name, or a dot path into the body           |

A Linear delivery whose `webhookTimestamp` is more than five minutes from Onbox's clock is refused with `401`.
The body must be a JSON object; anything else is refused with `400`.
For Linear and GitHub, a delivery whose body is identical to a stored one is stored once, even under a new delivery id, so a redelivery from the sender adds no row.
A custom endpoint without a delivery id header also counts two deliveries with the same body as one.

## Deliveries

Settings, Webhooks, an endpoint, Recent deliveries lists what arrived, newest first, for 14 days.
Each row has the event type, the time, a status and a reason.

| Status     | Meaning                                                                           |
| ---------- | --------------------------------------------------------------------------------- |
| Received   | Verified and stored. Every delivery has this status today.                        |
| Dispatched | A trigger took it. Not used until event dispatch ships.                           |
| Skipped    | No trigger took it, and the reason says why. Not used until event dispatch ships. |
| Failed     | Dispatch failed, and the reason says why. Not used until event dispatch ships.    |

Only a verified delivery is listed.
A refused one leaves no row, and the sender's own delivery log shows the status Onbox answered:

| Answer | Cause                                                                            |
| ------ | -------------------------------------------------------------------------------- |
| `404`  | A wrong URL, a deleted endpoint, or an endpoint that is off.                     |
| `401`  | No secret set, a wrong secret, a missing signature, or a stale Linear timestamp. |
| `400`  | A body that is not a JSON object.                                                |
| `429`  | Over the endpoint's limit, 600 deliveries a minute by default.                   |

A repeated delivery id is accepted with `200` and stored once.

## Triggers

An `on_webhook` trigger names an endpoint by its slug in `source`.
Settings, Webhooks shows, for each endpoint, the triggers that name it, and lists the triggers whose `source` names no endpoint.
A trigger may name an endpoint or a resource definition that does not exist yet.
It waits for them, and Settings marks what is missing.
Write the trigger's `events` from the event types the deliveries list shows.
The triggers section of the brain files reference describes the `on_webhook` fields, with an example.
