---
name: onbox-setup
description: Set up Onbox, the always-on agent that answers customers on every channel, and run it afterwards. Use when the person says "set up Onbox", "customer support", "connect our support mailbox", "website chat", "train the support agent on our docs", "which plan do I need", "what is waiting on me", "my inbox", "morning review", "anything to approve in Onbox", "let Onbox send on its own", or asks to review what the Onbox agent learned. Covers what a correctly set up account is, finding out before asking, the order of the setup steps, the browser steps and how to wait for them, giving the build the product's docs, explaining the plans and what counts, following the build, and the morning routine of deciding what waits on the person in batches.
license: MIT
compatibility: Needs the Onbox MCP server at https://api.onbox.ing/mcp, connected and signed in. Giving the build a repository's docs needs an agent that can read the local repository.
metadata:
  author: Onbox Labs
  version: 1.4.0
---

# Setting up Onbox

Onbox runs its own agent, called Onbox unless the organisation renamed it, which answers the business's customers on every channel it connects, such as email, website chat or social messaging, and learns how to handle each request. You are the person's agent: you set Onbox up through its tools and later bring them what waits on them. In this skill, "the Onbox agent" is Onbox's, and "you" is the agent reading this.

The tools describe what each call does and returns. This skill holds the order of the calls and the judgement around them. For the words Onbox uses (brain, skills, memories, policies, pending action reasons, escalating), read [references/concepts.md](references/concepts.md) before you explain any of them to the person.

## Before any call

If no Onbox tool is available, the server is not connected or not signed in.

- If your host offers a sign-in tool for the Onbox server, call it and carry on; do not ask the person to do it themselves. Claude Code, for example, exposes `authenticate` and `complete_authentication` for an MCP server that needs OAuth: call `authenticate`, give the person the link it returns to sign in in their browser, and continue once the Onbox tools appear. If the host asks for the address the browser landed on, pass it to `complete_authentication`.
- Only when no such tool exists, tell the person to connect the Onbox connector and sign in, then stop.

Never ask for a password or an API key in the conversation.

## 1. Read where the setup stands

`get_account_status` is the source of truth for what a correctly set up account is: its checklist says which items exist, which are mandatory, and where each stands. Read it, never restate it from memory, and call it first, after every browser step, and while the brain builds.

How to read it:

- Work through the items that are not `done`, mandatory ones first. Each names its `fixTool`: that is your next call. A `null` fixTool means only waiting helps.
- `broken` means the item worked and stopped, for example a lapsed connection: fix it before adding anything new.
- `nextAction` is the one sentence to tell the person. Each item's `webUrl` is where they can do it in the browser instead.
- An account is set up when every mandatory item is `done` and the escalation item names the person from section 2. Onboarding then completes on its own (`onboardingCompletedAt`); there is no finish step.

Start from what is already done, then give the person a short plan, one line per remaining step, and let them confirm it before you act.

If `caller.isAdmin` is false, most account tools are not available to this person. Say so, tell them who can finish the setup (an admin of their organisation), and offer what they can do: read the status, and later go through their own inbox with the morning routine.

## 2. Find out first, then ask one question at a time

Ask only what you cannot find out. Before asking anything, read what is at hand:

- The repository, if you can read it: the README, the package metadata, the site config, a support or contact email in the code, and whether the product is a website, a mobile app or both.
- The git author (`git config user.name`, `git config user.email`).
- The project's `CLAUDE.md` or `AGENTS.md`.
- The conversation so far, and what `get_account_status` already holds: the company, the inboxes, the members.

Then ask what is left, one question per message, each with a proposed answer drawn from what you found, for example "Should escalations go to you, Marie Dupont (marie@acme.com)?" If your host has a question tool, such as Claude Code's multiple-choice question, use it and put your proposal first. Never send a block of questions.

What you need, in this order, skipping what you already know:

1. **Channels.** What the person wants Onbox to support, and where customers reach them today. Propose the channels that fit what you found, such as the support mailbox from the code. Propose the website chat only when the product has a website. For a mobile app, say an in-app chat is not available yet, and propose what fits instead: email, App Store reviews and Google Play reviews.
2. **Escalations.** Who takes a conversation the Onbox agent should not answer: a name and an email. Propose the person you are talking to.
3. **Tone.** A sentence or two. Propose one from the voice of the site or the docs.
4. **What the Onbox agent may do alone, and what needs a person's approval first.** Propose the common lines: answering how-to questions alone; refunds, cancellations, discounts and anything about money with approval; never promising dates.
5. **Teammates, optional.** Ask once whether anyone else should use Onbox, with a proposed answer. If they say no, skip it and do not ask again.

