# Onbox for agents

Onbox, the always-on agent that answers your customers on every channel, set up and run from Claude Code, Codex, Claude or ChatGPT.

Onbox is the simplest way for a business to set up an always-on agent that answers its customers on every channel: email, WhatsApp, website chat, Instagram and more. It learns on its own how to handle each kind of request, and hands a person what it should not decide alone. This plugin lets your own agent set Onbox up and run it. It connects your agent to the Onbox MCP server at `https://api.onbox.ing/mcp` and adds one skill, `onbox-setup`, which walks through connecting your channels, seeding the Onbox agent's knowledge from your docs, building its brain, and deciding what is waiting on you.

You need an Onbox account. Sign in when your agent asks you to connect Onbox.

## Install

### Claude Code

```bash
claude plugin install onbox --marketplace Onboxing/onbox-for-agents
```

On an older Claude Code, run `/plugin marketplace add Onboxing/onbox-for-agents`, then `/plugin install onbox@onbox`.

### Codex

```bash
codex plugin marketplace add Onboxing/onbox-for-agents && codex plugin add onbox@onbox
```

`codex plugin add` needs the marketplace name, which is `onbox` here; `codex plugin add onbox --marketplace onbox` is the same.

### Claude app (claude.ai, Desktop)

Add Onbox as a connector with this link, then sign in:

https://claude.ai/customize/connectors?modal=add-custom-connector&connectorName=Onbox&connectorUrl=https%3A%2F%2Fapi.onbox.ing%2Fmcp

To get the skill as well, add this repository as a plugin marketplace at https://claude.ai/customize/plugins and install `onbox`.

### ChatGPT

Install Onbox from the Plugins tab once it is listed, then connect it when asked.

### MCP server only

If you only want the tools, without the skill:

```bash
claude mcp add --transport http onbox https://api.onbox.ing/mcp
codex mcp add onbox --url https://api.onbox.ing/mcp
```

## Get started

Ask your agent:

> Set up Onbox for our customer support: connect our support mailbox, seed the brain from this repo's docs, and tell me what is waiting on me.

Later, ask "what is waiting on me in Onbox?" to review replies and actions held for you.

## What is in this repository

| Path                               | For                                           |
| ---------------------------------- | --------------------------------------------- |
| `.claude-plugin/plugin.json`       | Claude plugin manifest                        |
| `.mcp.json`                        | Claude MCP server entry                       |
| `.claude-plugin/marketplace.json`  | Claude Code marketplace                       |
| `plugin.json`                      | Portable plugin manifest (ChatGPT and Codex)  |
| `mcp.json`                         | Portable MCP server entry with OAuth settings |
| `.agents/plugins/marketplace.json` | Codex marketplace                             |
| `skills/onbox-setup/`              | The setup skill                               |
| `assets/`                          | Icon                                          |

## Support

- Email: support@onbox.ing
- Privacy policy: https://www.onbox.ing/privacy-policy
- Terms of service: https://www.onbox.ing/terms-of-service

## License

MIT, see [LICENSE](LICENSE).
