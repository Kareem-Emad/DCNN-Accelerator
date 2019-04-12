# DCNN-Accelerator
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)


Low level design of a chip built for optimizing/accelerating CNN classifiers over gray scale images. 

# Coding Guidelines

Writing synthesizable code is difficult. The following guidelines are intended to make life easier. Sources for guidelines are: [1](https://www.alse-fr.com/sites/alse-fr.com/IMG/pdf/vhdl_coding_v4_eng.pdf) [2](https://www.youtube.com/watch?v=XfUOa2wudTs&feature=youtu.be) [3](http://www.tkt.cs.tut.fi/kurssit/50200/S17/Harjoitukset/dcs_vhdl_coding_rules_es_v4_4.pdf)

# Files
- Have only **one design unit entity per file** and make a test bench for every such entity. Files should be named as design_entity.vhd and testbenches should be named as design_entity_tb.vhd.
- A module (entity) should not contain several different and independent functionalities except for structural entities (instantiating of sub-modules). For example: if you need a bidirectional register in some other entity, make it a separate entity. Don't hack a register into a bi-directional register in your entity. This makes testing difficult. 

# Readability and Documentation
- Always add comments explaining entity ports.
- Avoid defining multiple ports in the same line. The rule is generally **one** port per line.
- Every process or other concurrent statement should be preceded by a clear comment summarizing its purpose.
- Learn about constants and use them if needed.

# Coding for Synthesis
- Use exclusively std_logic / std_logic_vector types in ports. 
- Use sequential Logic with **asynchronous reset**. Do **not** use the reset signal elsewhere. 
- If a signal is assigned in a process block, it **must** be reset when the reset signal is set to 1. This prevents errors and leftovers from pre-resetting.
- Do not use wait except in Testbenches (it is **not** synthesizable).
- Avoid using "INOUT" mode. It leads to problems regarding finding a driver for the signal.
- There are no initial values outside of Testbenches because the components cannot drive themselves. Avoid the use of initial values on signals.
-  Use as few variables as possible in synthesizable code, and never when you may use signals instead because they are difficult to synthesize.
- Try not to create latches! For example, when assigning a signal using cases make sure that **all** cases are covered (i.e. don't leave an if without an else when using it for assignment) because otherwise synthesizes a latch. See [2] at 1:14:40 for a more thorough explanation (it's in Verilog but the same idea applies). 
- Try to separate out sequential and combinational code in Finite State Machines. Use the three-process model (one for combinationally calculating the next state, one for combinational decoding, one for setting the next state on clock edges).
- Avoid the use of three-state signals when possible! (In fact, [2] and [3] recommend totally avoiding them. They are more difficult to debug in synthesis and in the real world)

# Cosmetic Conventions
- Names of entities and architectures should be written in PascalCase.
- Signals and variables should be written in snake_case.
- VHDL keywords should be written in lower case.
- Use meaningful and conventional names for architecture kinds like: "rtl", "behavioral", "structural", "tb", in the appropriate context. Try to minimize the use of mixed architectures.
- Use signal_name_n for active low signals.
- Instantiations must use named Port Maps (vs Ordered port maps).
- Write signal_in for input signals and signal_out for output signals.


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
