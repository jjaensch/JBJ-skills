# About
Dette repository indeholder elementer der konfigurerer Github Copilot. 
Formålet er at hente dette repos som et subrepo til alle fretmidige projekter. 
Resultatet er en konsistent historik for agentisk udvikling og et highly maintanable repos. 

# Add as submodule
git submodule add https://github.com/jjaensch/JBJ-skills.git .github/skills/shared

## Using submodule
No .gitignore needed. 
Changes are tracked on project AND skills submodule, not BOTH in conjunction. 
Submodule changes can be commited, without interrupting with project, and vice versa. 