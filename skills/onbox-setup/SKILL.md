---
name: onbox-setup
description: Set up Onbox, the always-on agent that answers customers on every channel, and run it afterwards. Use when the person says "set up Onbox", "customer support", "connect our support mailbox", "website chat", "train the support agent on our docs", "which plan do I need", "what is waiting on me", "my inbox", "morning review", "anything to approve in Onbox", "let Onbox send on its own", or asks to review what the Onbox agent learned. Covers what a correctly set up account is, finding out before asking, the order of the setup steps, the browser steps and how to wait for them, giving the build the product's docs, explaining the plans and what counts, following the build, and the morning routine, a short summary of what waits on the person and then deciding in batches.
license: MIT
compatibility: Needs the Onbox MCP server at https://api.onbox.ing/mcp, connected and signed in. Giving the build a repository's docs needs an agent that can read the local repository.
metadata:
  author: Onbox Labs
  version: 1.7.0
---

# Setting up Onbox

Onbox runs its own agent, called Onbox unless the organisation renamed it, which answers the business's customers on every channel it connects, such as email, website chat or social messaging, and learns how to handle each request. You are the person's agent: you set Onbox up through its tools and later bring them what waits on them. In this skill, "the Onbox agent" is Onbox's, and "you" is the agent reading this.

The tools describe what each call does and returns. This skill holds the order of the calls and the judgement around them. For the words Onbox uses (brain, skills, memories, policies, pending action reasons, escalating), read [references/concepts.md](references/concepts.md) before you explain any of them to the person.

## Before any call

Through the whole setup:

- Send your plan for the remaining steps as a message of its own ending with "Shall I go ahead?", and start once they say yes (section 1).
- After each question you ask, end your turn and wait for the answer: no tool call, file write or next step until it comes.
- Give every link from an Onbox result (a `webUrl`, a connect, sign-in or Checkout link, a report or settings page) as a markdown link named for what it does, such as `[Open the checkout](<url>)` or `[Connect support@example.com](<url>)`, alone on its line when the person must click it, and keep the raw URL out of your sentences.
- Speak as yourself: give your own reason for each step, in the first person, as for any choice of yours ("I'll connect the mailbox first, so the build can read its history").
- Leave the person's repository as it is: read it, and change only what they agreed to in section 3c (the website chat snippet, or a chat screen in their mobile app when you offered one). When their docs disagree with what Onbox learned, tell them and leave the fix to them.

If no Onbox tool is available, the server is not connected or not signed in. The tools this skill names start with `get_account_status`. Another Onbox connector the person added earlier can show older tools under other names, such as `list_threads` or `brain_list_files`: it is not this server, so do not use it for the setup.

Signing in is the person's first moment with Onbox: ask for it in one short sentence, in your first message, and use the way your host opens the browser itself.

- **Claude Code** shows "MCP server needs authentication · run /mcp" when the session starts. Ask the person to type `/mcp`, choose `onbox` and then Authenticate: Claude Code opens Onbox's sign-in in their browser and loads the tools when they are back. Carry on as soon as the Onbox tools appear. Use its `authenticate` tool only if the person cannot use `/mcp`; then give the link it returns alone on its line, and ask for the address the browser landed on (for `complete_authentication`) only if they say the page showed an error.
- **Codex** shows a warning that the onbox MCP server is not logged in. Ask the person to type `/mcp login onbox`: Codex opens the sign-in in their browser.
- **Another host** with a sign-in tool for the Onbox server: call it and give the link it returns alone on its line, in one sentence.
- Only when the host offers none of these, tell the person to connect the Onbox connector and sign in, then stop.

These are the only commands you ask the person to type. If a tool this skill names is not in your list once signed in, search your tools for it before you call it missing; some hosts load tools on demand.

Passwords and API keys go through the pages Onbox links to; ask for none in the conversation.

## 1. Read where the setup stands

`get_account_status` is the source of truth for what a correctly set up account is: its checklist says which items exist, which are mandatory, and where each stands. Read it, never restate it from memory, and call it first, after every browser step, and while the brain builds.

How to read it:

