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

Org scope only. It says which tool calls Onbox may make alone (`## Allowed`), never (`## Forbidden`), or only under a condition (`## Required`), with `### <integration>` or `### <integration>__<tool>` to scope rules. Read it before you change it, and write a rule so it can be judged from one call alone.
