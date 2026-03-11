```yaml
---
name: geopandas-1.1.0
description: In depth skill knowledge on using Geopandas, often refered to as gpd, version 1.1.0. 
argument-hint: Infuse Geopandas 1.1.0 docs.
user-invocable: true
disable-model-invocation: false
---
```

```markdown
.github/skills/Geodata/geopandas-1.1.0/
├── SKILL.md            # Required — entry point (name + description + instructions)
└── references/         # Supplementary docs loaded on demand
```
---
# Skill contents for "Geopandas 1.1.0"

## Purpose
In depth skill knowledge on using Geopandas, often refered to as gpd, version 1.1.0. 

### When to Use
- When referencing "geopandas", "gpd", "geoseries" or "geodataframe" in prompt queries. 
- When working with geospatial data.
- When you need to perform geospatial operations.

### Procedure
Numbered step-by-step instructions the agent follows. Reference bundled resources with relative paths:
```markdown
1. Run [setup script](./scripts/setup.sh)
2. Apply [config template](./assets/config.template.json)
3. Validate output against [checklist](./references/checklist.md)
```

### Notes / Constraints 
- Always check for the latest version of Geopandas, as there may be updates or bug fixes.
- Always inform the user if their version og geopandas is not 1.1.0, as some functionalities may differ from thge stored references in this skill.
- Warn the user of when mixing Arcpy and Geopandas functionalities, as they can cause conflicts.
- Always provide the user in chat responses, what other geodata related packages are activated in the current project and are proposed to be used for a given chat response, if any.

