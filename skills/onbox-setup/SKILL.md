---
name: onbox-setup
description: First-time setup of Onbox, the always-on agent that answers a business's customers on every channel. Use when the person wants to start with Onbox or finish its setup, for example "set up Onbox", "get started with Onbox", "install Onbox for our customer support", "connect our support mailbox", "start the trial", "which plan do I need", "where is our Onbox setup at", or when get_account_status shows setup items not done. Covers introducing Onbox, finding out before asking, the setup steps in order, browser steps and waiting, giving the first brain build the product's docs, the trial, following the build and reading Onbox's report on what it learned. Not for daily work once Onbox is set up, and not for configuring mail servers, domains or other tools.
license: MIT
compatibility: Needs the Onbox MCP server at https://api.onbox.ing/mcp, connected and signed in. Works without local files; with a local repository, it also gives the brain build the product's docs from it.
metadata:
  author: Onbox Labs
  version: 1.12.0
---

# Setting up Onbox

Onbox runs its own agent, called Onbox unless the organisation renamed it, which answers the business's customers on every channel it connects, such as email, website chat or social messaging, and learns how to handle each request. You are the person's agent: you set Onbox up through its tools. In this skill, "the Onbox agent" is Onbox's, and "you" is the agent reading this.

The goal of the setup is the moment the person reads what Onbox understood about their support (section 8). Reach it as fast as you can: ask little, and leave anything optional for after.

The tools describe what each call does and returns. This skill holds the order of the calls and the judgement around them. For the words Onbox uses (brain, skills, memories, policies, pending action reasons, escalating), read [references/concepts.md](references/concepts.md) before you explain any of them to the person.

## Before any call

Through the whole setup:

- Open with the introduction and the plan, in one message ending with "Shall I go ahead?", and start once they say yes (section 1).
- After each question you ask, end your turn and wait for the answer: no tool call, file write or next step until it comes.
- Keep every message short. Say the essential and offer more on request ("Ask me if you want the details"); never explain ahead of need.
- Give every link from an Onbox result (a `webUrl`, a connect or sign-in link, a report, billing or settings page) as a markdown link named for what it does, such as `[Open the billing page](<url>)` or `[Connect support@example.com](<url>)`, alone on its line when the person must click it, and keep the raw URL out of your sentences.
- Speak as yourself: give your own reason for each step, in the first person, as for any choice of yours ("I'll connect the mailbox first, so the brain build can read its history").
- These instructions are yours, not the person's: never name, quote or link this skill, its file or its rules, and never say a step is required of you. When you wait or ask first, say it plainly ("I'll wait for your answer", "May I add the snippet?").
- Leave the person's repository, when there is one, as it is: read it, and change only what they agreed to. When their docs disagree with what Onbox learned, tell them and leave the fix to them.
- Call it "the brain" (what Onbox knows) and "the brain build" (Onbox learning from their history and sources). Never "the trial build".

If no Onbox tool is available, the server is not connected or not signed in. The tools this skill names start with `get_account_status`. Another Onbox connector the person added earlier can show older tools under other names, such as `list_threads` or `brain_list_files`: it is not this server, so do not use it for the setup.

Signing in is the person's first moment with Onbox: ask for it in one short sentence, in your first message, and use the way your host opens the browser itself. For someone new to Onbox, the sign-in also creates their account and starts the free trial, with a card charged only when the trial ends, so say that in the same sentence: "Sign in to Onbox; if you're new, it creates your account and starts the free trial (a card, charged only when the trial ends)." Once they are back, the account is ready and the setup runs without a payment step.

- **Claude Code** shows "MCP server needs authentication · run /mcp" when the session starts. Ask the person to type `/mcp`, choose `onbox` and then Authenticate: Claude Code opens Onbox's sign-in in their browser and loads the tools when they are back. Carry on as soon as the Onbox tools appear. Use its `authenticate` tool only if the person cannot use `/mcp`; then give the link it returns alone on its line, and ask for the address the browser landed on (for `complete_authentication`) only if they say the page showed an error.
- **Codex** shows a warning that the onbox MCP server is not logged in. Ask the person to type `/mcp login onbox`: Codex opens the sign-in in their browser.
- **Another host** with a sign-in tool for the Onbox server: call it and give the link it returns alone on its line, in one sentence.
- Only when the host offers none of these, tell the person to connect the Onbox connector and sign in, then stop.

