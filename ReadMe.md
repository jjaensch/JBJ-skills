## About
Dette repository indeholder elementer der konfigurerer Github Copilot. 
Formålet er at hente dette repos som et subrepo til alle fretmidige projekter. 
Resultatet er en konsistent historik for agentisk udvikling og et highly maintanable repos. 

## Add as submodule
git submodule add https://github.com/jjaensch/JBJ-skills.git .github/shared
Copilot discovers skills and agents on names, not paths.
When importing to project with existing .github folder, agents and skills, a symlink script is required. 
The script is run once or every time a new file is added to the submodule. 
This is a result of Jakob wanting to use agents actively within JBJ-SKILLS --> leads to conflict as submodule. 


## Using submodule
No .gitignore needed. 
Changes are tracked on project AND skills submodule, not BOTH in conjunction. 
Submodule changes can be commited, without interrupting with project, and vice versa. 