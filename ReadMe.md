# JBJ Skills

## About
This repository contains elements that configure GitHub Copilot. The purpose is to fetch this repo as a submodule in all future projects. The result is consistent history for agentic development and a highly maintainable repository.

## Add as Submodule
```bash
git submodule add https://github.com/jjaensch/JBJ-skills.git .github/shared
```
Copilot discovers skills and agents by names, not paths. When importing to a project with an existing .github folder, agents, and skills are recognized. 

### Using Submodule
Should work out of the gate, no problems! All contents of submodule should be recognized when stored in your projects .github dir. 

## Forking?
If you forked the project and want to test your agents and skills within this project alone, use "setup.ps1" and add "/.github" to .gitignore. 
This achiecies a fucntioning -github dir within this project when testing, yet ommits it from submodule imports efficiently avoiding conflicts. 