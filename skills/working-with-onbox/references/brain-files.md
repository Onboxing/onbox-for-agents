# Knowledge entries, triggers and policies

The brain checks every file on write: an unknown key or a wrong shape is refused with the path and the field. Read the error, fix that file, and write again.

## Knowledge entries: `memory/kb_<slug>.md`

One entry per thing the company tells customers: a feature and how to use it, a limit, a policy, a price stated on the public site. Before adding one, read the entries on that topic and correct the one that covers it.

Write with `write_brain_files`, `scope: "org"`, all entries in one call, at `memory/kb_<slug>.md`. Write only what the sources state, never internal notes, secrets or roadmap items. Each entry:

```markdown
---
name: export-to-csv
description: How do I export my data to CSV?
memory_type: kb
kind: how-to
status: current
sources:
  citations:
    - https://github.com/acme/app/blob/4f2a9c1d8e3b2a17c9f04e6b1d2c3a4b5e6f7a8b/docs/export.md
log:
  - { date: 2026-11-04, source: git, event: created, ref: 4f2a9c1, note: 'From docs/export.md' }
---

# Export to CSV

## When this applies

A customer asks how to get their data out as a spreadsheet.

## Answer

Customers export from Reports, then Export, then CSV; the file arrives by email within a few minutes.
```

The rules for each entry. The commit check refuses most breaks of them, but not a missing source, so check that one yourself:

- `description` names the customer question the entry answers, as a customer would ask it: "Can I get a refund, and how?", not "Refund eligibility.".
- `kind` is one of `bug`, `issue`, `limitation`, `how-to`, `procedure`, `policy`. `status` is `current` for everything except a `bug` or `issue`, which is `open` until fixed.
- `sources:` is never empty: list a `citations:` entry a reader can follow on its own. A link into code pins a commit sha, never a branch: build it from the owner, the repository, the sha (`git rev-parse HEAD`) and the path. A branch link such as `/blob/main/` is refused. A public page URL is fine as it is.
- `log:` starts with one `created` line: a real date, a one-word lowercase `source` (`git` for the repository, `kb` for a published help page, `team` for something the person told you), and a `ref` (the short sha, or the page's path).
- The body has `# Title`, `## When this applies` (one sentence) and `## Answer` (opens with the outcome). Only `###` headings below that, and only inside `## Answer`.

## Triggers: `triggers/<slug>.md`

A trigger starts work: when a message arrives that matches a condition, or on a schedule. It never stops or limits a reply; that is the communication policy. The file is frontmatter only, and the kebab-case slug is the file name.

Scope: a trigger for a shared inbox goes in the `org` brain, because a shared inbox reads only the organisation's triggers; a trigger for the person's own mailbox goes in `user`. Before you write one, list `triggers/` in both scopes and read any that may overlap: broaden an existing trigger (its condition or its actions) rather than adding a near-duplicate, since both would fire.

**When a message arrives:**

```markdown
---
trigger: on_inbound
condition: A customer asks for a refund or disputes a charge.
actions:
  - type: assign
    to: { person: usr_123 }
enabled: true
---
```

- `condition` says, in plain words, what the message is about. Onbox judges it from the message; no keywords.
- `actions`, in order, each one of: `assign` (`to: agent` with optional `instructions` in plain words, `to: { person: <user id from list_members> }`, or `to: { described: "<who, in words>" }`; at most one per trigger), `tag` (`tag: <name>`), `archive`, `mark_read`.
- One trigger per outcome: "repairs to me, invoices to Claire" is two triggers, each with its own condition. Never an if/else inside one.
- A tag in an `org` trigger is created when the trigger lands; in a `user` trigger it must exist already (`list_tags`).
- On an inbox where Onbox takes only what a trigger gives it (`takesNewConversations: FOLLOWING_TRIGGERS`), an `assign` to `agent` is how a kind of conversation goes to Onbox.

**On a schedule:**

```markdown
---
trigger: on_schedule
timezone: Europe/Paris
cron: '0 9 * * 1'
actions:
  - Summarise every conversation still waiting on a reply
  - Post the summary as a comment
enabled: true
---
```

`timezone` is a real IANA zone, and exactly one of `cron` (quoted, five fields) or `run_at` (a quoted future ISO time). Its actions are short phrases Onbox follows in order.

**On a webhook event:**

```markdown
---
trigger: on_webhook
source: linear
events: [Issue.update, Comment.create]
resource: linear-issue
resource_id: [data.issueId, data.id]
actions:
  - When the bug is confirmed or fixed, tell the customer
enabled: true
---
```

`source` is a webhook endpoint's slug, `events` the event types it accepts, `resource` a resource definition's slug, and `resource_id` dot paths into the payload; the first path that resolves is the id of the resource a conversation waits on. Its actions are short phrases, as on a schedule. A missing endpoint or resource definition is accepted, and the trigger waits for it. Webhook events do not start runs yet: the file is stored and listed, and starts nothing until event dispatch ships.

Pause a trigger with `enabled: false`; delete the file to remove it.

## Communication policy: `policies/communication.md`

Org scope only, and an owner or admin decides it. Every message Onbox sends is checked against each rule, and a message that breaks one waits for a person. Onbox's defaults already hold back personal data about anyone but the recipient, internal information, and refunds, compensation or legal positions nobody authorized: add only what is specific to the company.

```markdown
# Acme communication policy

## Forbidden

- The message quotes a price that is not on the public price list.
- The message promises a delivery date.
```

`## Forbidden` is the only section; one rule per bullet, starting with "The message", checkable from the message alone; no nested bullets, no other headings. Read the file first and edit a bullet that already covers the point.

## Tool policy: `policies/tools.md`

Org scope only. It says which tool calls Onbox may make alone (`## Allowed`), never (`## Forbidden`), or only under a condition (`## Required`), with `### <integration>` or `### <integration>__<tool>` to scope rules. Read it before you change it, and write a rule so it can be judged from one call alone: two careful readers who see only the call and the customer must give the same answer.

- Each condition is a fact the call or the customer's record shows, not a judgement: "members with no unpaid invoice", not "members in good standing".
- Each amount names its currency; when the company bills in several, give a cap per currency or say what happens in the others.
- Each other limit says what it counts (per item or per order when one call covers several) and whether it caps the change or the total; a duration is in days or an end date, never months, and says which date it counts from when two could apply.
- A count across calls ("at most twice") says per what: per booking or per customer, per month or ever. A cap on one call ("refunds up to EUR 50") is complete without a period.
- Anything the call creates that is worth money (coupon, voucher, credit) has its value or cap.
- When the tool handles several kinds of record and the rule names one, write a rule for each other kind.
- An exception says what is excluded and what happens instead; a field is named as the tool's data names it; a pronoun points to one thing only.
- When a limit or condition follows several actions, ask which actions it covers, then write one rule per action.
- A prohibition names its tool when another section allows the same kind of thing: "No other Shopify gift cards.", not "No other gift cards."

When the person's words leave one of these open, ask them and propose a concrete wording; never fill the gap yourself. Ask only what their words leave open: apart from the other kinds of record a tool handles, a case they did not mention waits for a person and is not a gap. When a rule is refused, rewrite it or ask; never get it through by dropping a condition or raising a limit.
