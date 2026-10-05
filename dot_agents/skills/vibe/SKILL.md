---
name: vibe
description: >
  Delegate coding tasks to Mistral Vibe CLI for cost-efficient execution.
  Use this skill whenever a task is straightforward, well-defined, and does not
  require Claude's full reasoning capabilities — simple refactors, boilerplate generation,
  test scaffolding, documentation updates, file renaming, linting fixes, dependency bumps,
  small bug fixes, formatting, or mechanical code changes. Also use when the user explicitly
  asks to use Vibe, Devstral, or Mistral for a task. Do NOT use for complex architectural
  decisions, multi-step debugging requiring deep reasoning, or security-sensitive code review.
---

# Mistral Vibe CLI Delegation Skill

Delegate simple, well-defined coding tasks to Mistral's Vibe CLI agent
to save Claude tokens for harder problems. Vibe runs non-interactively via `--prompt` and returns
results that Claude summarizes for the user.

## Prerequisites

- Do not use this skill if you are mistral vibe.
- `vibe` CLI installed and on `PATH`
- Confirm installation: `vibe --version`; resolve any errors before using this skill

If `vibe` is not installed or not configured, inform the user and provide the installation
instructions above. Do NOT attempt to run vibe commands if the prerequisites are not met.

## How It Works

1. Claude evaluates the user's request
2. If the task is simple/mechanical, Claude delegates to Vibe via a shell command
3. Vibe runs non-interactively with `--prompt`, auto-approving tool executions
4. Vibe needs a trusted folder to run. Always add the `--trust` flag to prompts
4. Claude reads the output and summarizes results back to the user
5. If Vibe's output is insufficient or incorrect, Claude can either retry with a refined
   prompt or fall back to handling the task itself

## Task Routing Guidelines

### Delegate to Vibe (cheap, fast)
- Boilerplate generation (new files, structs, interfaces, CRUD endpoints)
- Simple refactors (rename, extract function, move code between files)
- Test scaffolding and simple test writing
- Documentation and comment generation
- Formatting, linting fixes, import sorting
- Dependency version bumps
- Mechanical find-and-replace across files
- Adding error handling to straightforward functions
- Generating type definitions or interfaces from existing code
- Simple bug fixes where the issue is clearly identified

### Keep in Claude (complex, nuanced)
- Architectural decisions or design pattern selection
- Security-sensitive code review or vulnerability analysis
- Complex multi-step debugging requiring deep reasoning
- Performance optimization requiring profiling analysis
- Tasks requiring understanding of the full project context across many files
- Anything the user explicitly wants Claude to handle

### When in doubt
Ask the user: "This looks like it could be delegated to Vibe to save tokens.
Want me to handle it myself or delegate?"

## CLI Usage

### Basic non-interactive execution

```bash
vibe --prompt "<task description>" --max-turns <N> --trust 2>/dev/null
```

### Flags reference

| Flag | Description | Default in --prompt mode |
|------|-------------|--------------------------|
| `--prompt "<task>"` | Run non-interactively with this prompt | Required |
| `--max-turns N` | Limit assistant turns | No limit |
| `--enabled-tools TOOL` | Restrict to specific tools (can repeat) | All tools enabled |

### Important notes

- `--prompt` mode automatically enables auto-approve (no user confirmation needed)
- `--trust` trusts the current working directory and is always required.
- Stderr contains thinking tokens / debug output — suppress with `2>/dev/null` to avoid
  bloating Claude Code's context window
- If the user explicitly asks to see Vibe's thinking/reasoning, omit the `2>/dev/null`
- Vibe requires a trusted folder — always append --trust

## Execution Patterns

### Pattern 1: Simple task delegation (most common)

For a contained, single-purpose task:

```bash
cd /path/to/project && vibe --prompt "Add JSDoc comments to all exported functions in src/utils.ts" --max-turns 10 2>/dev/null
```

### Pattern 2: Read-only analysis

For tasks that only need to read code (no writes):

```bash
cd /path/to/project && vibe --prompt "List all API endpoints in this project with their HTTP methods and paths" --enabled-tools read_file --enabled-tools grep --max-turns 8 2>/dev/null
```

### Pattern 3: Scoped file edits

For edits limited to specific files:

```bash
cd /path/to/project && vibe --prompt "Refactor the error handling in src/api/client.rs to use thiserror instead of manual impl. Only modify files in src/api/." --max-turns 15 2>/dev/null
```

### Pattern 4: Test generation

```bash
cd /path/to/project && vibe --prompt "Generate unit tests for the functions in src/auth/token.go. Use the standard testing package. Place tests in src/auth/token_test.go" --max-turns 12 2>/dev/null
```

## Prompt Engineering for Vibe

When constructing the `--prompt` string for Vibe, follow these guidelines:

1. **Be specific and self-contained** — Vibe does not have the conversation context that Claude has.
   Include all relevant details: file paths, function names, expected behavior, constraints.

2. **Specify scope explicitly** — Tell Vibe which files/directories to work in and which to avoid.

3. **State the expected output** — "Create a new file at X", "Modify function Y in file Z",
   "Print a summary to stdout".

4. **Include language/framework context** — "This is a Rust project using Actix-web",
   "This is a SvelteKit app with TypeScript".

5. **Set boundaries** — "Do not modify any files outside src/api/",
   "Do not add new dependencies".

## Handling Vibe Output

After Vibe completes:

1. **Read the stdout output** — This contains Vibe's actions and results
2. **Verify the changes** — Check modified files if needed (use `git diff` or read the files)
3. **Summarize for the user** — Tell them what Vibe did, what files changed, and whether
   the task completed successfully
4. **Handle failures gracefully** — If Vibe failed or produced incorrect results:
   - For minor issues: retry with a more specific prompt
   - For fundamental failures: fall back to handling the task directly with Claude
   - Always inform the user what happened

## Example Workflow

**User says:** "Add error handling to the API calls in src/services/"

**Claude's process:**
1. Recognizes this as a mechanical task suitable for Vibe
2. Constructs a specific prompt with project context
3. Runs:
```bash
cd /path/to/project && vibe --prompt "Add proper error handling (try/catch or Result types as appropriate) to all API call functions in the src/services/ directory. Preserve existing function signatures. Use the project's existing error handling patterns." --max-turns 15 --max-price 0.50 2>/dev/null
```
4. Reads output, verifies changes with `git diff --stat`
5. Reports to user: "Vibe updated 4 files in src/services/ — added error handling to 12 API calls. Here's a summary of changes: ..."