- Work through the items that are not `done`, mandatory ones first. Each names its `fixTool`: that is your next call. A `null` fixTool means only waiting helps.
- `broken` means the item worked and stopped, for example a lapsed connection: fix it before adding anything new.
- `nextAction` is the one sentence to tell the person. Each item's `webUrl` is where they can do it in the browser instead.
- An account is set up when every mandatory item is `done` and the escalation item names the person from section 2. Onboarding then completes on its own (`onboardingCompletedAt`); there is no finish step.

Start from what is already done, then send the plan as a message of its own, before any question: one line per remaining step, ending with "Shall I go ahead?". Wait for the answer before you act.

If `caller.isAdmin` is false, most account tools are not available to this person. Say so, tell them who can finish the setup (an admin of their organisation), and offer what they can do: read the status, and later go through their own inbox with the morning routine.

## 2. Find out first, then ask one question at a time

Ask only what you cannot find out. If the current folder does not look like the product's repository (no README, package metadata or site code), ask once, before anything else: "Is your product's code on this computer? Give me the folder and I'll read its docs, so Onbox learns what you tell customers. Or say skip." With a path, read from there, without changing folder or restarting. With skip, carry on, and say once that Onbox will learn only from the inbox history.

Before asking anything, read what is at hand:

- The repository, if you can read it: the README, the package metadata, the site config, a support or contact email in the code, and whether the product is a website, a mobile app or both.
- The mail provider of the support address's domain, from its MX records (such as `dig +short MX acme.com`): Google, Microsoft or another. Propose that provider instead of asking which one.
- The signed-in member, from `list_members` (in a new organisation, the only member). The git author (`git config user.name`, `git config user.email`) is only a fallback.
- The project's `CLAUDE.md` or `AGENTS.md`.
- The conversation so far, and what `get_account_status` already holds: the company, the inboxes, the members.

Then ask what is left, one question per message, each with a proposed answer drawn from what you found, for example "Should escalations go to you, Marie Dupont (marie@acme.com)?" If your host has a question tool, such as Claude Code's multiple-choice question, use it and put your proposal first. Never send a block of questions.

What you need, in this order, skipping what you already know:

1. **Channels.** What the person wants Onbox to support, and where customers reach them today. Propose the channels you found in the repository, such as the support mailbox from the code, together as the first option, marked "(Recommended)". Propose the website chat only when the product has a website. For a mobile app, say an in-app chat is not available yet, and propose what fits instead: email, App Store reviews and Google Play reviews.
2. **Escalations.** Who takes a conversation the Onbox agent should not answer: a name and an email. Propose the signed-in member first, with the email they signed in with, not the git email.
3. **Tone.** Onbox writes each email reply the way the team already writes from that inbox, from its past sent replies; the tone is the guideline where it has none to go on, such as a new inbox or the website chat. Propose "Match how your team already writes" first, with a fallback tone of a sentence or two from the voice of the site or the docs.
4. **What the Onbox agent may do alone, and what needs a person's approval first.** Propose the common lines: answering how-to questions alone, such as explaining how to cancel; doing anything about money with approval, such as cancelling a subscription, a refund or a discount; never promising dates.
5. **Teammates, optional.** Ask once whether anyone else should use Onbox, with a proposed answer. If they say no, skip it and do not ask again.

If the person does not know an answer, take your proposal and tell them you did. Keep the answers for section 8.

## 3. The steps, in order

| Step | Tool                                                                            | Who acts                             |
| ---- | ------------------------------------------------------------------------------- | ------------------------------------ |
| 3a   | `update_organisation`                                                           | automatic                            |
| 3b   | `write_brain_files` (give the build your docs, see section 5)                   | automatic, coding agents only        |
| 3c   | `add_inbox` for each channel from section 2                                     | browser: the person consents         |
| 3d   | `invite_members`, only if the person wants teammates                            | automatic: each person gets an email |
| 3e   | `list_integrations`, `connect_integration`, the custom integration tools        | browser: the person signs in         |
| 3f   | explain the plans (section 6), `get_billing`, then `update_billing`             | browser: the person starts the trial |
| 3g   | follow the build (section 7)                                                    | automatic, a few minutes             |
| 3h   | read what Onbox understood, settle its requests, record the answers (section 8) | automatic, with the person           |
| 3i   | `get_account_status`                                                            | automatic                            |