If the person does not know an answer, take your proposal and tell them you did. Keep the answers for section 8.

## 3. The steps, in order

| Step | Tool                                                                     | Who acts                             |
| ---- | ------------------------------------------------------------------------ | ------------------------------------ |
| 3a   | `update_organisation`                                                    | automatic                            |
| 3b   | `write_brain_files` (give the build your docs, see section 5)            | automatic, coding agents only        |
| 3c   | `add_inbox` for each channel from section 2                              | browser: the person consents         |
| 3d   | `invite_members`, only if the person wants teammates                     | automatic: each person gets an email |
| 3e   | `list_integrations`, `connect_integration`, the custom integration tools | browser: the person signs in         |
| 3f   | explain the plans (section 6), `get_billing`, then `update_billing`      | browser: the person starts the trial |
| 3g   | follow the build (section 7)                                             | automatic, about half an hour        |
| 3h   | review the brain, record the answers (section 8)                         | automatic, with the person           |
| 3i   | `get_account_status`                                                     | automatic                            |

Skip a step whose checklist item is `done`. Notes per step:

- **3a.** Only when the company's website or name is missing or wrong.
- **3c.** A website chat returns an HTML snippet. If you can edit the site's repository, add it before `</body>` on every page on a new branch and open a pull request; if you cannot open one, show the person the diff. Otherwise give them the snippet to paste.
- **3d.** The escalation person from section 2 if they are not a member yet, and the teammates the person named.
- **3e.** Optional: tools the Onbox agent uses while answering, such as Linear, GitHub or Notion. Connect only what the person names. When the company has its own API or MCP server, call `preview_custom_integration`, then `create_custom_integration` with the auth it suggests; the person enters any secret through the returned link, then run `test_integration`.
- **3f.** The trial also starts the first build, so do 3b first.
- **3i.** Check that every mandatory item is `done`. If one is not, tell the person and give that item's `webUrl`. Setup ends here, after the review of what Onbox learned.

## 4. Browser steps and waiting

A browser step is one only the person can do: provider consent, a tool sign-in, payment, a secret. For each:

1. Give the link exactly as returned, alone on its line, with one sentence saying what they will see and that it opens in their browser. If your host can open a URL for the person, you may offer that; never open it without asking.
2. Say you will check, then wait. When the person says they are done, check at once with the tool for that step. If your host lets you wait between calls, check about every minute until the step shows done.
3. Where to check:
   - **Inbox:** `get_account_status`. The inbox is ready for the build when its `setupStatus` is `FINISHED`. `NEEDS_AUTH` or `DISCONNECTED` means the consent failed: say so and offer a new link.
   - **Tool sign-in or custom integration secret:** `list_integrations`, whose `status` and `secretStatus` say whether it is connected.
   - **Trial or plan:** `get_account_status`, where the plan item turns `done`.

**The polling rule.** While anything runs (an import, the build), report progress every few minutes in one line. Stop polling after an hour. Tell the person where it stands, give the brain item's `webUrl` (or the page for the step), and say they can ask you to check again later. Never poll silently for longer than a few minutes.

## 5. Giving the build your docs

The first build starts on its own once an inbox is connected and the trial starts, and it learns from the inbox's past conversations. If you can read the local repository, you can also give it what no inbox history holds: the product's own docs. Do this before the trial starts, so the build sees them. Tell the person it in those words: you are giving the build their docs.

Read the README, the docs folder, the pricing page and the FAQ. Write one knowledge entry per thing the company tells customers: a feature and how to use it, a limit, a policy, a price stated on the public site.

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

## 6. Plans: explain before any link

This step matters most. Before you send any Checkout link, call `get_billing` and explain, in a few lines:

1. **The free trial.** Its length comes from `get_billing`'s `trialDays`, said as its `trialSummary` says it, including when the card is charged. Never state a length from memory.
2. **The three plans.** How they differ and what each includes, from `get_billing`'s `plans` and the pricing page.
3. **Which conversations count.** A conversation counts toward a plan when Onbox works on it in a run: handling it on its own, answering a mention, or a conversation handed to it with `delegate_conversations`. Setting Onbox up is free, and so is handling conversations yourself, in the app or through your own agent (Claude, ChatGPT and so on): drafting, archiving, assigning to a teammate, and approving, editing or discarding what Onbox proposed. So the person needs a bigger plan only when they let Onbox work on more conversations.