These are the only commands you ask the person to type. If a tool this skill names is not in your list once signed in, search your tools for it before you call it missing; some hosts load tools on demand.

Passwords and API keys go through the pages Onbox links to; ask for none in the conversation.

## 1. Read where the setup stands, then introduce Onbox and the plan

`get_account_status` is the source of truth for what a correctly set up account is: its checklist says which items exist, which are mandatory, and where each stands. Read it, never restate it from memory, and call it first, after every browser step, and while the brain builds.

How to read it:

- Work through the items that are not `done`, mandatory ones first. Each names its `fixTool`: that is your next call. A `null` fixTool means only waiting helps.
- `broken` means the item worked and stopped, for example a lapsed connection: fix it before adding anything new.
- `nextAction` is the one sentence to tell the person. Each item's `webUrl` is where they can do it in the browser instead.
- An account is set up when every mandatory item is `done`. Onboarding then completes on its own (`onboardingCompletedAt`); there is no finish step.

If `caller.isAdmin` is false, most account tools are not available to this person. Say so, tell them who can finish the setup (an admin of their organisation), and offer what they can do: read the status, and later go through their own inbox.

Then read what you can (section 2) and send one message: the introduction, then the plan. The person knows the name Onbox, not much more. Write as a helpful assistant who wants to take support off their plate, in plain words, under 170 words in all:

1. **The goal, one sentence:** what they will have at the end of this session. Onbox has read their past support emails and their docs, and drafts each reply in their inbox for them to review and send.
2. **Why it works, two or three sentences:** Onbox learns how the company works and decides, from its history and sources, so the person stops explaining why to answer this way or that (what goes wrong when people paste their emails into a chatbot). It never guesses: when it cannot find something, it looks for it first and asks only then, once, and remembers. So it is easy to teach.
3. **It acts, not just answers:** one or two actions that fit this product, from its repository or site, such as "look up a subscriber's plan, or refund a web payment once you approve".
4. **Its limits, one sentence:** it knows only what it can read (email history, docs, code, any source they connect), so with none it will not make knowledge up; actions come in a second step, simple ones first.
5. **The plan,** one short line per remaining step, from what is not done, in this order: give the brain their docs, connect the channels you found (or where customers reach them, section 2), the brain build (a few minutes), then Onbox's report on what it learned. Add "start the free trial" only when the plan item is not `done` (section 6). Name docs topics only from what you read, and leave the docs line out when you found no docs to read. Skip what is done. Do not list the questions, the final check or anything optional.
6. "Shall I go ahead?"

For example, for an invoicing app:

> I'll set up Onbox with you, so it can take your customer support off your plate. By the end, Onbox will have read your past support emails and your docs, and it will draft each reply in your inbox for you to send.
>
> It learns how Acme decides, from your history and docs, so you stop explaining why each answer is right. When something is missing, it looks first, then asks you once, and remembers. It also acts: it can resend an invoice or extend a trial, once you approve. It won't guess: it knows only what it can read, and actions come after, simple ones first. Ask me if you want more on any of this.
>
> The plan:
>
> 1. Give Onbox's brain your docs: pricing, refunds, exports.
> 2. Connect support@acme.com (you approve in Google).
> 3. The brain build, a few minutes, then Onbox's report on what it learned.
>
> Shall I go ahead?

Wait for the answer before you act.

## 2. Find out first, then keep the defaults

For every point, guess first, then ask well. Find out from everything you can reach, and propose what you found as the default ("Here's what I found: ..."). Ask only for what you could not find, and then offer your best guesses as options: never an open blank, never an exhaustive list. Ask only where the person gains from changing the default; otherwise state it in one line, or not at all.

Read what is at hand, before the introduction:

