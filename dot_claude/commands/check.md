# Check

Perform comprehensive code quality checks and tests.
Do not make any code changes during this process.

Exception: Fixing lint errors, type errors, formatting issues and failing unit tests.

## Common Checks Include

1. **Linting**: Code style and syntax errors
2. **Type Checking**: Type errors
3. **Unit Tests**: Unit and integration tests
4. **Security Scan**: Vulnerability scan
5. **Code Formatting**: Style consistency
6. **Build Verification**: Compilation errors

## Process

1. Run the check command.
2. Analyze output for errors and warnings
3. Fix issues in priority order:
   - Build-breaking errors first
   - Test failures
   - Linting and type errors
   - Warnings
4. Re-run checks after applying a fix
5. Continue until all checks pass