Skip a step whose checklist item is `done`. Notes per step:

- **3a.** Only when the company's website or name is missing or wrong.
- **3c.** Connect the mailboxes and accounts first and the website chat last: it is the longest step. A mailbox or account returns a link, a browser step (section 4): your next message gives the link and stops, and you move on only once the person says it is done and the inbox is connected in `get_account_status`. Intercom, Zendesk and HubSpot first need the second `add_inbox` call their `next` names. A website chat returns an HTML snippet. When you can read the product's code, propose where it goes from what you found (the marketing site, the web app, or both) and ask before you change any code. On yes, add it once, where the framework expects it, on a new branch with a pull request (show the diff when you cannot open one, and never ask for extra permissions or touch their GitHub sign-in without asking). In a signed-in app, offer to pass the signed-in user with `Onbox('identify', { userId, email, name })`, so each customer keeps their own conversations; it is a hint, never a sign-in. Otherwise give them the snippet to paste. Tell the person that a website chat answers visitors on its own from the start, unlike an email inbox; if they want its replies held for review, call `update_inbox` with `sendMode: "ASK"`.
- **3d.** The escalation person from section 2 if they are not a member yet, and the teammates the person named. Read each result's `emailSent`: when it is `false`, the invitation exists but its email did not go out. Say so with `emailError`, give the person `invitationUrl` to pass on, or call `invite_members` again for that address to resend it.
- **3e.** Optional: tools the Onbox agent uses while answering, such as Linear, GitHub or Notion. Connect only what the person names. When the company has its own API or MCP server, call `preview_custom_integration`, then `create_custom_integration` with the auth it suggests; the person enters any secret through the returned link, then run `test_integration`. Read its `verified` and `note`: when the test could not tell whether the secret works, call `test_integration` again with `operation`, a read operation that needs the secret, and `arguments` for a record you know exists, such as the person's own account. Run every check yourself; never ask the person to run a command.
- **3f.** The trial also starts the first build, so do 3b first.
- **3i.** Check that every mandatory item is `done`. If one is not, tell the person and give that item's `webUrl`. Setup ends here, after the review of what Onbox learned.

## 4. Browser steps and waiting

A browser step is one only the person can do: provider consent, a tool sign-in, payment, a secret. For each:

1. A browser step is a stop. The message right after the call gives the link, named for what it does and pointing to the URL exactly as returned, alone on its line, with one sentence saying what they will see when they open it, and ends your turn: no other step, question, tool call or background wait. Never say you gave a link unless it is in that message, and never say a page is open in their browser. If your host can open a URL for the person, you may offer that; never open it without asking. When a link expires, say in how many minutes, never as a clock time or in UTC.
2. Say you will check, then wait, starting in a later turn. When the person says they are done, check at once with the tool for that step. Otherwise check about every minute until the step shows done (see waiting, below).
3. Where to check:
   - **Inbox:** `get_account_status`. The inbox is ready for the build when its `setupStatus` is `FINISHED`. `NEEDS_AUTH` or `DISCONNECTED` means the consent failed: say so and offer a new link.
   - **Tool sign-in or custom integration secret:** `list_integrations`, whose `status` and `secretStatus` say whether it is connected.
   - **Trial or plan:** `get_account_status`, where the plan item turns `done`.

Some calls ask the person to confirm in your host before they run: adding an inbox, starting a plan, approving an action. A host that cannot ask, such as a non-interactive session, refuses them, with an error such as "requires permission" or "requires user interaction". That is the host, not the person or Onbox: do not retry, and do not say the person blocked it. Give the person that step's `webUrl` (the checklist item's, or for an action its conversation's) to do it in the browser, carry on with the next step, and check as above when they say it is done.

**Waiting.** Never ask the person to type "check" for you. Start a wait only in a turn after the link message has gone out. Between two checks, wait in the background: a host that runs commands can run one that sleeps for a minute or two (in Claude Code, a background command such as `sleep 120`, which wakes you when it ends), then call the tool again when it ends; a host that waits between calls on its own just waits. Only a host with no way to wait asks the person to say when to check again.