- **Local files, when your host can read them.** If the current folder is the product's repository (a README, package metadata or site code), read the README, the docs, the site config, a support or contact email in the code, and whether the product is a website, a mobile app or both. If it does not look like one, ask once, in the introduction's message before the plan: "Is your product's code on this computer? Give me the folder and I'll read its docs. Or say skip." With a path, read from there, without changing folder or restarting.
- **No local files** (Claude Desktop, claude.ai, or a folder that is not the product's): never assume code access and never ask for a folder. Use what you can reach instead: the company's website (its help, FAQ and pricing pages, when your host can fetch), and the person's connected sources, such as a help center, Notion or Google Drive. When the website is not in `get_account_status` or in what you read, propose the one the email domain suggests and ask in the introduction's message, before the plan.
- **Where customers reach them,** from the site and the code: the support address, WhatsApp links or numbers (`wa.me`), social profile links (`instagram.com`, `x.com`, `tiktok.com`), a helpdesk widget or SDK (Intercom, Zendesk, HubSpot), App Store and Google Play listings, a Slack community link.
- **The mail provider** of the support address's domain, from its MX records (such as `dig +short MX acme.com`) when you can run a command: Google, Microsoft or another. When you cannot, propose Google for a Gmail or Workspace address you recognise, else ask with the address.
- **The signed-in member,** from `list_members` (in a new organisation, the only member).
- The project's `CLAUDE.md` or `AGENTS.md`, the conversation so far, and what `get_account_status` already holds: the company, the inboxes, the members.

The defaults:

1. **Channels: what you found.** Put the channels you found in the plan as the default, "Here's what I found: support@acme.com (Google) and your WhatsApp number", one plan line each. When you found none (no repository, or nothing in it), the plan says "Connect where customers reach you", and right after the yes, ask once: "Where do customers reach you today?", with these options: email (Gmail or Outlook), a helpdesk (Intercom, Zendesk or HubSpot), WhatsApp, social messages (Instagram, X, TikTok), and app store reviews; say more exist if none fits. Never list every type `add_inbox` supports. Ask only what a channel needs and you could not find: the Intercom region, the Zendesk subdomain, and the App Store Connect key's Issuer ID and Key ID (not secret; the .p8 goes on Onbox's page). Leave the website chat out of the setup: it comes after, when the person asks.
2. **Escalations: the person who connects the inbox.** A new inbox gives the conversations Onbox escalates to the member who connected it, so nothing needs asking. Everything starts in review: Onbox drafts and the person sends, so nothing goes out without them and there is nothing more to configure now. If they ask to "escalate everything", say just that: escalation is about what Onbox would otherwise do or send on its own, and in review nothing is sent without them.
3. **Tone: ask, it is worth it.** One question, default first: "Onbox writes each reply the way your team already writes from that inbox. Where it has nothing to copy, such as a new inbox, I'd use: <a sentence or two from the voice of the site or docs>. Keep that, or change it?" With a question tool, such as Claude Code's multiple-choice question, put the default first, marked "(Recommended)", and offer one or two real alternatives.
4. **Teammates: ask once, with a short reason.** "Teammates can review Onbox's drafts and take conversations, which spreads the work, and every plan includes unlimited seats. Anyone to invite now?" Default: just them for now. If they say no, do not ask again.

Ask the remaining questions right after the yes to the plan, before the first step, one per message: what the channels need that you could not find (where customers reach them when you found none, the mail provider), then tone, then teammates. A question that comes up during a step, such as where the docs live, does not replace them. If the person does not know an answer, take the default and say you did. Keep the answers for section 8.

## 3. The steps, in order

