---
name: dev-preferences
description: Development workflow and coding preferences that MUST be followed for all software development tasks, including new features, bug fixes, refactors, tests, and code changes. Requires context gathering, clarification of consequential assumptions, a concise step-by-step implementation plan, explicit user approval before making changes, incremental execution in logical batches, verification after each step, adherence to existing project architecture and coding standards, Clean Code, appropriate DDD and SOLID practices, comprehensive RSpec coverage for backend changes when applicable, and final RuboCop/Overcommit validation. Keep communication concise and do not perform Git or dependency operations without explicit approval.
disable-model-invocation: false
---

# dev-preferences

## Purpose

Define the user's preferred software development workflow, engineering principles, code quality standards, testing expectations, and communication style.

These rules apply to all software development tasks, including:

- New features
- Bug fixes
- Refactoring
- Backend changes
- Frontend changes
- Database changes
- API changes
- Tests
- Performance improvements
- Configuration changes
- Architectural changes

The skill is stack-agnostic. Technology-specific rules should only apply when the relevant technology is present in the project.

---

## Core Principle

Follow this workflow for every coding task:

**Understand → Clarify → Plan → Approve → Execute → Verify → Approve → Repeat → Final Validation**

Do not skip the workflow simply because the requested change appears small.

The goal is to work collaboratively with the user rather than autonomously implementing the entire task.

---

# 1. Understand the Task

Before changing code, understand:

- What the user wants to accomplish
- The current behavior
- The desired behavior
- The relevant part of the codebase
- Existing architectural patterns
- Existing project conventions
- Existing tests
- Relevant dependencies and integrations
- Potential impact on data, APIs, security, or business logic

Inspect the existing implementation before proposing changes.

Do not assume that a generic "best practice" is preferable to an established project convention.

Existing project standards and patterns have priority.

---

# 2. Ask Clarifying Questions

Ask questions when an assumption could affect:

- Architecture
- Behavior
- Data
- API contracts
- Security
- Business logic
- User-facing behavior
- Backwards compatibility
- Integration behavior
- Persistence
- Performance in a meaningful way

Do not ask unnecessary questions when the answer can be determined reliably from:

- Existing code
- Existing tests
- Project conventions
- Configuration
- Documentation
- The user's explicit requirements

Avoid asking questions merely for the sake of asking.

The objective is to obtain enough context to make the correct plan.

---

# 3. Create a Plan

Once the task is understood, create a concise implementation plan.

The plan must:

- Contain all meaningful steps required to complete the task
- Be ordered logically
- Use simple language
- Avoid unnecessary explanations
- Identify relevant tests
- Identify relevant database or migration work
- Identify important validation steps

Example:

```text
Plan:
1. Add the domain event and handler.
2. Update the service to publish the event.
3. Add RSpec coverage for the new behavior and failure case.
4. Run the relevant specs.
5. Run Overcommit for final validation.
```

Do not provide lengthy explanations for each step unless the user asks.

After presenting the plan:

**STOP and wait for explicit user approval before making changes.**

Never silently transition from planning to implementation.

---

# 4. Execute Incrementally

After approval, execute the plan one logical step at a time.

A step may modify multiple files when those changes form a coherent unit.

For example, these may belong to the same step:

- A model change
- Its corresponding spec
- A small supporting domain object

Do not artificially split a logical change into individual file operations.

However, do not execute the entire plan at once unless the user explicitly asks for that.

After completing a step:

1. Verify the result.
2. Briefly report what was done.
3. Mention relevant test/validation results.
4. Present the next step.
5. Wait for approval before continuing.

---

# 5. Existing Project Standards Have Priority

Before introducing a pattern, inspect how the project already solves similar problems.

Follow established conventions for:

- Directory structure
- Naming
- Classes and modules
- Domain boundaries
- Services
- Commands
- Queries
- Events
- Event handlers
- Models
- Controllers
- Policies
- Serializers
- Form objects
- Value objects
- Testing
- Factories
- Fixtures
- Error handling
- Transactions
- Background jobs
- Frontend behavior
- Database access

Do not introduce a new architectural pattern simply because it is considered a generic best practice.

Consistency with the existing codebase is usually more important than introducing a theoretically superior pattern.

When an existing project convention conflicts with a generic recommendation, prefer the project convention unless there is a concrete reason to change it.

---

# 6. Clean Code

Write code that is:

- Simple
- Readable
- Intention-revealing
- Small where appropriate
- Easy to test
- Easy to change
- Consistent with the surrounding code

Prefer straightforward solutions over clever solutions.

Avoid:

- Unnecessary abstractions
- Premature optimization
- Clever metaprogramming
- Deep nesting
- Long methods
- Unclear naming
- Duplication when a meaningful abstraction is appropriate
- Abstractions that exist only to satisfy a principle

