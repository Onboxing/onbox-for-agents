---
name: onbox-setup
description: Set up Onbox, the AI agent for customer support, and work with it afterwards. Use when the person says "set up Onbox", "customer support", "support inbox", "connect our support mailbox", "website chat", "train the support agent on our docs", "what is waiting on me", "anything to approve in Onbox", or asks to review what the Onbox agent learned. Covers the order of the setup steps, the questions to ask first, the browser steps and how to wait for them, seeding the agent's knowledge from a repository's docs, and deciding pending actions and brain proposals.
license: MIT
compatibility: Needs the Onbox MCP server at https://api.onbox.ing/mcp, connected and signed in. Seeding knowledge from files needs an agent that can read the local repository.
metadata:
  author: Onbox Labs
  version: 1.1.0
---

# Setting up Onbox

Onbox runs its own agent, called Onbox unless the organisation renamed it, which answers customers on the support inbox and website chat. You are the person's agent: you set Onbox up through its tools and later bring them what waits on them. In this skill, "the Onbox agent" is Onbox's, and "you" is the agent reading this.

The tools return everything you need to know about one call. This skill holds the order of the calls and the judgement around them. For the words Onbox uses (brain, skills, memories, policies, pending action reasons, escalating), read [references/concepts.md](references/concepts.md) before you explain any of them to the person.

## Before any call

If no Onbox tool is available, the server is not connected or not signed in. Tell the person to connect the Onbox connector and sign in, then stop. Never ask for a password or an API key in the conversation.

## 1. Read where the setup stands

Call `setup_get_status`. It returns the company, the onboarding step, every inbox with its `setupStatus`, funding, the brain build progress, `nextAction` in one sentence, and `webUrls` for each step. Start from what is already done: an organisation that signed up on the web may have a mailbox connected and only need the build.

Then give the person a short plan, one line per remaining step, and let them confirm it before you act.

If `caller.isAdmin` is false, most setup tools are not available to this person. Say so, tell them who can finish the setup (an admin of their organisation), and offer what they can do: read the status, and later review what waits on them.

## 2. Ask first, in one message

Ask these together, before any write, and keep the answers for section 6:

1. Which mailbox do customers write to (for example support@ or help@), and is it Gmail or Google Workspace, or Outlook or Microsoft 365? Do they also want a chat on their website?
2. Who handles escalations: the person who takes a conversation when the Onbox agent should not answer it? A name and email of a member of the organisation.
3. What tone should replies have? A sentence or two, or a past reply they like.
4. What may the Onbox agent do alone, and what needs a person's approval first? Common lines: answering how-to questions alone; refunds, cancellations, discounts and anything about money with approval; never promising dates.

If the person does not know an answer yet, take the sensible default (escalations go to the person you are talking to; everything that changes an account or money needs approval) and tell them you did.

## 3. The steps, in order

| Step | Tool                                                       | Who acts                          |
| ---- | ---------------------------------------------------------- | --------------------------------- |
| 3a   | `setup_set_company`                                        | automatic                         |
| 3b   | `brain_write_files` (seed knowledge, see section 5)        | automatic, coding agents only     |
| 3c   | `setup_connect_channel`                                    | browser: the person consents      |
| 3d   | `setup_create_website_chat`                                | automatic, then paste the snippet |
| 3e   | `list_available_integrations`, `setup_connect_integration` | browser: the person signs in      |
| 3f   | `billing_get_topup_link`                                   | browser: the person pays          |
| 3g   | `setup_start_build`, then poll `setup_get_status`          | automatic, about 30 minutes       |
| 3h   | review the brain, record the answers (section 6)           | automatic, with the person        |
| 3i   | `setup_complete`                                           | automatic                         |

Skip a step that `setup_get_status` shows as done. Notes per step:

- **3a.** Only while the website step is current. Pass the website; pass the name only when the domain does not say it.
- **3c.** Use the mailbox from question 1. `provider` is `google` or `microsoft`; `name` is the inbox name, for example "Support"; leave `shared` at its default so the whole team sees it. The link is personal and expires after 30 minutes.
- **3d.** Only if they want a website chat. The tool returns an HTML `snippet`. If you can edit the site's repository, add the snippet before `</body>` on every page and show the person the diff; otherwise give them the snippet to paste.
- **3e.** Optional: tools the Onbox agent will use while answering, such as Linear, GitHub, Notion or Slack. Call `list_available_integrations` first and connect only what the person names. A sign-in link expires after two minutes: give it right away and call again if it lapsed. For a tool that needs an API key, give the `settingsUrl`; keys never go through you.
- **3f.** Only when `funding.buildUnlocked` is false. If `billing_get_topup_link` is not available on this host, give `webUrls.settingsBilling` instead. Never state a price beyond what the tool returns.
- **3g.** Needs a connected inbox whose `setupStatus` is `FINISHED` and funding. If it returns what is missing, go back to that step.
- **3i.** Returns the delegate triggers and `escalationFallbacks` per inbox. Check that the fallback is the escalation person from question 2. If not, tell the person and give `webUrls.settingsInboxes`.