Answer every pricing question from the landing, never from memory. Read the pricing page as markdown at <https://www.onbox.ing/en/pricing.md>; <https://www.onbox.ing/llms.txt> lists the rest of the site. Fetch the page when your host can; otherwise give the person the link. `get_billing` says what this organisation is offered; never state a price beyond what it or the page says.

Then let the person pick a plan. Call `update_billing` with it and give them the Checkout link (section 4): they enter the card there, and the trial starts when they come back.

## 7. The build: what it does and what to show while it runs

The build reads each connected inbox's past conversations and writes skills (how to handle each kind of request) and memories (facts and corrections) into the brain. It starts on its own once an inbox is connected and the trial starts; call `build_brain` only when the brain item says so. It takes about half an hour.

While it runs, every few minutes:

- Call `get_account_status` for where it stands, and `list_brain_files` with `scope: "org"`.
- Name what is new since the last check, not just counts, for example "New since last check: a skill for refund requests, and memories about shipping times and the CSV export."
- Offer to open one: read it with `read_brain_files` and summarise it in a few lines.

The polling rule (section 4) applies: stop after an hour and say where it stands.

## 8. After the build: review, then record the answers

When the brain item is `done`, call `list_brain_files` with `scope: "org"` and read the main files with `read_brain_files`. Summarise for the person, in a few lines: the skills (what the Onbox agent can handle), the knowledge it holds, and the rules it will follow.

Then record the answers from section 2, each in the file that already states the point, so two instructions never disagree:

- **Escalation person:** the `# Team` section of the org `AGENTS.md`, with their role.
- **Tone:** correct the line the build wrote; if none states it, add one line to the org `AGENTS.md`.
- **What the Onbox agent may do alone, and what needs approval:** `policies/tools.md`, one rule per bullet, under `## Allowed` and `## Forbidden`. A call that no allowed rule covers, or that a forbidden rule names, does not run on its own: it waits for a person. Read the file first and keep its headings. What a message must never say goes in `policies/communication.md`, under `## Forbidden`.

Show the person each change before you write it, and write all of them in one `write_brain_files` call. If the person corrects a fact, fix the file that holds it. Then check the checklist again with `get_account_status` (step 3i). That ends the setup.

## 9. The morning routine

When the person asks what waits on them, or once the first conversations arrive:

1. **List.** Call `list_my_inbox` with the filters the person wants (by `types` or `inboxIds`). Follow `nextCursor` while the person wants more.
2. **Read.** Call `get_conversations` with every returned conversation id, in one call.
3. **Show, then decide in batches.** Group the items by what they need (actions to approve, drafts, invitations to answer, escalations, requests, mentions), one line each with its `webUrl`. For an action, show what it will run: recipient, first line, any amount, and why it waits. Then act on the person's decisions, each kind in one call:
   - `approve_pending_actions` for the actions the person has seen and confirmed, each with the version you showed. Read the results back as returned. An action that changed since comes back in `errors`: show the new version and ask again.
   - `discard_pending_actions` for the actions they reject.
   - `update_draft` to change a draft, or `create_draft` with `mode: "reply"` to answer a conversation yourself. A draft waits for a person to send it.
   - `update_conversations` to archive, snooze or assign conversations to a person.
   - `delegate_conversations` to hand a conversation to Onbox, optionally with an instruction.
   - `respond_to_invitation` to answer a calendar invitation (accepted, declined or tentative) as the person decided. It notifies the organiser; calling it again changes the answer.
   - `create_comment` to answer a teammate's mention or the Onbox agent's request. A comment stays inside Onbox.
4. **Brain proposals, for an admin.** When `openBrainProposals` is above zero, end with one line saying how many wait. If the person wants to go through them, call `list_brain_proposals`, and for each one read its source conversation with `get_conversations` before you recommend a decision. Then call `accept_brain_proposals` or `decline_brain_proposals` with the ones they decided.

## Sending on its own, only when asked

Until an inbox's send mode changes, the Onbox agent drafts replies for a person to review. Never propose sending on its own during setup. When the person asks for it, at any time, explain what changes, ask them to confirm for each inbox, and only then call `update_inbox` with `sendMode: "AUTO"`.

## Things to avoid

- Never approve, discard, accept or decline on your own judgement. Only what the person has seen and confirmed.
- Never put secrets, API keys or passwords in the brain or in the conversation.
- Never retry a refused write unchanged: read the error, fix the cause, or ask the person.
- Never tell the person a step is done until `get_account_status` says so.
- Never switch an inbox to sending on its own without the person's explicit confirmation.
- Never send a Checkout link before explaining the trial, the plans and what counts (section 6).