Do not over-engineer a solution.

---

# 7. Domain-Driven Design

The project follows DDD.

Respect the existing domain model and boundaries.

Use DDD principles where appropriate, while preserving the project's established implementation patterns.

In particular:

- Keep domain logic in appropriate domain boundaries.
- Avoid leaking business rules into infrastructure unnecessarily.
- Preserve existing bounded-context/domain boundaries.
- Prefer domain concepts over primitive values when the existing architecture supports them.
- Respect existing event-driven patterns.
- Use the project's existing domain event conventions.

The project uses `rails_event_store` where applicable.

Do not replace or introduce alternative eventing mechanisms when an existing `rails_event_store` pattern should be used.

Do not introduce new DDD structures solely because they are theoretically possible.

The existing project's DDD implementation is the source of truth.

---

# 8. SOLID

Apply SOLID principles when appropriate.

Do not force SOLID abstractions into simple code.

In particular:

- Prefer single responsibilities when responsibilities are genuinely distinct.
- Depend on abstractions where they provide meaningful flexibility or testability.
- Avoid unnecessary coupling.
- Keep interfaces focused.
- Extend existing behavior without creating needless modifications when practical.

Use judgment.

The goal is maintainable software, not maximum abstraction.

---

# 9. Testing

## Backend

All changes to backend logic must have RSpec coverage.

This includes:

- New functionality
- Changed functionality
- Bug fixes
- New business rules
- New domain behavior
- New services
- New events
- New event handlers
- Changed persistence behavior
- Changed API behavior
- Previously untested backend files when they are modified

When modifying backend code that lacks tests, add appropriate RSpec coverage.

The objective is to continuously increase and maintain meaningful RSpec coverage.

Do not consider a backend implementation complete if its new or changed behavior is not adequately tested.

---

## RSpec Style

Follow the conventions from:

https://betterspecs.org/

Prefer clear, behavior-oriented specs.

Use appropriate:

- `describe`
- `context`
- `it`
- `subject`
- `let`
- `let!`
- Shared examples when genuinely useful

Tests should describe behavior rather than implementation details whenever practical.

Keep tests readable and focused.

Do not create excessive test abstractions merely to reduce a small amount of duplication.

---

# 10. Test Strategy

During development:

1. Run the most relevant specs first.
2. Fix failures before continuing.
3. Expand test execution as the change grows.
4. Run the appropriate broader suite when necessary.
5. Before considering the task complete, perform the project's final quality checks.

Never claim tests passed unless they were actually executed.

If tests cannot be run, state that clearly.

Never hide or ignore failing tests.

---

# 11. Database Changes

When a task changes the database:

- Follow the project's migration conventions.
- Create a new migration instead of modifying an existing migration that may already have been executed.
- Consider indexes where appropriate.
- Consider query performance.
- Consider existing data.
- Consider nullability and defaults.
- Consider data migrations separately from schema migrations.
- Consider rollback behavior.
- Consider backwards compatibility where relevant.
- Avoid destructive changes without explicitly identifying their impact.

Database changes must be tested when they affect application behavior.

The project's existing Overcommit checks should be respected for schema and migration changes.

---

# 12. Production Safety

When relevant, consider:

- Backwards compatibility
- Existing production data
- Database performance
- N+1 queries
- Transactions
- Race conditions
- Concurrency
- Sidekiq/background jobs
- External APIs
- Authentication
- Authorization
- Security
- Error handling
- Logging
- Observability
- Rollout implications

These are considerations, not mandatory ceremony for every change.

Do not add unnecessary complexity for a change where the concern is clearly irrelevant.

---

# 13. Dependencies

Never add, remove, or upgrade a dependency without explicit user approval.

This includes:

- Ruby gems
- JavaScript packages
- System dependencies
- Framework dependencies
- Development dependencies

If a dependency appears necessary:

1. Explain briefly why it is needed.
2. Stop.
3. Ask for explicit approval.
4. Only then modify dependency files.

Do not silently add a dependency as part of implementation.

---

# 14. Git

Never perform Git operations unless explicitly requested by the user.

Do not automatically:

- Create commits
- Amend commits
- Create branches
- Switch branches
- Stage files
- Unstage files
- Reset changes
- Rebase
- Push
- Pull
- Merge
- Cherry-pick
- Rewrite history

The user controls Git operations.

---

# 15. Scope Control

Do not expand the scope of the task because unrelated technical debt is discovered.

If unrelated problems are found:

- Do not fix them automatically.
- Mention them briefly if they are relevant.
- Keep them separate from the current implementation.

Example:

