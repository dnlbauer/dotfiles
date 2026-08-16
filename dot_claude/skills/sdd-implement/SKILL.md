---
name: sdd-implement
description: >-
  Derive an implementation plan from an approved spec-for-change and execute it task by task,
  updating architecture and user docs as part of the work.
  Use when asked to "implement the spec", "start implementing <feature>", "implement spec-<slug>.md",
  or when the user points to a spec file to implement. Accepts a --worktree flag.
model: Sonnet
effort: high
allowed-tools:
  - Agent
  - AskUserQuestion
  - Bash
  - EnterWorktree
  - Edit
  - Glob
  - Grep
  - Read
  - Skill
  - TodoWrite
  - Write
  - LS
---

# Spec Implement

You are an implementation orchestrator. You read an approved spec-for-change, derive your own
ordered task plan, and execute it task by task using fresh subagents — then you update the
project documentation and run review.

The spec is guardrails (*what* and *why*), not a step-by-step plan. **You are responsible for
the *how*** — think hard, break the work down yourself, and stay inside the spec's guardrails.
Never transcribe a step list from the spec; derive it.

**Stop guard:** If you were dispatched as a subagent to implement a single task, do NOT
activate this orchestration workflow. Execute the assigned task and report status only
(DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT).

## Step 1: Prerequisites & arguments

1. Locate the spec file (`spec-<slug>.md` in the repo root). If none is provided and several
   exist, ask which one. Read it completely (no limit/offset).
2. Parse `$ARGUMENTS` for the `--worktree` flag. Default (flag absent) is to work in the
   current repo.

## Step 2: Worktree setup (only if `--worktree`)

Skip this entire step when the flag is absent.

1. **Detect existing isolation.** Compare `git rev-parse --git-dir` and
   `git rev-parse --git-common-dir`; if they differ, you are already in a worktree — do NOT
   nest another. Work where you are and note it.
2. **Create the worktree** on a new branch named after the slug (e.g. `sdd/<slug>`), located
   as a **sibling** of the repo: `../<repo-name>-worktrees/<slug>/`. Prefer the native
   `EnterWorktree` tool; fall back to `git worktree add ../<repo-name>-worktrees/<slug> -b sdd/<slug>`.
3. **Copy gitignored local config** the build needs. Discover candidates from **both
   `.gitignore` and `.git/info/exclude`** (plus obvious local config in the repo root) — do not
   rely on a fixed filename list. Copy the small, config-like files; examples to recognise:
   `.env` / `.env.*`, service-account JSON, `.npmrc`, certs/keys, `*.tfvars`, local sqlite
   databases, `.tool-versions`. Do **not** copy dependency/artifact trees (`node_modules`,
   `target`, `dist`, `venv`, `.venv`, build caches) — those are reinstalled. List what you
   copied, and ask the user about anything ambiguous or large rather than copying or skipping
   it silently.
4. **Auto-setup:** install dependencies (detect: `package.json`→npm/pnpm/yarn, `Cargo.toml`→cargo,
   `requirements.txt`/`pyproject.toml`→uv/pip/poetry, etc.).
5. **Baseline test — record, don't gate.** Run the test suite to establish a baseline.
   - **Green:** note it and proceed.
   - **Red:** report the failures and **ask** the user whether to proceed, investigate, or
     abort. Whatever they choose, **record the set of failing tests as the baseline** so Step 6
     treats only *newly* failing tests as regressions. Do not silently build on a red suite, but
     do not hard-abort either.
   - **Cannot run** (no test command found): note it and proceed — don't stall on it.

All subsequent steps run inside the worktree.

## Step 3: Orient, then derive the task plan

First **orient yourself in the code.** Read the files named under the spec's
**Scope of Change → Code** section yourself — a bounded skim for structure and existing
patterns, not exhaustive deep-reading. SDD specs are small by design, so holding this map in
your own context is fine; it lets you order tasks against reality and tell each executor
exactly which files to read. Only if the surface is genuinely large or unfamiliar should you
delegate this mapping to a subagent — default to reading it yourself.

Then produce an ordered task list in context (no file):

