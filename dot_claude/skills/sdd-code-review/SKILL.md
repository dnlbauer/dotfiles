---
name: sdd-code-review
description: >-
  Review implemented code against the spec-for-change and acceptance criteria using parallel specialist subagents.
  Use when asked to "review the implementation", "check the code against the spec",
  "did the implementation match the spec", or "review the changes".
  Also invoked internally by sdd-implement at run completion.
context: fork
model: opus
effort: high
allowed-tools:
  - Agent
  - AskUserQuestion
  - Bash(git diff:*)
  - Bash(git log:*)
  - Bash(git status:*)
  - Bash(git show:*)
  - Glob
  - Grep
  - Read
  - LS
---

# Spec Code Review

You are a review orchestrator. You fan out specialized reviewer subagents in parallel and
aggregate their findings into a single verdict.

**Subagent stop guard:** If you were dispatched to perform a single review task, produce
your findings and return. Do NOT invoke further subagents.

## Step 1: Gather review context

**Read the spec first.** The spec defines what the implementation must deliver — it is
the primary input for every reviewer.

1. Read the spec file completely (Goals, Functional + Non-Functional Requirements and their
   Verify blocks, Design & Architectural Decisions, Edge Cases, Scope of Change, Risks & Constraints).
2. From the Design & Architectural Decisions and Scope of Change (Code) sections, identify the
   source files and areas the implementation should touch. Use Read, Glob, and Grep to read the
   current state of those files directly — the goal is to review what exists now, not only what changed.
3. From the **Documentation** subsection under Scope of Change, locate the architecture docs
   (`docs/architecture/*`) and user docs that should have been updated, and read their current
   state — the Documentation reviewer needs them.
4. Run `git status` to see which files were modified. Pass this as supplementary context.

If called by `sdd-implement`: the spec path, tasks implemented, and the list of docs updated
are passed in — use them. If called standalone: ask the user for the spec path. If no spec
exists, ask for the acceptance criteria and the files to review.

Assemble for each reviewer:
- The spec content (or acceptance criteria if no spec)
- The relevant source file contents you read
- The current contents of the docs named under Scope of Change → Documentation
- The `git status` output

## Step 2: Fan out reviewer subagents in parallel

Dispatch all applicable reviewers **at once**. Do not wait for one before dispatching
the next. Wait for all to complete before aggregating.

### Agent 1 — Developer Review

```
Task (general-purpose):
  You are a senior software engineer reviewing code for quality, correctness, and spec compliance.
  Do NOT modify any code. Do NOT invoke subagents.

  Task: <title>
  Description: <what was implemented>
  Acceptance criteria:
  <list>
  Interface contracts:
  <if applicable>

  Spec / acceptance criteria:
  <spec content or acceptance criteria>

  Current implementation (relevant source files):
  <contents of key files>

  Modified files (git status):
  <status output>

  Review for:
  - Correctness: Does the implementation satisfy every acceptance criterion?
  - Spec compliance: Is every Goal (G), Functional Requirement (FR), and interface decision in
    the spec satisfied? Flag any G/FR/interface that is unimplemented or only partially met.
  - Scope creep: Does it touch code outside the task's scope, or add features the spec did not ask for?
  - Code quality: Is code clean, readable, and maintainable? Are names descriptive? Is there unneeded complexity?
  - Standards: Does it follow coding conventions existing in the project?
  - Performance: Are there efficiency concerns introduced by this change?
  - Scalability: Flag only if this task introduces a pattern that will actively hurt scalability at production load.
  - Refactoring opportunities: Flag only if this task introduces duplication or a misplaced abstraction that will compound over time.

  Produce a structured report. If a category has no findings, say so explicitly.

  Output:
  ## Critical
  <Issues that will cause failures or spec violations. Must be fixed.>
  ## Important
  <Issues that should be fixed before merging.>
  ## Minor
  <Small nits, style issues, optional improvements.>
  ## Verdict
  APPROVED | FIX_AND_RECHECK | ESCALATE_TO_HUMAN
```

### Agent 2 — Quality Engineer Review

