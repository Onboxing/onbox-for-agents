# Onbox key concepts

Use these words with the person, the same way every time.

## The people around a conversation

- **The Onbox agent**: the organisation's agent, called Onbox unless an admin renamed it. It answers customers.
- **The customer**: the outside person on the conversation, such as the sender of an email or a website visitor. Say "customer", not "sender" or "contact".
- **A teammate**: a member of the organisation.
- **The inbox**: where conversations arrive. A **shared inbox** is the team's (the support inbox); a **private inbox** is one person's mailbox.

## The brain

The brain is everything the Onbox agent knows and follows, kept as files in a versioned repository. There are two scopes:

- **org**: the organisation's brain, shared by everyone. It wins when the two disagree on the same point.
- **user**: one member's own preferences, applied where the org brain is silent.

What it holds:

| Thing                | Where                       | What it is                                                                                      |
| -------------------- | --------------------------- | ----------------------------------------------------------------------------------------------- |
| Context map          | `AGENTS.md`                 | Who the company is, its conventions, its sources. The `# Team` section lists members and roles. |
| Skills               | `skills/<slug>/SKILL.md`    | Procedures the Onbox agent follows, for example how to handle a refund request.                 |
| Memories             | `memory/<type>_<slug>.md`   | Facts and corrections: feedback, a customer's case, a person or company, how a tool is reached. |
| Knowledge entries    | `memory/kb_<slug>.md`       | Sourced answers the company gives customers: features, limits, policies, prices.                |
| Triggers             | `triggers/<slug>.md`        | What starts a run: a new message on an inbox, or a schedule.                                    |
| Tool policy          | `policies/tools.md`         | The tool calls the Onbox agent may make alone, and the ones that wait for a person.             |
| Communication policy | `policies/communication.md` | What a message to a customer must never do.                                                     |

The difference in one line each: a **skill** is how to do something, a **memory** is something that is true or was learned, and a **policy** is a rule about what is allowed.

The brain build reads the inbox history and writes skills and memories. Admins write to the org brain directly; a change from someone else becomes a **brain proposal** that an admin merges or declines.

## Pending actions

A pending action is a call the Onbox agent wanted to make (send a reply, issue a refund, create a ticket) that waits for a person. Each one carries a reason; `reasonInWords` says it in plain words:

| Reason             | Meaning                                                        |
| ------------------ | -------------------------------------------------------------- |
| `ask`              | This tool is set to ask before it runs.                        |
| `auto_forbidden`   | A rule of the organisation forbids this call without a person. |
| `auto_not_covered` | No rule of the organisation covers this call, so it waits.     |
| `auto_unavailable` | The check that judges calls could not decide, so it waits.     |
| none               | The Onbox agent proposed it for approval on its own.           |

A person approves, changes or discards it. A failed one can be approved again to retry.

## Asking, escalating, waiting on you

- **Asking**: the Onbox agent asks a teammate for an answer or an approval and keeps the conversation.
- **Escalating**: the Onbox agent gives the conversation to a person and stops working on it. The person named in the brain comes first, then the inbox's fallback.
- **Assigning**: a conversation has one assignee, the Onbox agent, a person, or nobody. Assigning it to the Onbox agent lets it handle the conversation.
- **Waiting on you**: something needs this person to act: a draft or action to review, a question to answer, a failure to resolve.
- **A comment**: an internal note on a conversation. It never reaches the customer.

Say "escalate" only for giving the conversation to a person. Asking a teammate is "asking", not escalating.