**The polling rule.** While anything runs (an import, the build), report progress every few minutes in one line. Stop polling after an hour. Tell the person where it stands, give the brain item's `webUrl` (or the page for the step), and say they can ask you to check again later. Never poll silently for longer than a few minutes.

## 5. Giving the build your docs

The first build starts on its own once an inbox is connected and the trial starts, and it learns from the inbox's past conversations. If you can read the local repository, you can also give it what no inbox history holds: the product's own docs. Do this before the trial starts, so the build sees them. Say it in the message that makes the call, with the topics, for example "I'm giving the build your docs: pricing, imports, cancelling, refunds, deleting an account."

Read the README, the docs folder, the pricing page and the FAQ. Write one knowledge entry per thing the company tells customers: a feature and how to use it, a limit, a policy, a price stated on the public site.

Write with `write_brain_files`, `scope: "org"`, all entries in one call, at `memory/kb_<slug>.md`. Each entry:

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
- `log:` starts with one `created` line: a real date, a one-word lowercase `source` (`git` for the repository, `kb` for a published help page, `team` for something the person told you), and a `ref`.
- The body has `# Title`, `## When this applies` (one sentence) and `## Answer` (opens with the outcome). Only `###` headings below that, and only inside `## Answer`.

Each entry is a new file. To change a file that already exists, read it with `read_brain_files` and pass its `version` as `expectedVersion` (see section 8).

Write only what the files state. Leave out internal notes, secrets, roadmap items and anything customers are not told. If a call fails, the error names each file and the rule it broke: fix those files and send the call again. Then tell the person how many entries you wrote and on which topics.

## 6. Plans: explain before any link

This step matters most. Before you send any Checkout link, call `get_billing` and send a message of its own (a short list or table, never one line before the question) that explains:

1. **The free trial.** Its length comes from `get_billing`'s `trialDays`, said as its `trialSummary` says it, including when the card is charged. Never state a length from memory.
2. **What is free.** Setting Onbox up, and handling conversations yourself, in the app or through your own agent (Claude, ChatGPT and so on): drafting, archiving, assigning to a teammate, and approving, editing or discarding what Onbox proposed.
3. **The three plans.** How they differ and what each includes, from `get_billing`'s `plans` and the pricing page.
4. **Which conversations count.** A conversation counts toward a plan when Onbox works on it in a run: handling it on its own, answering a mention, or a conversation handed to it with `delegate_conversations`. So the person needs a bigger plan only when they let Onbox work on more conversations.

Answer every pricing question from the landing, never from memory. Read the pricing page as markdown at <https://www.onbox.ing/en/pricing.md>; <https://www.onbox.ing/llms.txt> lists the rest of the site. Fetch the page when your host can. If the fetch fails or your host cannot fetch, say you could not read it and give the person the link; never describe what a page you did not read says. `get_billing` says what this organisation is offered; never state a price beyond what it or the page says.

