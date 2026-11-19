# The next step: start from what Onbox was missing

Onbox answers a conversation when it holds what the answer needs, or can reach the place that holds it. So the next step for this company comes from where Onbox fell short, never from what it could do. Read that first:

- its report on the first build (`get_account_status` names the conversation, `get_comments` reads it): what it has not learned, what it leaves out of a reply, what it passes to a person;
- its requests and escalations in `list_my_inbox`, each with the comment where Onbox says why;
- the lines its knowledge marks as not known (`list_brain_files`, `read_brain_files`).

Then ask yourself four questions, and bring the person one step.

## 1. What was missing each time?

One of three things:

- **How the product or service works.** It changes slowly and is written somewhere: for software, the repository, the docs, the changelog; for a shop, the catalogue and the returns policy; for a service, the offers, the price list, the contract terms. Onbox takes it as knowledge written into its brain, or from a source it is connected to.
- **Where this customer's case stands.** It changes every day: an order, a subscription, an account, a booking, an open ticket. Onbox takes it only from a connected tool, reading at first: `update_integration` sets what it may change. Never write it into the brain.
- **A decision or an exception.** It is in someone's head, a chat or a habit. Onbox takes it from the person's answer, recorded in its brain where the point belongs.

## 2. Where does whoever answers today look for it, and do you already have that place?

The repository you are in, your memory, a tool you are connected to, a page you can read.

- You have it: propose giving it to Onbox, and name what it unlocks. "Onbox left the notice period out of 9 of your last 40 replies, and your terms page states it. Shall I add it to what Onbox knows?"
- You do not: ask the person one question, your best guess first.

## 3. What does the person do elsewhere after answering?

Propose an action only for a step someone already takes today, never one you guess from the kind of business, not even as an example.

- **Find its trace:** replies that say what was done ("I've extended your trial", "I've passed this to the workshop"; `search_messages`), escalations where Onbox says what it could not do, what the person told you.
- **Check the place:** call `list_integrations` before you say Onbox can or cannot do the step, even when you think you know. It lists the tools Onbox connects; the company's own system needs an MCP server, an OpenAPI document or a PostgreSQL database; a step inside Onbox, such as a tag or giving the conversation to a named person, needs no tool.
- **Propose it** with the evidence, what Onbox would do and what still waits for the person: "In 7 of your last 50 replies you said you had extended the trial. Onbox can extend it through your admin API and tell the customer, asking you before each one. Want that?"
- **No trace:** no proposal, and no examples of what Onbox could do. At most one open question, with nothing after it, which names no tool and no step the person might take: "After a cancellation, do you do anything outside the reply?"
- **A place Onbox cannot reach:** say so in a sentence and promise nothing.

## 4. Does Onbox start on what the person wants handled, and only that?

`list_inboxes` says which new conversations Onbox takes on each inbox (all, those a trigger gives it, none) and whether its replies wait for review. The `triggers/` files of the organisation's brain say which kinds a trigger gives it. The `agent_triggers` item of `get_account_status` names an inbox where it takes none.

Compare with what the person said they want handled. A kind Onbox never gets, or one it works on that they keep for themselves, is fixed with one trigger. Sending on its own stays the person's call: never propose it here.

## One step

Bring one proposal, or one question: the one that touches the most conversations, an inbox where Onbox takes nothing first. Say it in two or three sentences, with the evidence, and end your turn.

- Never list what Onbox can do or the tools it can connect. A numbered list of things Onbox could do is a list, even when it ends on one question.
- Never propose from the kind of business alone.
- Never several steps at once.

On yes, do it, as the `working-with-onbox` skill says for knowledge, tools and triggers, and say what changed. Bring the next step when they ask.