| Step | Tool                                                                            | Who acts                             |
| ---- | ------------------------------------------------------------------------------- | ------------------------------------ |
| 3a   | `update_organisation`                                                           | automatic                            |
| 3b   | `write_brain_files` (give the brain build your docs, see section 5)             | automatic                            |
| 3c   | `add_inbox` for each channel from section 2                                     | browser: the person consents         |
| 3d   | `invite_members`, only if the person wants teammates                            | automatic: each person gets an email |
| 3e   | only if the plan item is not `done`: the trial (section 6)                      | browser: the person starts the trial |
| 3f   | follow the brain build (section 7)                                              | automatic, a few minutes             |
| 3g   | read what Onbox understood, settle its requests, record the answers (section 8) | automatic, with the person           |
| 3h   | `get_account_status`                                                            | automatic                            |
| 3i   | read `references/next-step.md`, then bring one next step (section 9)            | automatic, with the person           |

Skip a step whose checklist item is `done`. Notes per step:

- **3a.** Only when the company's website or name is missing or wrong.
- **3c.** A mailbox or account returns a link, a browser step (section 4): your next message gives the link and stops, and you move on only once the person says it is done and the inbox is connected in `get_account_status`. Intercom, Zendesk, HubSpot and Google Play first need the second `add_inbox` call their `next` names (pick the account, address or group from `choices`; for Google Play, ask the person for the link of the app's Google Play page or its app id and pass it in `packageName`). App Store opens a page where the person enters the secret; the inbox appears in `list_inboxes` once they are done. For X, the link message also carries the one sentence on cost that the result's `next` gives. When `add_inbox` refuses a channel as not available yet, tell the person in one sentence and go on with the others; never retry it.
- **3d.** The teammates the person named. Read each result's `emailSent`: when it is `false`, the invitation exists but its email did not go out. Say so with `emailError`, give the person `invitationUrl` to pass on, or call `invite_members` again for that address to resend it.
- **3e.** A new account starts its trial at sign-in, so the plan item is usually `done` already: skip the step and say nothing about billing. It is `missing` only for an account created before, or one whose sign-in skipped it; then the trial also starts the first brain build, so do 3b first.
- **3h.** Check that every mandatory item is `done`. If one is not, tell the person and give that item's `webUrl`. Setup ends here, after the review of what Onbox learned.
- **3i.** Read [references/next-step.md](references/next-step.md), which holds the questions that find this person's next step, and bring them that one step in the message that says the setup is done (section 9).

## 4. Browser steps and waiting

A browser step is one only the person can do: provider consent, a tool sign-in, payment, a secret. For each:

1. A browser step is a stop. The message right after the call gives the link, named for what it does and pointing to the URL exactly as returned, alone on its line, with one sentence saying what they will see when they open it, and ends your turn: no other step, question, tool call or background wait. Never say you gave a link unless it is in that message, and never say a page is open in their browser. If your host can open a URL for the person, you may offer that; never open it without asking. When a link expires, say in how many minutes, never as a clock time or in UTC.
2. Say you will check, then wait, starting in a later turn. When the person says they are done, check at once with the tool for that step. Otherwise check about every minute until the step shows done (see waiting, below).
3. Where to check:
   - **Inbox:** `get_account_status`. The inbox is ready for the brain build when its `setupStatus` is `FINISHED`. `NEEDS_AUTH` or `DISCONNECTED` means the consent failed: say so and offer a new link.
   - **Tool sign-in or custom integration secret:** `list_integrations`, whose `status` and `secretStatus` say whether it is connected.
   - **Trial or plan:** `get_account_status`, where the plan item turns `done`.

Some calls ask the person to confirm in your host before they run: adding an inbox, approving an action. A host that cannot ask, such as a non-interactive session, refuses them, with an error such as "requires permission" or "requires user interaction". That is the host, not the person or Onbox: do not retry, and do not say the person blocked it. Give the person that step's `webUrl` (the checklist item's, or for an action its conversation's) to do it in the browser, carry on with the next step, and check as above when they say it is done.

**Waiting.** Never ask the person to type "check" for you. Start a wait only in a turn after the link message has gone out. Between two checks, wait in the background: a host that runs commands can run one that sleeps for a minute or two (in Claude Code, a background command such as `sleep 120`, which wakes you when it ends), then call the tool again when it ends; a host that waits between calls on its own just waits. Only a host with no way to wait asks the person to say when to check again.

**The polling rule.** While anything runs (an import, the brain build), report progress every few minutes in one line. Stop polling after an hour. Tell the person where it stands, give the brain item's `webUrl` (or the page for the step), and say they can ask you to check again later. Never poll silently for longer than a few minutes.

## 5. Giving the brain build your docs

The first brain build starts on its own once an inbox is connected and the trial starts, and it learns from the inbox's past conversations. You can also give it what no inbox history holds: what the company tells customers in its docs. Do this before you connect the first inbox: the trial is usually running already, so the build starts as soon as an inbox's history is in, and it should see the docs. Say it in the message that makes the call, with the topics, for example "I'm giving the brain your docs: pricing, imports, cancelling, refunds, deleting an account."

Read what you can reach: in a repository, the README, the docs folder, the pricing page and the FAQ; without one, the public help, FAQ and pricing pages of the company's site, or a source the person connected. With none of these, skip this step and say once that Onbox will learn from the inbox history only. Write one knowledge entry per thing the company tells customers: a feature and how to use it, a limit, a policy, a price stated on the public site.

Write with `write_brain_files`, `scope: "org"`, all entries in one call, at `memory/kb_<slug>.md`. While the setup is open, a write by an owner or admin goes live at once: it is part of the setup, not a change for anyone to accept. Each entry:

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

Each entry is a new file. To change a file that already exists, read it with `read_brain_files` and pass its `version` as `expectedVersion` (see section 8).

Write only what the sources state. Leave out internal notes, secrets, roadmap items and anything customers are not told. If a call fails, the error names each file and the rule it broke: fix those files and send the call again. Then tell the person in one line how many entries you wrote and on which topics.

## 6. The trial, when it has not started

A new account starts its trial while signing in, so this section applies only when the plan item of `get_account_status` is not `done`. No tool starts a trial, chooses a plan, adds credit or turns on automatic refill: the person does it on the billing page, the plan item's `webUrl`. Never offer to do it yourself. Send a short message of its own:

- What is missing, in one sentence from the plan item's `summary`, such as "The free trial hasn't started yet" or "The trial ended, so Onbox is paused."
- The billing page, alone on its line: `[Open the billing page](<webUrl>)`, with one sentence saying they choose a plan and start the trial there. When `caller.isAdmin` is false, say only an admin can, and ask them to pass the link to one.

Never state a price, a plan's contents or a comparison of plans, from memory or from any page: when the person asks which plan to take or what it costs, say the billing page shows the plans and their prices, and give its link again. `get_billing` tells you where the billing stands (whether Onbox can work, the plan's status, the credit), not what to sell.