Only after that message, ask which plan they want, as its own question (a question tool's text does not count as the explanation). Call `update_billing` with it and give them the Checkout link (section 4): they enter the card there, and the trial starts when they come back.

## 7. The build: what it does and what to show while it runs

The build reads each connected inbox's past conversations and writes skills (how to handle each kind of request) and memories (facts and corrections) into the brain. It starts on its own once an inbox is connected and the trial starts; call `build_brain` only when the brain item says so. Tell the person it takes a few minutes, with no closer estimate, and let your checks report when it is done.

Follow it without being asked: wait in the background between checks (section 4, waiting), and every few minutes:

- Call `get_account_status` for where it stands, and `list_brain_files` with `scope: "org"`.
- Name what is new since the last check, not just counts, for example "New since last check: a skill for refund requests, and memories about shipping times and the CSV export."
- Offer to open one: read it with `read_brain_files` and summarise it in a few lines.

The polling rule (section 4) applies: stop after an hour and say where it stands.

If the brain item turns `done` with no new skill or memory although the inbox has past conversations, the build did not learn from them. Do not guess why: call `list_my_inbox`, where the build leaves a request saying what blocked it, read it with `get_conversations` (and `get_comments` for a comment in full) and tell the person.

## 8. After the build: what Onbox understood, its requests, then the answers

When the brain item is `done`, it names Onbox's own report in `report`: the conversation where Onbox says what it understood from the history. Find its message with `get_conversations`, which shows comments only as a preview, then read the message in full with `get_comments`, and give it to the person as it is written, in Onbox's words: the opening counts, what it can handle and why, what it noticed, and what it needs from them. It is Onbox's message, not yours: do not summarise it from the brain files instead. `report` is null until the message is written; while it is, say the build is done and the report is on its way, and check again. (A build on an account with no report, such as one finished before this version, has none: then call `list_brain_files` with `scope: "org"`, read the main files with `read_brain_files`, and summarise in a few lines the skills, the knowledge and the rules.)

What Onbox needs from the person arrives as its requests, one conversation each, assigned to them: call `list_my_inbox` and read each request with `get_conversations`. Before you bring one to the person, try to settle it yourself from what is at hand: the local repository and its docs, when you can read them, often hold the rule, the page or the reason Onbox could not find in the mailbox. When you find it, reply on the request with `create_comment`, saying what you found and where, in one or two sentences, so Onbox records it; the request then leaves the inbox. When you do not, bring the request to the person with Onbox's proposal first, and reply with their answer. Never answer a request from memory or with a guess.

Then record the answers from section 2, each in the file that already states the point, so two instructions never disagree:

- **Escalation person:** the `# Team` section of the org `AGENTS.md`, with their role.
- **Tone:** the guideline for replies with no past ones to follow: correct the line the build wrote; if none states it, add one line to the org `AGENTS.md`.
- **What the Onbox agent may do alone, and what needs approval:** `policies/tools.md`, one rule per bullet, under `## Allowed` and `## Forbidden`. A call that no allowed rule covers, or that a forbidden rule names, does not run on its own: it waits for a person. Read the file first and keep its headings. What a message must never say goes in `policies/communication.md`, under `## Forbidden`.

The build may have written any of these files. Read each one with `read_brain_files` right before you write it, merge your change into its content, and pass its `version` as `expectedVersion`. A path it lists under `missing` does not exist yet: you create it, with `expectedVersion: null`. That is the normal case on a new account, not an error. A refusal names the file and shows its current lines: read it again, merge, and send the call again. Never replace a file you have not read.

Show the person each change before you write it, and write all of them in one `write_brain_files` call. If the person corrects a fact, fix the file that holds it. Then check the checklist again with `get_account_status` (step 3i). That ends the setup.

## 9. The morning routine

When the person asks what waits on them, or once the first conversations arrive, give them a short summary first, never a list of emails.

1. **Gather.** Call `list_my_inbox` with no filters (pass `since` as the time of your last summary when you know it) and `get_account_status`, together. The first page's `summary` counts the whole list; write from it, not from the items.
2. **Summarise** in one or two short paragraphs, numbers first, in this order, leaving out what is zero:
   - **Quick to clear:** drafts ready to send (`byReason.draft`), actions to approve (`pending_action`), invitations to answer.
   - **Needs their judgement:** Onbox's requests and escalations, mentions, failed sends and runs (`failed`), customers waiting over a day (`waitingOverADay`, the longest since `oldestWaitingSince`), customers who wrote again (`followedUp`). Name `important` only when it singles out fewer than all that wait.
   - **Waiting on the team,** from `summary.sharedInboxes` when present: the customers waiting unassigned in the person's shared inboxes, outside their My inbox, per inbox with its address and the longest wait ("9 customers waiting in support@acme.com, the oldest since Monday"), then the oldest few by customer and subject, with their `webUrl`. Nobody has taken these, so always say them, even when My inbox is clear; when `waiting` is 0, say the shared inboxes are clear. To go through them, read the `oldest` ids with `get_conversations`, then assign each to a person or delegate it to Onbox as the person decides.
   - **What Onbox did on its own** since `handledByOnbox.since`: replies sent, conversations archived, in one sentence.
   - **What is broken,** from `get_account_status`: an inbox `NEEDS_AUTH` or `DISCONNECTED` to reconnect, a stuck build; a brain still building means Onbox is still learning, so it drafts more than it settles. For an admin, the brain proposals waiting (`openBrainProposals`).
   - Then the link, `[Open your inbox](<summary.webUrl>)`, and one question offering the quickest batch: "Want to go through the 4 drafts?"

   Plain words and real numbers only: never invent urgency or a reason the data does not give, and say times relative to now ("since Monday"). When nothing waits, say so in one sentence with what Onbox did. With hundreds, keep the same shape and offer the biggest quick batch, or one inbox (`inboxIds`). Never list conversations unless the person asks.

3. **Go through a batch when they say yes.** Call `list_my_inbox` with that batch's `types`, read the conversations with `get_conversations` in one call, and show each one in a line with its `webUrl`. For an action, show what it will run: recipient, first line, any amount, and why it waits. Then act on the person's decisions, each kind in one call:
   - `approve_pending_actions` for the actions the person has seen and confirmed, each with the version you showed. Tell the person each result's `outcome` as returned: it says whether the action ran, had already run, or failed and why. An action that changed since comes back in `errors`: show the new version and ask again.
   - `discard_pending_actions` for the actions they reject.
   - `update_draft` to change a draft, or `create_draft` with `mode: "reply"` to answer a conversation yourself. Each time you write or change a draft, show the person its recipients and text and ask whether to send it now or change it, as the result's `next` says; never end on a link to review it in Onbox. A draft that waits on someone else is not theirs to send: say who it waits on. To send a draft you did not just write, read it with `get_draft` and show the person its recipients and text; once they said to send it, `send_draft` with the `version` and the `to`, `cc` and `bcc` you showed sends it, a reply, forward or new email alike (a changed draft, other recipients or a policy refusal come back as an error that says what to do). `send_draft` queues the email: tell the person it is queued, never that it went out. A minute later, read it with `get_draft`: `SENT` means it went out, so say so; back to `DRAFT` or `FAILED` means it did not, so tell them and offer to try again. Never mention an undo window shorter than a minute.
   - `update_conversations` to archive, snooze or assign conversations to a person.
   - `delegate_conversations` to hand a conversation to Onbox, optionally with an instruction.
   - `respond_to_invitation` to answer a calendar invitation (accepted, declined or tentative) as the person decided. It notifies the organiser; calling it again changes the answer.
   - `create_comment` to answer a teammate's mention or the Onbox agent's request. For a request, look in the local repository and its docs first, as in section 8, and reply with what you found or with the person's answer. A comment stays inside Onbox.
4. **Brain proposals, for an admin.** If the person wants to go through them, call `list_brain_proposals`, and for each one read its source conversation with `get_conversations` before you recommend a decision. Then call `accept_brain_proposals` or `decline_brain_proposals` with the ones they decided.

## Sending on its own, only when asked

An email inbox starts in review: the Onbox agent drafts replies for a person to send. A website chat starts live, because a visitor waits in it: it answers on its own whenever the communication policy allows. `list_inboxes` gives each inbox's send mode; check it before you tell the person what is sent on its own. Never propose sending on its own during setup. When the person asks for it, at any time, explain what changes, ask them to confirm for each inbox, and only then call `update_inbox` with `sendMode: "AUTO"`.

## Things to avoid

- Never approve, discard, accept or decline on your own judgement. Only what the person has seen and confirmed.
- Never put secrets, API keys or passwords in the brain or in the conversation.
- Never retry a refused write unchanged: read the error, fix the cause, or ask the person.
- Never tell the person a step is done until `get_account_status` says so. Say Onbox is set up only after you gave them Onbox's report (section 8) and step 3i passed.
- Give times in the person's local time or relative to now, never in UTC.
- Never state why something happened unless a tool result says so: when nothing says why, say you do not know, and look where the skill says (for a build, `list_my_inbox`). Never describe a document, page or price you did not fetch.
- Never ask the person to run a command or check something a tool can check for you.
- Never switch an inbox to sending on its own without the person's explicit confirmation.
- Never send a Checkout link before explaining the trial, the plans and what counts (section 6).
