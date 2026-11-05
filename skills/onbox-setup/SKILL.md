---
name: onbox-setup
description: Set up Onbox, the always-on agent that answers customers on every channel, and run it afterwards. Use when the person says "set up Onbox", "customer support", "connect our support mailbox", "website chat", "train the support agent on our docs", "go live", "what is waiting on me", "my inbox", "morning review", "anything to approve in Onbox", or asks to review what the Onbox agent learned. Covers what a correctly set up account is, the questions to ask first, the order of the setup steps, the browser steps and how to wait for them, seeding the agent's knowledge from a repository's docs, and the morning routine of deciding what waits on the person in batches.
license: MIT
compatibility: Needs the Onbox MCP server at https://api.onbox.ing/mcp, connected and signed in. Seeding knowledge from files needs an agent that can read the local repository.
metadata:
  author: Onbox Labs
  version: 1.3.0
---

# Setting up Onbox

Onbox runs its own agent, called Onbox unless the organisation renamed it, which answers the business's customers on every channel it connects, such as email, website chat or social messaging. You are the person's agent: you set Onbox up through its tools and later bring them what waits on them. In this skill, "the Onbox agent" is Onbox's, and "you" is the agent reading this.

The tools describe what each call does and returns. This skill holds the order of the calls and the judgement around them. For the words Onbox uses (brain, skills, memories, policies, pending action reasons, escalating), read [references/concepts.md](references/concepts.md) before you explain any of them to the person.

## Before any call

If no Onbox tool is available, the server is not connected or not signed in. Tell the person to connect the Onbox connector and sign in, then stop. Never ask for a password or an API key in the conversation.

## 1. Read where the setup stands

`get_account_status` is the source of truth for what a correctly set up account is: its checklist says which items exist, which are mandatory, and where each stands. Read it, never restate it from memory, and call it first, after every browser step, and while the brain builds.

How to read it:

- Work through the items that are not `done`, mandatory ones first. Each names its `fixTool`: that is your next call. A `null` fixTool means only waiting helps.
- `broken` means the item worked and stopped, for example a lapsed connection: fix it before adding anything new.
- `nextAction` is the one sentence to tell the person. Each item's `webUrl` is where they can do it in the browser instead.
- An account is set up when every mandatory item is `done` and the escalation item names the person from question 2. Onboarding then completes on its own (`onboardingCompletedAt`); there is no finish step. Going live is a separate decision: the inbox's send mode (step 3j).

Start from what is already done, then give the person a short plan, one line per remaining step, and let them confirm it before you act.

If `caller.isAdmin` is false, most account tools are not available to this person. Say so, tell them who can finish the setup (an admin of their organisation), and offer what they can do: read the status, and later go through their own inbox with the morning routine.

## 2. Ask first, in one message

Ask these together, before any write, and keep the answers for section 6:

1. Where do customers write to: which mailbox (for example support@, on Gmail or Outlook), and which other channels, such as a chat on their website?
2. Who handles escalations: the person who takes a conversation when the Onbox agent should not answer it? A name and email; invite them if they are not a member yet.
3. What tone should replies have? A sentence or two, or a past reply they like.
4. What may the Onbox agent do alone, and what needs a person's approval first? Common lines: answering how-to questions alone; refunds, cancellations, discounts and anything about money with approval; never promising dates.
5. Who else on the team should use Onbox?

If the person does not know an answer yet, take the sensible default (escalations go to the person you are talking to; everything that changes an account or money needs approval) and tell them you did.

## 3. The steps, in order

| Step | Tool                                                                     | Who acts                                  |
| ---- | ------------------------------------------------------------------------ | ----------------------------------------- |
| 3a   | `update_organisation`                                                    | automatic                                 |
| 3b   | `write_brain_files` (seed knowledge, see section 5)                      | automatic, coding agents only             |
| 3c   | `add_inbox` for each channel from question 1                             | browser: the person consents              |
| 3d   | `invite_members`                                                         | automatic: each person gets an email      |
| 3e   | `list_integrations`, `connect_integration`, the custom integration tools | browser: the person signs in              |
| 3f   | `get_billing`, then `update_billing`                                     | browser: the person starts the trial      |
| 3g   | `build_brain` if the brain item says so, then `get_account_status`       | automatic, about 30 minutes               |
| 3h   | review the brain, record the answers (section 6)                         | automatic, with the person                |
| 3i   | `get_account_status`                                                     | automatic                                 |
| 3j   | `update_inbox` with `sendMode`                                           | automatic, only after the person confirms |

Skip a step whose checklist item is `done`. Notes per step:

- **3a.** Only when the company's website or name is missing or wrong.
- **3c.** A website chat returns an HTML snippet. If you can edit the site's repository, add it before `</body>` on every page and show the person the diff; otherwise give them the snippet to paste.
- **3d.** The escalation person from question 2 if they are not a member, and the people from question 5.
- **3e.** Optional: tools the Onbox agent uses while answering, such as Linear, GitHub or Notion. Connect only what the person names. When the company has its own API or MCP server, call `preview_custom_integration`, then `create_custom_integration` with the auth it suggests; the person enters any secret through the returned link, then run `test_integration`.
- **3f.** Show the plans and the free trial exactly as `get_billing` returns them and let the person pick one. Call `update_billing` with that plan and give them the Checkout link: they enter the card there, and the trial starts when they come back. The trial also starts the brain build, so do 3b first.
- **3i.** Check that every mandatory item is `done`. If one is not, tell the person and give that item's `webUrl`.
- **3j.** Until now the Onbox agent drafts replies for review. Sending on its own is the go-live switch: explain what changes, ask the person to confirm for each inbox, and only then call `update_inbox` with `sendMode: "AUTO"`.

