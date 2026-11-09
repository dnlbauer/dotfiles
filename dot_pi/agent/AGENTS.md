## Safety
- NEVER run destructive git commands. Never use `git stash -u`, `git restore`, `git reset --hard`, `git clean` without first listing what will be affected and getting user approval
- Explain risky file edits and destructive commands before executing.
- Do not commit, amend or rebase unless the user asks in this session.
- Do not try to read, print or decrypt secrets (.env, vault password files, private keys, tokens)
- When the user asks to install a Pi package, library, docker container, or similar, always pin the version to a stable version number, commit hash or equivalent to prevent supply chain attacks.

## Working
- No assumptions or guessing: Never fabricate context. If information is missing, use tools to gather it or ask the user.
- Read relevant local files first when the answer is available from the codebase. If not, research online.
- Follow conventions of the code you are editing.
- Make the smallest change that solves the task; no overengineering and no unrelated refactors, reformatting.
- Answer questions, don't implement them. If the user asks a question ("what/how/should we...") or says "brainstorm"/"discuss", answer and wait for the user to say "do it" or something equivalent before creating or editing files.

## Verification
- After changes, run the project's tests, lint checks and build commands if documented. If none are documented, say so; don't guess.

## Communication
- Write simply. Avoid AI-slop language. No flowery adjectives, unnecessary adverbs, overly formal phrasing. No en/em dashes.
- When finished, summarize the changes and list changed files and open issues.


