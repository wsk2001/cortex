# [Your App Name]

<!-- AI fills this in during onboarding. You don't need to edit this manually. -->

[One-line app description: platform, framework, what it does.]

## Folder Map

```
your-project/
├── CLAUDE.md                  (you are here -- AI reads this first every session)
├── docs/
│   ├── PRD.md                 (product spec: features, priorities, what's done vs planned)
│   ├── APP_ARCHITECTURE.md    (file map: every file and what it does)
│   ├── DECISION_LOG.md        (why things are the way they are)
│   └── INDEX.md               (quick reference to all docs)
├── src/                       (app source code)
└── tests/                     (test files)
```

## Task Routing

| If you are asked to... | Read these first | Skip these |
|------------------------|------------------|------------|
| Plan what to build next | `docs/PRD.md` | Source code, config files |
| Fix a bug or crash | `docs/APP_ARCHITECTURE.md` → relevant file(s), `docs/DECISION_LOG.md` | Unrelated feature areas, generated files |
| Add a new feature | `docs/PRD.md`, `docs/APP_ARCHITECTURE.md`, `docs/DECISION_LOG.md` | Generated files, unrelated areas |
| Change a config value | Config files only | All source code |
| Fix UI or styling | `docs/APP_ARCHITECTURE.md` → relevant view/component | Models, services, config |
| Understand this project | `docs/PRD.md`, `docs/APP_ARCHITECTURE.md`, `docs/DECISION_LOG.md` | Source code (read docs first) |

## Do NOT Load

<!-- Large files that waste tokens. AI fills this in during onboarding. -->

| File | Lines | Why to skip |
|------|-------|-------------|

## Session Rituals

### When the user says "setup"
- Read `SETUP.md` and follow the onboarding instructions there
- Ask the user how far along they are, then run the matching tier

### When a session starts
- Read this file and `docs/PRD.md`
- If the user asks "what should I work on next?", suggest the highest-priority unbuilt feature from the PRD
- If picking up from a previous session, check the last entry in `docs/DECISION_LOG.md` for context

### When the user says "wrap up" or "done for today"
- Update `docs/APP_ARCHITECTURE.md` if any files were created, renamed, or deleted
- Add entries to `docs/DECISION_LOG.md` for any decisions made this session
- Update feature statuses in `docs/PRD.md` (building → done, or add new planned features)
- Suggest committing any uncommitted changes: "Want me to commit these changes?"
- Generate a brief summary: what was done, what's next

### When the user says "sync my docs" or "update everything"
- Rescan the entire codebase
- Update all docs to reflect the current state
- Report what changed

## Auto-Maintain Rules

After completing any task, automatically:
- If you created or renamed files → update `docs/APP_ARCHITECTURE.md`
- If you made an architectural or product decision → add to `docs/DECISION_LOG.md`
- If you completed a feature → mark it "done" in `docs/PRD.md`
- If you changed behavior → suggest what to test and offer to write tests

## Conventions

### Project rules
<!-- AI fills these in based on your stack. Examples below. -->
- **Check decisions first**: Read `docs/DECISION_LOG.md` before changing architecture or core behavior.
- **PRD is the source of truth**: If a feature isn't in `docs/PRD.md`, discuss it before building.
- **Propose before building**: For structural changes, propose the approach first. Small fixes proceed directly.

### Testing
- After building a feature, suggest what to test and offer to write tests.
- Before marking a feature "done" in the PRD, confirm it has basic test coverage or note tests are pending.

### Security
- Never put API keys, passwords, or secrets directly in code. Use environment variables.
- If you see hardcoded secrets, flag them immediately and move them to `.env`.
- Never commit `.env` files, credentials, or private keys.

### Git workflow
- Commit after each completed feature with a clear, descriptive message.
- Before risky or experimental changes, suggest creating a branch: `git checkout -b experiment-name`
- If the user says something broke, offer to revert: `git checkout .` or `git stash`