```text
Unrelated: UserService has duplicated validation logic.
I did not change it because it is outside the current scope.
```

Do not turn a focused bug fix into an unrelated refactoring project.

---

# 16. Refactoring

Refactor when necessary to safely implement the requested change or when the existing code makes the requested behavior unnecessarily difficult.

Do not refactor unrelated code.

When a refactor is substantial enough to affect architecture or scope:

- Identify it in the plan.
- Explain briefly why it is necessary.
- Obtain user approval before proceeding.

Prefer small, intentional refactors over broad cleanup.

---

# 17. Code Changes

Make the smallest coherent change that correctly fulfills the requirement.

Prefer:

- Existing abstractions
- Existing conventions
- Existing dependencies
- Existing domain patterns
- Existing helpers/utilities

before introducing new mechanisms.

Do not duplicate an existing project capability without first checking whether it already exists.

Before creating a new abstraction, search the codebase for an existing equivalent.

---

# 18. Validation

When development is complete, perform the appropriate validation.

For Ruby/Rails projects, this includes the project's configured quality checks.

Run:

```bash
overcommit --run
```

when appropriate.

Overcommit includes RuboCop and other configured checks.

Respect all project-configured rules.

Do not bypass, disable, or weaken linting or quality checks simply to make the change pass.

If a check fails:

1. Investigate the failure.
2. Fix the underlying issue.
3. Run the check again.

Do not claim completion while required quality checks are failing unless the user explicitly accepts the failure.

---

# 19. Communication

Keep output minimal.

The user prefers concise communication to reduce cost and keep development fast.

By default, communicate only:

- Relevant findings
- Questions/blockers
- The implementation plan
- Current step
- What changed
- Validation results
- The next step

Do not provide lengthy explanations unless requested.

Do not explain obvious code changes.

Do not repeat information already established.

If the user asks for more detail, provide it.

---

# 20. Approval Gates

There are two important approval gates.

## Gate 1 — Before implementation

After understanding the task and resolving necessary questions:

1. Present the complete implementation plan.
2. Wait for user approval.
3. Do not modify files before approval.

## Gate 2 — Between implementation batches

After completing each logical implementation step:

1. Verify the step.
2. Report the result concisely.
3. Present the next step.
4. Wait for user approval.

A user approving the overall plan does not automatically mean the entire plan should be executed without intermediate checkpoints.

---

# 21. Handling Small Changes

Even for small tasks, follow the workflow.

For a trivial change, the workflow can be very lightweight:

```text
Plan:
1. Update the validation and its spec.

Proceed?
```

After approval:

```text
Step 1 complete.
Specs pass.

Next: run final validation.
Proceed?
```

Do not create unnecessary ceremony, but do not skip the approval model.

---

# 22. Do Not

Never:

- Implement before receiving approval.
- Execute the entire plan without intermediate approval.
- Guess about consequential business requirements.
- Ignore existing project conventions.
- Introduce architecture unnecessarily.
- Over-engineer simple changes.
- Expand the task into unrelated refactoring.
- Add dependencies without approval.
- Perform Git operations without approval.
- Modify previously executed migrations.
- Ignore failing tests.
- Ignore RuboCop/Overcommit failures.
- Disable quality checks to make the code pass.
- Claim a command was run when it was not.
- Claim tests passed when they were not run.
- Make assumptions about business logic when clarification is needed.
- Provide unnecessarily verbose output.

---

# 23. Completion Criteria

A task is complete when:

- The requested behavior has been implemented.
- The implementation follows existing project architecture and conventions.
- Appropriate Clean Code and SOLID principles have been applied.
- DDD patterns are respected where applicable.
- Backend behavior has appropriate RSpec coverage.
- Relevant tests pass.
- Database changes, if any, are correctly implemented.
- Relevant production-safety concerns have been addressed.
- `overcommit --run` has been run when applicable.
- All required quality checks pass.
- No unrelated work has been introduced.
- The user has been informed of the final result.

---

# 24. Default Development Loop

Use this loop for every coding task:

```text
1. Understand the request.
2. Inspect the relevant code and existing patterns.
3. Identify missing context.
4. Ask only consequential questions.
5. Build the complete implementation plan.
6. Present the plan concisely.
7. WAIT FOR USER APPROVAL.
8. Execute the first logical batch.
9. Verify the batch.
10. Report briefly.
11. WAIT FOR USER APPROVAL.
12. Execute the next logical batch.
13. Repeat until implementation is complete.
14. Run relevant tests.
15. Run final quality checks, including overcommit --run when applicable.
16. Report completion concisely.
```

The user is an active participant in both planning and execution.

Do not optimize for autonomous completion.

Optimize for **correctness, maintainability, project consistency, and controlled incremental development**.
