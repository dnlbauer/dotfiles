# Commit

Create commits with a well-formatted commit messages
using conventional commit messages.

## Process

1. Check for changes (`git status`). If something is staged, consider only staged changes.
Otherwise, review and stage appropriate files.
2. Determine the commit type (e.g. feat, fix, docs, refactor, ...).
3. Generate descriptive commit message using conventional commit standards.
Include scope if applicable: `type(scope): description`.
5. Add body for complex changes explaining the why.
6. Execute commit

## Best Practices

- Keep commits atomic and focused
- Write in imperative style (use "Add feature" not "Added feature")
- Explain why, not just what
- Reference issues/PRs when relevant
- Split unrelated changes into separate commits.
- Do not add Claude Code as co-author to the commit.