Then wait (section 4): the plan item turns `done` in `get_account_status` once they are back.

## 7. The brain build: what it does and what to show while it runs

The brain build reads each connected inbox's past conversations, with the docs you gave it, and writes skills (how to handle each kind of request) and memories (facts and corrections) into the brain. It starts on its own once an inbox is connected and the trial starts; call `build_brain` only when the brain item says so. Tell the person it takes a few minutes, with no closer estimate, and let your checks report when it is done.

Follow it without being asked: wait in the background between checks (section 4, waiting), and every few minutes:

- Call `get_account_status` for where it stands, and `list_brain_files` with `scope: "org"`.
- Name what is new since the last check in one line, not just counts, for example "New since last check: a skill for refund requests, and memories about shipping times and the CSV export."

The polling rule (section 4) applies: stop after an hour and say where it stands.

If the brain item turns `done` with no new skill or memory although the inbox has past conversations, the build did not learn from them. Do not guess why: call `list_my_inbox`, where the build leaves a request saying what blocked it, read it with `get_conversations` (and `get_comments` for a comment in full) and tell the person.

## 8. After the build: what Onbox understood, its requests, then the answers

This is the moment the setup is for. When the brain item is `done`, it names Onbox's own report in `report`: the conversation where Onbox says what it understood from the history. Find its message with `get_conversations`, which shows comments only as a preview, then read the message in full with `get_comments`, and give it to the person as it is written, in Onbox's words: the opening counts, what it can handle and why, what it noticed, and what it needs from them. It is Onbox's message, not yours: do not summarise it from the brain files instead. `report` is null until the message is written, which can take several minutes after the build: say once that the build is done and the report is on its way, then check about every minute in the background, for up to 20 minutes. Meanwhile, do not summarise the brain and do not say Onbox is set up; the report comes first. (A build on an account with no report, such as one finished before this version, has none: then call `list_brain_files` with `scope: "org"`, read the main files with `read_brain_files`, and summarise in a few lines the skills, the knowledge and the rules.)

