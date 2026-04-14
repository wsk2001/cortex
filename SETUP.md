# Setup

The user types `setup` in Claude Code or Cursor. You're here because that happened.

## AI Instructions

Ask the user: **"How far along are you with this project?"** Then follow the matching tier below.

### Onboarding tiers

After the user tells you how far along they are, follow the matching tier:

### Tier 1: Brand new (just an idea, no code)

**Step 1 -- Discovery interview.** Ask these questions all at once so the user can answer in one pass:

1. In one sentence, what does your app do?
2. Who is this for? Describe your ideal user.
3. When someone opens your app, what's the first thing they see and do?
4. What are the 3 most important things your app needs to do?
5. How will you make money? (ads, subscriptions, one-time purchase, free, not sure yet)
6. Do you have a preference for iPhone, Android, or both?
7. Is there an existing app that's similar to what you want? What would you do differently?
8. Any must-haves or dealbreakers? (e.g., must work offline, no login required)

**Step 2 -- Build PRD.** Structure the answers into `docs/PRD.md`:
- Fill in the vision, features table, user flows, technical decisions, and out of scope
- You recommend the technical stack based on their answers -- don't ask them to choose frameworks
- Present the PRD and ask: "Here's what I'm going to build. Does this look right?"

**Step 3 -- Set up system.** Once the PRD is approved:
- Fill in `CLAUDE.md` (description, folder map, routing table, conventions for their stack)
- Create `docs/APP_ARCHITECTURE.md` with the planned file structure
- Add initial decisions to `docs/DECISION_LOG.md` (platform choice, framework, monetization, etc.)
- Set up `.cursor/rules/project.mdc` with the same routing and conventions
- Create 2-3 scoped `.cursor/rules/` files for the planned feature areas, delete `feature-example.mdc`
- Uncomment the right section in `.cursorignore` for their stack
- Update `.gitignore` for their stack

**Step 4 -- Offer automation.** Ask if they want:
- Daily progress recaps (GitHub Actions)
- Automatic test runs on every push
- Weekly project summary reports

If yes, create the workflow files in `.github/workflows/`. If no, skip.

**Step 5 -- Start building.** Create the project folder structure and initial files.

---

### Tier 2: Early build (some code, testing things)

**Step 1 -- Scan.** Read the existing codebase to understand what's built.

**Step 2 -- Fill docs.** Based on what you find:
- Fill in `CLAUDE.md` with actual project info
- Create `docs/APP_ARCHITECTURE.md` from the existing files
- Create `docs/PRD.md` -- infer features from code, mark them with status, then ask: "What else are you planning to build?"
- Create `docs/DECISION_LOG.md` -- infer decisions already made (stack, patterns, architecture choices)

**Step 3 -- Optimize.** Look for gaps and suggest improvements:
- "I notice you don't have tests -- want me to set up a test structure?"
- "These files are getting large -- want me to split them?"
- "You have hardcoded values that could be configurable -- want me to extract them?"

**Step 4 -- Set up Cursor rules.** Create scoped `.mdc` files for existing feature areas. Delete `feature-example.mdc`.

**Step 5 -- Offer automation.** Same as Tier 1 Step 4.

**Step 6 -- Summary.** Show what was set up and suggest what to work on next.

---

### Tier 3: Live app (shipped, large codebase)

**Step 1 -- Full scan.** Thoroughly read the codebase.

**Step 2 -- Comprehensive docs:**
- Fill in `CLAUDE.md` with detailed routing (this project has many files -- routing matters most here)
- Create `docs/APP_ARCHITECTURE.md` with every file, grouped by feature area
- Create `docs/PRD.md` -- catalog ALL features visible in code as "done", then ask: "What are you planning next?"
- Create `docs/DECISION_LOG.md` -- infer architectural decisions from code patterns
- Populate the "Do NOT Load" table in `CLAUDE.md` (find files over 500 lines that are generated data, test fixtures, etc.)

**Step 3 -- Scoped rules.** Create one `.cursor/rules/` file per major feature area with specific file lists and dependencies. Delete `feature-example.mdc`.

**Step 4 -- Fill `.cursorignore`.** Identify large generated/data files to exclude from indexing.

**Step 5 -- Gap check:**
- "I notice you don't have [tests/CI/config management/etc.] -- want me to set that up?"
- "These areas might benefit from [specific optimization]"

**Step 6 -- Offer automation.** Same as Tier 1 Step 4.

**Step 7 -- Summary.** Show what was set up, highlight the most impactful additions.

---

### Tier 4: Inherited or forked project

Follow Tier 3, but add these extra steps:

**After scanning, explain the project to the user in plain language:**
- "Here's what this app does: [overview]"
- "Here's how the main user flow works: user opens app → [step by step]"
- "The codebase is organized like this: [plain-language structure]"
- "These areas look like they might need attention: [tech debt, incomplete features, TODOs]"

**Add a "Project Walkthrough" section** to `docs/APP_ARCHITECTURE.md` -- not just a file list, but a narrative explanation of how the app works.

---

### Tier 5: Multiple projects

Ask: "This template is set up per project. Which project should we set up first?"

Then run the appropriate tier for that project. Note to the user: clone the template separately into each project.

---

## After Setup: Built-in Commands

Once the system is set up, the user can say these at any time:

| Say this | AI does this |
|----------|-------------|
| "What should I work on next?" | Reads PRD, suggests highest-priority unbuilt feature |
| "Wrap up" or "Done for today" | Updates all docs, suggests committing, generates session summary |
| "Sync my docs" or "Update everything" | Rescans codebase, updates all context files, reports what changed |
| "What did we decide about [X]?" | Searches Decision Log for relevant entries |
| "How does [feature] work?" | Reads Architecture doc and relevant source files, explains in plain language |
