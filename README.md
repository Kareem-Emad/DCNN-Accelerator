# DCNN-Accelerator
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)


Low level design of a chip built for optimizing/accelerating CNN classifiers over gray scale images. 

# Basic Rules for collabration 
We are about 12 people working on this repository, so we could easily make the whole thing a mess. I wrote some basic "known" guidlines here to help us with the organization of code commiting/pushing/releasing:

- THE MASTER BRANCH IS NOT FOR DEVELOPMENT WORK, YOU CANNOT SIMPLY COMMIT AND PUSH ON THE MASTER BRANCH. All development work should go under the "dev" branch, the master branch is only for releasing milestones in code, if the code in the dev branch reaches a stable state where x features are working, then you can go ahead and merge the dev branch to the master branch: 
``` 
git checkout master
git merge dev
git push origin master:master
```
after that, you switch back to the dev branch and continue working on 'under test/development' features.

- First time to clone the repository? The first thing to do is to switch to the dev branch:

```
git clone https://github.com/Kareem-Emad/DCNN-Accelerator.git
git checkout dev
```
then you are all set to start working on the project.

- If you are working on something and others do push to the repository, don't panic. You will usually be working on something separte (on other files). So simply pull their changes and continue working, then commit and push your work.

- If you don't know how to handle conflicts -if it happens that some else is working on the same file- just open vs code when pulling the repository and look for 'blue-flagged' files, you will find 'blue flagged' code in them, that's the code causing conflicts, choose between 'incoming changes/someone else's code' and 'current changes/your code', or just delete both of them and wirte a piece of code that incorporates your code and his/her code. when all 'blue stuff' is gone, commit your code and push.

- Please be specific when you do push your code about which branch your code is going into. you could easily by mistake work on the wrong branch and make a whole mess on your device, so doing:
```
git push origin branch
```
could bring this mess to everyone.so make sure you are specific, if you are working on dev branch as usual:
```
git push origin dev:dev
```
if you releasing a merge on master:
```
git push origin master:master
```

Never do this 
```
git push origin dev:master
```
or this 
```
git push origin master:dev
```

# Coding Conventions (subject to change)
- Names of entities and architectures should be written in PascalCase.
- Signals and variables should be written in snake_case.
- VHDL keywords should be written in lower case.
- Always add comments explaining entity ports.
