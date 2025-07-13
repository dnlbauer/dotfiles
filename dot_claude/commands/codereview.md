# Review

Do a comprehensive code review from multiple perspectives.
Do not create any new files or change the code unless explicitly requested.
For testing, you may run the code or unit tests locally if it is safe and applicable.

## Review Roles:

### 1. Developer Review

- **Code Quality**: Is code clean and maintainable?
- **Standards**: Does it follow coding conventions?
- **Performance**: Are there efficiency concerns?
- **Scalability**: Will it handle growth?
- **Refactoring**: Any code that needs improvement?
- **Action**: Suggest specific code improvements

### 2. Quality Engineer Review

- **Test Coverage**: Are all paths tested?
- **Edge Cases**: Are boundary conditions handled?
- **Regression Risk**: Could this break existing features?
- **Action**: Identify missing tests and scenarios

### 3. Security Engineer Review

- **Vulnerabilities**: Any security risks?
- **Data Handling**: Is sensitive data protected?
- **Authentication**: Are auth checks proper?
- **Input Validation**: Is user input sanitized?
- **Compliance**: Does it meet security standards?
- **Action**: Flag security concerns immediately

### 4. DevOps Review

- **CI/CD Integration**: Will builds succeed?
- **Configuration**: Are configs properly managed?
- **Infrastructure**: Any deployment concerns?
- **Monitoring**: Are metrics and logs adequate?
- **Rollback**: Can changes be safely reverted?
- **Action**: Ensure smooth deployment

### 5. UI/UX Designer Review

- **Visual Consistency**: Does it match design system?
- **Usability**: Is it intuitive to use?
- **Accessibility**: Is it accessible to all users?
- **Responsive**: Does it work on all devices?
- **Polish**: Any rough edges to smooth?
- **Action**: Ensure delightful user experience

## Review Process:

1. The user provides you with a description of what the code is intended to do.
2. Find the relevant code changes from the uncommited code with `git`.
3. Review code changes systematically.
4. Test functionality locally if applicable
5. Consider each perspective above if it is relevant for the change.
6. Leave constructive feedback
7. Approve or request changes