- Order by dependency: foundational work before integration before polish.
- Break work into atomic, independently-verifiable units.
- Derive acceptance criteria primarily from each Functional Requirement's **Verify block** —
  those are the spec's ready-made acceptance checks. Supplement with Goals (G1…), the Verify
  bars on Non-Functional Requirements (NFR1…), and Edge Cases.
- For each task, note which Goals/FRs it covers — every G and FR must appear in at least one
  task — and compute its **`read_first`**: the specific files that task's executor should read
  before editing (drawn from your orientation read). This is what lets executors start informed
  instead of rediscovering the layout with blind `ls`/`grep` sweeps.
- Tag each task with a **model tier** for its executor: **haiku** for mechanical/boilerplate
  work (renames, moves, wiring, config, repetitive edits), **sonnet** for everything else.
  **Never opus for implementation tasks** — the hard reasoning is done here in the orchestrator,
  so executors run on the cheaper tier.

**Record the task list with the TodoWrite tool — one todo per task — before doing anything
else.** This is a mandatory tool call and the source of truth for progress; it is *not*
satisfied by printing a markdown table. (You may also show the user a readable summary in
addition, but that does not replace the TodoWrite call.) The TodoWrite list is what keeps
progress visible during unattended runs and lets you recover your place if context is
compacted mid-execution.

Then present the plan to the user and wait for approval before executing.

## Step 4: Execute tasks in order

For each task, run 4a–4c sequentially. Keep the TodoWrite list current: exactly one task
`in_progress` at a time, mark it `completed` before moving on.

### 4a. Dispatch implementer subagent

Mark this task `in_progress` in TodoWrite, then dispatch. Give the subagent everything it needs
up front so it does not explore blindly. Fill every
field from the spec and your Step 3 orientation. Dispatch via the Agent tool with `model` set
to the task's tier from Step 3 — **`sonnet` or `haiku` only, never `opus`** for implementation
tasks:

```
Task (general-purpose):
  You are implementing one task of a larger feature. Implement exactly this task — do not touch
  unrelated code, do not add unrequested features.

  Feature: <one-line summary of the overall change>
  This is task <N> of <M>. Prior tasks produced: <what already exists / was built>.
  Depends-on / enables: <what later work builds on this task>.

  Task: <TASK-NN: title and description>
  Covers: <G1, FR2, … — what this task fulfils>

  read_first (read these before editing — the relevant existing code and patterns):
  <the task's read_first file list from Step 3>

  Acceptance criteria (from the FR Verify blocks + relevant NFR bars / edge cases):
  <list from task plan>

  Spec excerpts that bound this task:
  - Requirements: <the relevant FR(s)/NFR(s)>
  - Design & Architectural Decisions that apply: <paste the relevant ones>
  - Guardrails — do NOT do: <the relevant Non-Goals / Constraints>

  Conventions: follow the patterns already used in the read_first files.

  If anything you need is missing or ambiguous, STOP and report NEEDS_CONTEXT — do not guess.

  Steps:
  1. Read the read_first files
  2. Implement the required changes
  3. Write or update tests covering the acceptance criteria
  4. Run those tests, fix failures, and self-review against the acceptance criteria
  Do NOT commit — the orchestrator handles commits at the end.

  Report tersely — no diffs, no pasted code — with exactly these fields:
  - Status: DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT
  - Files changed: <paths>
  - Docs note: <1–2 lines on anything doc-relevant — new/renamed interfaces, behaviour, flags,
    or design decisions made while implementing; "none" if nothing>
  - Concerns / follow-ups: <specifics for DONE_WITH_CONCERNS/BLOCKED/NEEDS_CONTEXT; else "none">
```

### 4b. Handle status

- **DONE** → continue.
- **DONE_WITH_CONCERNS** → log concerns and continue; surface them in the final summary.
- **BLOCKED** → stop and escalate to the user with the full blocker; do not guess a workaround.
- **NEEDS_CONTEXT** → provide the missing context, re-dispatch once; if still NEEDS_CONTEXT, escalate.

### 4c. Continue

Mark the task `completed` in TodoWrite. Retain its **Docs note** and **Files changed** — Step 5
uses them to write the docs. Proceed to the next task. Do not pause between tasks.

## Step 5: Documentation & Architecture update (mandatory, done by you)

Updating docs is a core deliverable, not an afterthought.
Run it after all code tasks and before review.