## 4. Browser steps and waiting

A browser step is one only the person can do: provider consent, a tool sign-in, payment, a secret. For each:

1. Give the link exactly as returned, alone on its line, with one sentence saying what they will see and that it opens in their browser. If your host can open a URL for the person, you may offer that; never open it without asking.
2. Say you will check, then wait. When the person says they are done, check at once with the tool for that step. If your host lets you wait between calls, check about every minute until the step shows done.
3. Where to check:
   - **Inbox:** `get_account_status`. The inbox is ready for the build when its `setupStatus` is `FINISHED`. `NEEDS_AUTH` or `DISCONNECTED` means the consent failed: say so and offer a new link.
   - **Tool sign-in or custom integration secret:** `list_integrations`, whose `status` and `secretStatus` say whether it is connected.
   - **Trial or plan:** `get_account_status`, where the plan item turns `done`.

**The polling rule.** While anything runs (an import, the build), report progress every few minutes in one line, for example "Build running: 12 skills and 40 memories saved so far." Stop polling after an hour. Tell the person where it stands, give the brain item's `webUrl` (or the page for the step), and say they can ask you to check again later. Never poll silently for longer than a few minutes.

## 5. Seeding the brain from a repository

If you can read the local repository, you can give the Onbox agent what no inbox history holds: the product's own docs. Do this before the trial starts, which starts the build, so the build sees it. Read the README, the docs folder, the pricing page and the FAQ. Write one knowledge entry per thing the company tells customers: a feature and how to use it, a limit, a policy, a price stated on the public site.

Write with `write_brain_files`, `scope: "org"`, all entries in one call, at `memory/kb_<slug>.md`. Each entry:

```markdown
---
name: export-to-csv
description: How a customer exports their data to CSV, from the Reports page.
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

The rules the commit check enforces:

- `kind` is one of `bug`, `issue`, `limitation`, `how-to`, `procedure`, `policy`. `status` is `current` for everything except a `bug` or `issue`, which is `open` until fixed.
- `sources:` is never empty: list a `citations:` entry a reader can follow on its own. A link into code pins a commit sha, never a branch: build it from the owner, the repository, the sha (`git rev-parse HEAD`) and the path. A branch link such as `/blob/main/` is refused. A public page URL is fine as it is.
- `log:` starts with one `created` line: a real date, a one-word lowercase `source` (`git` for the repository, `kb` for a published help page, `team` for something the person told you), and a `ref`.
- The body has `# Title`, `## When this applies` (one sentence) and `## Answer` (opens with the outcome). Only `###` headings below that, and only inside `## Answer`.

Write only what the files state. Leave out internal notes, secrets, roadmap items and anything customers are not told. If a call fails, the error names each file and the rule it broke: fix those files and send the call again. Then tell the person how many entries you wrote and on which topics.

## 6. After the build: review, then record the answers

When the brain item is `done`, call `list_brain_files` with `scope: "org"` and read the main files with `read_brain_files`. Summarise for the person, in a few lines: the skills (what the Onbox agent can handle), the knowledge it holds, and the rules it will follow.

Then record the answers from step 2, each in the file that already states the point, so two instructions never disagree:

- **Escalation person:** the `# Team` section of the org `AGENTS.md`, with their role.
- **Tone:** correct the line the build wrote; if none states it, add one line to the org `AGENTS.md`.
- **What the Onbox agent may do alone, and what needs approval:** `policies/tools.md`, one rule per bullet, under `## Allowed` and `## Forbidden`. A call that no allowed rule covers, or that a forbidden rule names, does not run on its own: it waits for a person. Read the file first and keep its headings. What a message must never say goes in `policies/communication.md`, under `## Forbidden`.

Show the person each change before you write it, and write all of them in one `write_brain_files` call. If the person corrects a fact, fix the file that holds it. Then check the checklist again with `get_account_status`.

## 7. The morning routine

When the person asks what waits on them, or once the first conversations arrive:

1. **List.** Call `list_my_inbox` with the filters the person wants (by `types` or `inboxIds`). Follow `nextCursor` while the person wants more.
2. **Read.** Call `get_conversations` with every returned conversation id, in one call.
3. **Show, then decide in batches.** Group the items by what they need (actions to approve, drafts, escalations, requests, mentions), one line each with its `webUrl`. For an action, show what it will run: recipient, first line, any amount, and why it waits. Then act on the person's decisions, each kind in one call:
   - `approve_pending_actions` for the actions the person has seen and confirmed, each with the version you showed. Read the results back as returned. An action that changed since comes back in `errors`: show the new version and ask again.
   - `discard_pending_actions` for the actions they reject.
   - `update_draft` to change a draft, or `create_draft` with `mode: "reply"` to answer a conversation yourself. A draft waits for a person to send it.
   - `update_conversations` to archive, snooze or assign conversations, to a person or to the Onbox agent.
   - `create_comment` to answer a teammate's mention or the Onbox agent's request. A comment stays inside Onbox.
4. **Brain proposals, for an admin.** When `openBrainProposals` is above zero, end with one line saying how many wait. If the person wants to go through them, call `list_brain_proposals`, and for each one read its source conversation with `get_conversations` before you recommend a decision. Then call `accept_brain_proposals` or `decline_brain_proposals` with the ones they decided.

## Things to avoid

- Never approve, discard, accept or decline on your own judgement. Only what the person has seen and confirmed.
- Never put secrets, API keys or passwords in the brain or in the conversation.
- Never retry a refused write unchanged: read the error, fix the cause, or ask the person.
- Never tell the person a step is done until `get_account_status` says so.
- Never switch an inbox to sending on its own without the person's confirmation.