```
Task (general-purpose):
  You are a QA engineer reviewing code for test coverage and correctness.
  Do NOT modify any code. Do NOT invoke subagents.

  Task: <title>
  Acceptance criteria:
  <list>

  Spec / acceptance criteria:
  <spec content or acceptance criteria>

  Current implementation (relevant source files):
  <contents of key files>

  Modified files (git status):
  <status output>

  Review for:
  - Verify-block coverage: For each Functional Requirement, is its **Verify** block actually
    satisfied — is there a test or observable check matching it? Flag any FR whose Verify is unmet or untested.
  - Non-functional requirements: For each NFR with a Verify bar (performance, limits,
    reliability, etc.), is there evidence or a test that it is met? Flag untested NFRs.
  - Test coverage: Are new/changed code paths covered? Identify uncovered branches, conditions, or functions.
  - Edge cases: Are boundary conditions handled? Null/empty inputs, off-by-one, overflow, unicode, concurrency?
  - Error handling: Are errors caught, propagated, and logged? Any bare catches or swallowed exceptions?
  - Regression risk: Could this break existing functionality? Which existing tests are most affected?
  - Missing test scenarios: List specific test cases that should be added (input → expected output where possible).

  Produce a structured report. If a category has no findings, say so explicitly.

  Output:
  ## Critical
  ## Important
  ## Minor
  ## Verdict
  APPROVED | FIX_AND_RECHECK | ESCALATE_TO_HUMAN
```

### Agent 3 — Security Engineer Review

```
Task (general-purpose):
  You are a security engineer reviewing code for vulnerabilities and data safety.
  Do NOT modify any code. Do NOT invoke subagents.

  If this change has no security surface (pure UI layout, config-only, documentation),
  state that explicitly and output Verdict: APPROVED with no findings.

  Task: <title>
  Description: <what was implemented>

  Spec / acceptance criteria:
  <spec content or acceptance criteria>

  Current implementation (relevant source files):
  <contents of key files>

  Modified files (git status):
  <status output>

  Review for:
  - Vulnerabilities: Injection (SQL, command, template), XSS, CSRF, SSRF, path traversal, deserialization, insecure randomness, timing attacks.
  - Data handling: Is sensitive data (PII, credentials, tokens) properly protected? Logged, cached, or serialized where it shouldn't be?
  - Auth & authorization: Are auth checks present and correct? Any endpoints or operations that bypass access control?
  - Input validation: Is all external input validated and sanitized? HTTP params, file uploads, env vars, config values.
  - Dependencies: Are new dependencies introduced? Known CVEs? Pinned to specific versions?
  - Secrets: Are there hardcoded secrets, API keys, or credentials in the diff?

  Produce a structured report. Flag HIGH severity findings at the top with a clear label. If a category has no findings, say so explicitly.

  Output:
  ## Critical
  ## Important
  ## Minor
  ## Verdict
  APPROVED | FIX_AND_RECHECK | ESCALATE_TO_HUMAN
```

### Agent 4 — DevOps Review

```
Task (general-purpose):
  You are a DevOps/platform engineer reviewing code for operational readiness.
  Do NOT modify any code. Do NOT invoke subagents.

  Task: <title>
  Description: <what was implemented>

  Spec / acceptance criteria:
  <spec content or acceptance criteria>

  Current implementation (relevant source files):
  <contents of key files>

  Modified files (git status):
  <status output>

  Review for:
  - CI/CD impact: Will existing pipelines succeed? New build steps, dependencies, or env vars required?
  - Configuration: Hardcoded values that should be env vars? Missing defaults? Config drift between environments?
  - Infrastructure: New infrastructure requirements (databases, queues, storage)? Migration scripts with rollback support?
  - Observability: Are metrics, logs, and traces adequate for debugging production issues? Structured log fields used?
  - Rollback safety: Can this be safely reverted? Irreversible side effects (data migrations, schema changes, external API calls)?
  - Resource usage: Memory, CPU, disk, or network implications? Connection pool sizing? Timeout configurations?

  Produce a structured report. If a category has no findings, say so explicitly.

  Output:
  ## Critical
  ## Important
  ## Minor
  ## Verdict
  APPROVED | FIX_AND_RECHECK | ESCALATE_TO_HUMAN
```

### Agent 5 — UI/UX Designer Review

Dispatch only if the change touches UI code (templates, components, stylesheets, frontend
assets, accessibility attributes). Otherwise skip and note:
"UI/UX review skipped — no user-facing changes detected."

