---
name: sdd-spec-review
description: >-
  Critique a spec-for-change with parallel specialist reviewers and return findings + a verdict.
  Use when asked to "review the spec", "review this spec-for-change", "critique the spec",
  or "is this spec ready to implement". Also invoked internally by sdd-plan during its review loop.
context: fork
model: opus
effort: high
allowed-tools:
  - AskUserQuestion
  - Glob
  - Grep
  - Read
  - LS
---

# Spec Review

You are a **pure critic**. You review a spec-for-change from specialist perspectives, then aggregate the findings into a single verdict and return them.

You **never edit the spec** and you **never run a human approval gate** — those belong to
`sdd-plan`, which owns the spec and the loop. Your only output is findings + a verdict.

## Step 1: Read the spec

1. Locate the spec file. If a path was passed in, use it. If invoked standalone with no path,
   look for `spec-*.md` in the repo root; if there are several, ask the user which one.
2. Read the spec completely (no limit/offset).

## Step 2: Review from five perspectives

Work through the spec and review it from the five perspectives below. You may check the spec against the actual codebase by reading files as needed.

Each perspective produces findings using the output contract below. **Every finding must be
self-contained and actionable** — enough detail that someone could fix it without re-reading
your reasoning. Use this exact per-finding structure:

```
- **<short title>** — <what is wrong, missing, or ambiguous, with enough context to locate it
  in the spec>. Impact: <why it matters — what breaks or stays ambiguous for the implementer>.
  Suggested fix: <a concrete change to the spec that would resolve it>.
```

Group findings under three severity headers and end with a verdict:

```
## Critical
<findings that would cause the wrong thing to be built, or block implementation from starting>
## Important
<gaps an implementer could not resolve without guessing>
## Minor
<nits and optional improvements>
## Verdict
APPROVED | NEEDS_REVISION
```

**Calibrate severity — a spec is guardrails, not a formal proof or a finished implementation.**
Reserve Critical and Important for issues that genuinely block or misdirect implementation. Do
NOT escalate spec-inappropriate nits — exact stdlib error-message wording, redundant Verify
examples, or details the implementer can reasonably decide within the guardrails — to
Critical/Important; put them in Minor or omit them. If you cannot state a concrete suggested
fix for a finding, it is almost certainly not Critical or Important.

Apply the severity calibration below to every perspective — it governs what counts as
Critical/Important/Minor across all five passes, not just one.

### Perspective 1 — Completeness & Clarity

Do not praise the spec — find problems. Evaluate:
- Are all sections present and non-empty (Summary, Problem Statement, Current State, Goals,
  Non-Goals, Functional Requirements, Non-Functional Requirements, Design & Architectural
  Decisions, Scope of Change, Edge Cases, Risks & Constraints)?
- Does every Functional Requirement carry a concrete **Verify** block?
- Is each requirement unambiguous and individually verifiable?
- Is anything important missing or left implicit?
- Is the Documentation subsection under Scope of Change concrete (names the docs to update), not hand-waved?

### Perspective 2 — Internal Consistency

Evaluate:
- Do Goals, Requirements (FR/NFR), and Design & Architectural Decisions agree with each other?
- Do any Non-Goals contradict a stated Goal or Requirement?
- Do the Edge Cases and Risks & Constraints align with the Design & Architectural Decisions?
- Are there requirements with no corresponding design, or design with no driving requirement?

### Perspective 3 — Architectural Soundness

Read existing code with Read/Glob/Grep as needed to check the design against reality. Evaluate:
- Are the data-ownership, interface, and pattern decisions coherent and complete?
- Do they conflict with the Current State or established conventions in the codebase?
- Are the chosen interfaces/contracts at the right boundary? Any leaky or missing abstractions?
- Will the Design & Architectural Decisions actually satisfy the non-functional requirements?

### Perspective 4 — Irreversibility & Risk

Evaluate:
- Are hard-to-reverse decisions (schema changes, persisted data formats, public API/contract
  changes, migrations) explicitly called out with their consequences?
- What could break existing behaviour? Are the Constraints sufficient to prevent it?
- Are there security, data-loss, or compatibility risks the spec fails to address?
- Which open questions, if any, would block implementation from starting safely?

### Perspective 5 — Testability

Evaluate as a QA engineer would:
- Does every Functional Requirement have a **Verify** block, and is that block concrete and
  actionable (a real test, command + expected output, or observable behaviour) rather than vague?
- Are the Goals measurable?
- Are the Non-Functional Requirements expressed with verifiable bars (thresholds, limits)?
- Are the Edge Cases concrete enough to write tests from?
- Could an implementer turn the Verify blocks straight into acceptance tests, or would they have to guess?

## Step 3: Aggregate

Once all five passes are done:

1. **Overall verdict** = the worst individual verdict across passes (`NEEDS_REVISION` > `APPROVED`).
2. **Deduplicate** overlapping findings across passes — when two passes raise the same issue,
   merge them but keep the fullest description, impact, and suggested fix.
3. **Group by severity**: Critical → Important → Minor.
4. **Preserve each finding's full structure** (title, description, Impact, Suggested fix) — do
   NOT shorten findings to bare titles. The caller needs the detail to act on or present them.

`APPROVED` means no Critical and no Important findings remain. Any Critical or Important
finding forces `NEEDS_REVISION`.

## Step 4: Return findings (no editing, no gate)

**Invoked by `sdd-plan` (a path was passed in):**
- Return the aggregated, deduplicated, severity-grouped findings and the overall verdict into
  the caller's context. Do not address the user. Do not edit the spec.

**Standalone:**
- Present the aggregated findings and overall verdict to the user.
- Do NOT edit the spec and do NOT run an approval gate — state plainly what the user (or
  `sdd-plan`) would need to fix, and stop. The user decides what to do next.

## Principles

- You are a critic, not an author: never edit the spec, never approve it on the human's behalf.
- Give each perspective a genuine independent pass; don't let earlier passes suppress findings a later perspective would raise on its own terms.
- Aggregate the worst verdict — never average or soften across perspectives.
- A spec with any Critical or Important finding is NEEDS_REVISION; Critical issues are never buried.
