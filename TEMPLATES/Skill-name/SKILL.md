# SKILL .md Template
> Replace all `<placeholders>` and example content with your own. Delete this instruction block when done.

---

## 1. YAML Frontmatter

Every SKILL.md **must** start with YAML frontmatter between `---` markers:

```yaml
---
name: <skill-name>                  # Required. 1-64 chars, lowercase, alphanumeric + hyphens.
                                    # MUST match the containing folder name exactly!
description: '<What it does and WHEN to use it. Max 1024 chars.>'
                                    # This is the discovery surface — if trigger words
                                    # aren't here, the agent won't find or load the skill.
                                    # Always quote values containing colons.
argument-hint: '<Short hint shown when invoked via slash command>'   # Optional
user-invocable: true                # Optional (default: true). Set false to hide from `/` menu.
disable-model-invocation: false     # Optional (default: false). Set true to prevent auto-loading.
---
```

## 2. Folder Structure
---
```
.github/skills/<skill-name>/
├── SKILL.md            # Required — entry point (name + description + instructions)
├── scripts/            # Executable code the skill references
├── references/         # Supplementary docs loaded on demand
└── assets/             # Templates, boilerplate, config files
```
---

## 3. Body Content — What to Include

After the frontmatter, write the skill body in Markdown. Structure it as follows:

### Title & Purpose
One-liner on what the skill accomplishes.

### When to Use
Bullet list of specific triggers / scenarios. Helps both humans and the agent decide relevance.

### Procedure
Numbered step-by-step instructions the agent follows. Reference bundled resources with relative paths:
```markdown
1. Run [setup script](./scripts/setup.sh)
2. Apply [config template](./assets/config.template.json)
3. Validate output against [checklist](./references/checklist.md)
```

### Notes / Constraints *(optional)*
Guard-rails, edge cases, or things to avoid.

---