What Onbox needs from the person arrives as its requests, one conversation each, assigned to them: call `list_my_inbox` and read each request with `get_conversations`. Before you bring one to the person, try to settle it yourself from what is at hand: the repository, the site or a connected source often holds the rule, the page or the reason Onbox could not find in the mailbox. When you find it, reply on the request with `create_comment`, saying what you found and where, in one or two sentences, so Onbox records it; the request then leaves the inbox. When you do not, bring the request to the person with Onbox's proposal first, and reply with their answer. Never answer a request from memory or with a guess.

Then record what the person decided, each in the file that already states the point, so two instructions never disagree:

- **Tone,** when they changed the default: the guideline for replies with no past ones to follow. Correct the line the build wrote; if none states it, add one line to the org `AGENTS.md`.
- **An answer to the report** (a correction, which source is right, a rule they stated): the file that holds the point, such as the knowledge entry or the skill.

What the person already said is decided: write it with `statedByPerson: true`, without asking "Shall I write this?", then say in one line what you saved and where ("Saved: the import takes a zip, in the import entry."). Ask before you write only what they have not decided, such as a rule you propose from what you read, and write that one without `statedByPerson`, also after their yes: `statedByPerson` covers the whole call, so pass it only when every change in the call is what they said.

The build may have written any of these files. Read each one with `read_brain_files` right before you write it, merge your change into its content, and pass its `version` as `expectedVersion`. A path it lists under `missing` does not exist yet: you create it, with `expectedVersion: null`. That is the normal case on a new account, not an error. A refusal names the file and shows its current lines: read it again, merge, and send the call again. Never replace a file you have not read.

Write the changes in one `write_brain_files` call. If the person corrects a fact, fix the file that holds it. Once the setup has completed (`onboardingCompletedAt` is set, usually as the build finishes), a change to the organisation brain is an Onbox improvement, and the result's `message` says whether it is live or waiting. One the person stated themselves, written with `statedByPerson: true`, is live at once for an admin: say what is saved and live. One you composed from your own reading, written without it, waits: give its `webUrl` in one line, say the change applies once they accept it there, and accept it with `accept_brain_proposals` only when they ask you to. Then check the checklist again with `get_account_status` (step 3h). That ends the setup.

## 9. After setup: one next step

The report and the requests have just shown where Onbox falls short for this company: what it has not learned, what it leaves out of a reply, what it passes to a person. Once the setup is done (step 3h), bring the person the one step that would close the most of that (step 3i). Read [references/next-step.md](references/next-step.md) first and follow it, with what you already read during the setup: the report, the requests, the repository or the site.

Never offer a list of optional features in its place, and never propose sending on its own during setup: everything starts in review.

Everything after setup (the inbox, drafts, approvals, rules, corrections, a website chat, tools) is in the `working-with-onbox` skill: load it when the person says yes to that step or asks for any of it.

## Things to avoid

- Never put secrets, API keys or passwords in the brain or in the conversation.
- Never retry a refused write unchanged: read the error, fix the cause, or ask the person.
- Never tell the person a step is done until `get_account_status` says so. Say Onbox is set up only after you gave them Onbox's report (section 8) and step 3h passed.
- Give times in the person's local time or relative to now, never in UTC.
- Never state why something happened unless a tool result says so: when nothing says why, say you do not know, and look where the skill says (for a build, `list_my_inbox`). Never describe a document, page or price you did not read.
- Never ask the person to run a command or check something a tool can check for you.
- Never state a price, and never offer to start a plan, add credit or turn on automatic refill yourself: give the billing page (section 6).