```
Task (general-purpose):
  You are a UI/UX designer reviewing code for user experience quality.
  Do NOT modify any code. Do NOT invoke subagents.

  Task: <title>
  Description: <what was implemented>

  Spec / acceptance criteria:
  <spec content or acceptance criteria>

  Current implementation (relevant source files):
  <contents of key files>

  Modified files (git status):
  <status output>

  Review for:
  - Visual consistency: Does the change follow the project's design system? Spacing, colors, and typography consistent?
  - Usability: Is the interaction intuitive? Confusing states, missing feedback, or unclear labels?
  - Accessibility: Proper ARIA attributes? Keyboard navigability? Sufficient color contrast? Screen reader compatibility?
  - Responsive design: Works across viewport sizes? Breakpoints handled? Touch targets sized for mobile?
  - Loading & error states: Loading indicators present? Error states clear and actionable? Graceful degradation?

  Produce a structured report. If a category has no findings, say so explicitly.

  Output:
  ## Critical
  ## Important
  ## Minor
  ## Verdict
  APPROVED | FIX_AND_RECHECK | ESCALATE_TO_HUMAN
```

### Agent 6 — Documentation & Architecture Review

A peer reviewer with the **same standing as the others — no special veto**. Its findings flow
through the normal aggregation. Always dispatch it (every spec has a Documentation entry under
Scope of Change to check against).

```
Task (general-purpose):
  You are a documentation reviewer checking that the architecture and user docs were updated
  to match the implemented change. Do NOT modify any code or docs. Do NOT invoke subagents.

  Documentation entries the spec requires (the Documentation subsection under "Scope of Change"):
  <paste those entries>

  Docs reported as updated (from sdd-implement, if provided):
  <list, or "not provided">

  Current contents of the relevant docs:
  <contents of the architecture/user docs named under Scope of Change → Documentation>

  What was implemented:
  <summary of tasks + modified files / git status>

  Review for:
  - Architecture docs: Do docs/architecture/* reflect the new design — data ownership, interfaces,
    patterns, and any new/changed components? Flag anything now stale or contradicted by the code.
  - User docs: Are user-facing behaviours, flags, APIs, or workflows that changed documented accurately?
  - Coverage: Was every documentation entry the spec required (under Scope of Change) addressed?
  - Drift: Are there docs that the change made incorrect but that were left untouched?
  - Accuracy: Do the updated docs actually match the code, or do they describe intended-but-absent behaviour?

  Report stale, missing, or inaccurate docs as ordinary findings at the appropriate severity.
  Produce a structured report. If a category has no findings, say so explicitly.

  Output:
  ## Critical
  ## Important
  ## Minor
  ## Verdict
  APPROVED | FIX_AND_RECHECK | ESCALATE_TO_HUMAN
```

## Step 3: Aggregate results

Once all subagents return:

1. **Overall verdict** = the worst individual verdict
   (ESCALATE_TO_HUMAN > FIX_AND_RECHECK > APPROVED)
2. **Deduplicate** overlapping findings across reviewers
3. **Group by severity**: Critical → Important → Minor

## Step 4: Return results

**Called by `sdd-implement`:**
- Pass the aggregated verdict and grouped findings back into orchestration context.
- Only surface output to the user if verdict is FIX_AND_RECHECK or ESCALATE_TO_HUMAN.
- If APPROVED, stay silent and let sdd-implement continue.

**Standalone:**
- Present the full review: overall verdict, per-reviewer findings grouped by severity.
- Suggest next steps based on verdict:
  - APPROVED → safe to merge / continue
  - FIX_AND_RECHECK → address Critical and Important items, then re-run review
  - ESCALATE_TO_HUMAN → specific issues requiring human judgment are listed above

## Principles

- All reviewer subagents run in parallel — never sequentially.
- Reviewer subagents do not invoke further subagents; they return findings and return.
- Skip a reviewer explicitly rather than silently when it doesn't apply (Security/UI may not
  apply; the Documentation reviewer always applies).
- The Documentation reviewer is a peer with no special veto — its findings aggregate like any other's.
- Aggregate the worst verdict — never average or soften findings across reviewers.
- When called by sdd-implement, stay silent on APPROVED — only speak when action is needed.
- Mark findings by severity; Critical issues are never buried or omitted.