## 4. Browser steps and waiting

A browser step is one only the person can do: provider consent, a tool sign-in, payment. For each:

1. Give the link exactly as returned, alone on its line, with one sentence saying what they will see and that it opens in their browser. If your host can open a URL for the person, you may offer that; never open it without asking.
2. Say you will check, then wait. When the person says they are done, check at once with the tool for that step. If your host lets you wait between calls, check about every minute until the step shows done.
3. Where to check:
   - **Mailbox or channel:** `setup_get_status`. The mailbox is connected when its inbox appears, and ready for the build when `setupStatus` is `FINISHED`. `NEEDS_AUTH` or `DISCONNECTED` means the consent failed: say so and offer a new link.
   - **Tool sign-in:** `list_available_integrations`, whose `status` for that tool says whether it is connected. `setup_get_status` does not report integrations.
   - **Payment:** `setup_get_status`, where `funding.buildUnlocked` turns true.

**The polling rule.** While anything runs (an import, the build), report progress every few minutes in one line, for example "Build running: 12 skills and 40 memories saved so far." Stop polling after an hour. Tell the person where it stands, give `webUrls.build` (or the page for the step), and say they can ask you to check again later. Never poll silently for longer than a few minutes.

## 5. Seeding the brain from a repository

If you can read the local repository, you can give the Onbox agent what no inbox history holds: the product's own docs. Do this before `setup_start_build` so the build sees it. Read the README, the docs folder, the pricing page and the FAQ. Write one knowledge entry per thing the company tells customers: a feature and how to use it, a limit, a policy, a price stated on the public site.

Write with `brain_write_files`, `scope: "org"`, all entries in one call, at `memory/kb_<slug>.md`. Each entry:

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

When `brain.buildCompleted` is true, call `brain_list_files` with `scope: "org"` and read the main files with `brain_read_files`. Summarise for the person, in a few lines: the skills (what the Onbox agent can handle), the knowledge it holds, and the rules it will follow.

Then record the answers from step 2, each in the file that already states the point, so two instructions never disagree:

- **Escalation person:** the `# Team` section of the org `AGENTS.md`, with their role.
- **Tone:** correct the line the build wrote; if none states it, add one line to the org `AGENTS.md`.
- **What the Onbox agent may do alone, and what needs approval:** `policies/tools.md`, one rule per bullet, under `## Allowed` and `## Forbidden`. A call that no allowed rule covers, or that a forbidden rule names, does not run on its own: it waits for a person. Read the file first and keep its headings. What a message must never say goes in `policies/communication.md`, under `## Forbidden`.

Show the person each change before you write it, and write all of them in one `brain_write_files` call. If the person corrects a fact, fix the file that holds it. Then run `setup_complete`.

## 7. What is waiting on the person

When the person asks what waits on them, or after setup when the first conversations arrive:

Call `list_waiting_on_me` and show each pending action on one line: the customer, what it does, the recipients, the first line of the message, any amount, why it waits (`reasonInWords`), and the `webUrl`. Ask about each item separately and never offer "approve all". To change an item, call `update_pending_action`, then read it again so you have its new `version`. To approve, call `approve_pending_action` with the `pendingActionId` and the `version` you showed as `reviewedVersion`. If the action changed since you showed it, nothing runs: show the new version and ask again. After approving, read the result back to the person exactly as returned (`did` and `webUrl`), so the host's permission prompt and Onbox's action read as one decision. For brain proposals, show the title, the commits and the files (`list_brain_proposals` with `proposalId` returns the diff), then call `decide_brain_proposal` with the `headSha` you showed as `reviewedHeadSha`.

The same call lists drafts, escalations and agent requests, each with a `webUrl`. Show them the same way. To read a draft, call `get_draft_content`; to read a conversation, call `get_threads_timeline`. To discard an action the person rejects, call `discard_pending_action`.

## Things to avoid

- Never approve, discard or merge on your own judgement, and never batch decisions the person made one by one.
- Never put secrets, API keys or passwords in the brain or in the conversation.
- Never retry a refused write unchanged: read the error, fix the cause, or ask the person.
- Never tell the person a step is done until `setup_get_status` says so.