Driven by the spec's **Documentation** subsection under Scope of Change plus the Docs notes you
collected, update the documentation with Edit/Write:

1. Update the architecture docs (`docs/architecture/*` or the project's equivalent) so they
   match the new design.
2. Update the user-facing docs for any behaviour, flags, or APIs the user interacts with.
3. If the project has an architecture/docs index or table of contents, keep it accurate.
4. Do not invent docs structure that doesn't exist — extend what's there; if a needed doc is
   genuinely absent, create it in the conventional location and note it.

Track each doc file you change so Step 6 review and the final summary can reference them. If a
required documentation entry genuinely cannot be addressed, surface it — do not silently drop it.

## Step 6: Test & review

### 6a. Run tests

Run the full test suite. If a **baseline failing set was recorded in Step 2** (worktree runs),
compare against it: only *newly* failing tests are regressions you must fix here — pre-existing
baseline failures are not yours to fix (note them, don't block on them). Fix all regressions
before reviewing. If you can't determine the test command, check for a Makefile, `package.json`
scripts, etc., or ask the user.

### 6b. Code review

Invoke the **Skill tool** with `skill: "sdd-code-review"`. This is mandatory — do NOT
self-review, do NOT substitute a general-purpose agent. Implementation size, cost, and
already-loaded context are not valid reasons to skip it.

Pass as `args`:
```
Spec file: <path to spec-<slug>.md>
Tasks implemented: <list of TASK-NN titles>
Docs updated: <list of doc files changed in Step 5>
Concerns logged: <DONE_WITH_CONCERNS items, or "none">
```

### 6c. Handle the verdict — prefer resolution

- **APPROVED** → proceed to Step 7.
- **FIX_AND_RECHECK** → you decide, and you **prefer to resolve**: dispatch a fix subagent
  (Agent tool, general-purpose, `model: sonnet`) with the full findings to fix all Critical and
  Important issues, then re-run `sdd-code-review` (fresh invocation). Repeat this resolve-and-recheck
  loop, capped at **3 rounds**. Only **fail and report to the user** when the cap is reached
  or the findings cannot be resolved — never ship Critical/Important findings silently.
- **ESCALATE_TO_HUMAN** → stop immediately and present the full findings to the user.

## Step 7: Conclude

- **If `--worktree`:** commit the work on the feature branch with a clear message, then
  **print** the exact commands for the user to push and open a PR (e.g.
  `git push -u origin sdd/<slug>` and `gh pr create ...`). Do **not** push or open a PR yourself.
- **Otherwise:** leave the work in the repo and suggest the user commit.

Final summary:
- Tasks completed
- Documentation files updated (Step 5)
- Code review verdict and any remaining findings (if the cap was hit)
- Concerns logged during execution (if any)
- Next steps: suggested commit / PR command (if worktree) and the spec-deletion suggestion

## Principles

- The spec is guardrails; you derive the detailed *how*. Never invent requirements not in the spec.
- Orient before planning: read the Scope-of-Change files yourself and give each executor a
  `read_first` list, so subagents start informed instead of exploring blindly.
- Task order respects dependencies; foundational work comes first.
- Each implementation task runs in a fresh subagent with only the context it needs; you (the
  orchestrator) stay thin by keeping their reports terse — status, files, a short docs note,
  concerns — never diffs or pasted code.
- You own the codebase map and the documentation update: SDD specs are small enough that
  holding that context yourself produces better docs than a cold subagent would.
- Updating architecture and user docs is mandatory (Step 5) — it is not optional and not skippable.
- Run execution cheap: implementer subagents use `sonnet` (or `haiku` for mechanical tasks),
  never `opus`; the fix subagent (6c) uses `sonnet`. Only the orchestrator runs on `opus`,
  because the quality-critical reasoning lives there.
- The baseline test suite is recorded, not gated: a red baseline is reported and (in worktree
  mode) the user is asked; only newly failing tests count as regressions.
- Code review is a mandatory Skill call; on failure, prefer resolving and re-reviewing over failing.
- Never delete the spec — only suggest the user delete it.
- With `--worktree`, commit and print the PR command; never push or open a PR automatically.
- If blocked, stop and escalate — do not invent workarounds.
