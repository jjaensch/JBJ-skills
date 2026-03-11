# .agent.md Template
## 1. YAML Frontmatter

Every `.agent.md` **must** start with YAML frontmatter between `---` markers:

```yaml
---
description: '<What this agent does and WHEN to invoke it. Max 1024 chars.>'
                                    # Required. This is the discovery surface — parent agents
                                    # and the agent picker use this to decide when to delegate.
                                    # Always quote values containing colons.
name: 'Agent Name'                  # Optional. Defaults to the filename (without .agent.md).
tools: [read, search]               # Optional. Tool aliases or MCP servers this agent may use.
                                    # Omit = default tools. [] = no tools (conversational only).
model: 'Claude Sonnet 4'            # Optional. Model override. Supports fallback array.
argument-hint: '<Short guidance for the task input>'   # Optional
agents: [sub-agent-1]              # Optional. Restrict which subagents this agent may call.
                                    # Omit = all agents. [] = no subagents.
user-invocable: true                # Optional (default: true). Set false to hide from agent picker.
disable-model-invocation: false     # Optional (default: false). Set true to prevent auto-delegation.
---
```

## 2. File Location
```
.github/agents/<agent-name>.agent.md       # Workspace scope (team-shared)
<user-profile>/agents/<agent-name>.agent.md # User scope (personal, roams with settings sync)
```

No folder structure required — an agent is a single `.agent.md` file.
Unlike skills, agents do **not** bundle scripts or assets.

## 3. Tool Aliases

Agents restrict what they can do via the `tools` field:

| Alias     | Purpose                          |
|-----------|----------------------------------|
| `read`    | Read file contents               |
| `edit`    | Edit files                       |
| `search`  | Search files or text             |
| `execute` | Run shell commands               |
| `web`     | Fetch URLs and web search        |
| `agent`   | Invoke other agents as subagents |
| `todo`    | Manage task lists                |

MCP servers: use `<server-name>/*` to grant all tools from a server.

### Common Patterns
```yaml
tools: [read, search]             # Read-only research agent
tools: [read, edit, search]       # Can modify files, no terminal
tools: [myserver/*]               # MCP server only
tools: []                         # Conversational / reasoning only
```

## 4. Body Content — What to Include

After the frontmatter, write the agent persona and instructions in Markdown:

### Role & Purpose
One-liner stating who this agent is and what it does.

### Constraints
Explicit list of things the agent must NOT do. This is critical for role isolation.

### Approach / Procedure
Numbered steps or guidelines for how the agent should work.

### Output Format
Describe exactly what the agent should return — it only gets one message back to the caller.

---
