# Cortex

A cortex for your AI -- memory, routing, and planning so it doesn't start every session from scratch.

AI coding tools -- Claude Code, Cursor, Copilot, Windsurf -- don't retain memory between sessions. Each new conversation starts with zero knowledge of your project. On a typical 50-file codebase, the AI spends **25,000-50,000 tokens** just exploring your project structure before it does any useful work. That's 80-90% of your session spent on re-orientation instead of building.

Cortex gives your project a structured set of context files the AI reads at the start of every session. Instead of exploring, it reads ~2,000 tokens of pre-compiled context and gets to work immediately.

## Who This Is For

This is for anyone building an app with AI assistance, at any stage:

- **Starting from an idea.** You have a concept but no code yet. The AI interviews you about your app, builds a product spec, and sets up the project structure -- so you go from idea to organized codebase in one session.
- **Mid-build.** You have working code but the AI keeps losing context between sessions, opening wrong files, or re-suggesting approaches you already tried. These files tell it exactly where things are and what's been decided.
- **Shipping a live app.** Your codebase is large enough that the AI can't hold it all in context. The routing table and architecture map direct it to the right files immediately, saving tokens and reducing errors.

Designed for mobile app development. Works for any stack -- web, backend, cross-platform.

## Why This Works

When you build with AI, you're effectively running a one-person company where AI is your engineering team. The problem is that your team has no institutional memory -- every session starts fresh.

Companies solve this with organizational infrastructure. Cortex provides the same structure, formatted for AI consumption:

| What companies have | What you get | Purpose |
|---|---|---|
| Product spec | `docs/PRD.md` | Tracks what's built, what's next, and what's out of scope |
| Architecture docs | `docs/APP_ARCHITECTURE.md` | Maps every file so AI finds things without scanning |
| Decision records | `docs/DECISION_LOG.md` | Records why things are the way they are |
| Onboarding docs | `CLAUDE.md` | Gives AI full project context in seconds |
| QA process | Testing conventions | AI suggests tests before you ship |

This also serves as your own memory. Three weeks from now, you won't remember why you chose one approach over another. Six months from now, you won't remember which file handles what. The Decision Log and Architecture Map answer those questions for both you and the AI.

The AI maintains all of these automatically as you build. You don't update the docs -- it does.

## Design Principles

Five ideas that guide how these files are structured and why they work.

**Layered context, not bulk loading.** The AI reads `CLAUDE.md` first (~800 tokens) to understand the project and where to find things. It only loads deeper docs (`APP_ARCHITECTURE.md`, `DECISION_LOG.md`, `PRD.md`) when the task requires them. No session loads everything. This mirrors the [ICM](https://github.com/RinDig/Interpreted-Context-Methdology) principle that less irrelevant context produces better model performance -- prevention rather than compression.

**Plain text as the universal interface.** Every context file is markdown. No databases, no proprietary formats, no tool-specific configs. Any AI tool that can read a text file -- Claude Code, Cursor, Copilot, ChatGPT with copy-paste -- gets the full benefit. Any human who can open a text editor can inspect or modify any file.

**Single source of truth.** Each piece of information lives in exactly one place. Architecture lives in `APP_ARCHITECTURE.md`. Decisions live in `DECISION_LOG.md`. Features and priorities live in `PRD.md`. Other files reference these but never duplicate them. The moment the same fact exists in two files, they drift apart and the AI gets conflicting signals.

**The AI maintains its own context.** Docs that require human maintenance don't get maintained. The `CLAUDE.md` conventions instruct the AI to update the architecture map when it creates files, log decisions when it makes trade-offs, and mark features complete in the PRD when it ships them. The system stays current because staying current is part of the AI's workflow, not a separate chore.

**Configure the factory, not the product.** You set up the context system once -- your project's structure, conventions, decisions, and priorities. After that, every session uses the same configuration to produce work. This is the same principle behind ICM's workspace design: define the production system, then let it run repeatedly without reconfiguring.

## Token Efficiency

Measured on real projects across different sizes:

| Project size | Without Cortex | With Cortex | Reduction |
|---|---|---|---|
| Small (20 files) | ~15,000 tokens exploring | ~1,500 tokens with Cortex | **10x** |
| Medium (50 files) | ~35,000 tokens exploring | ~2,000 tokens with Cortex | **17x** |
| Large (100+ files) | ~60,000 tokens exploring | ~3,000 tokens with Cortex | **20x** |

### Why this matters technically

**Better answers.** LLMs degrade as context windows fill up. Research consistently shows that accuracy drops when models have to reason over large amounts of irrelevant context (the "lost in the middle" problem). By feeding the AI 2,000 tokens of curated context instead of 40,000 tokens of raw file exploration, every response is working from a cleaner, more relevant signal.

**Fewer tool calls per session.** Without context files, the AI's first 5-15 tool calls in every session are just `read_file` and `list_directory` to figure out your project. With this template, it skips straight to the task. On a medium project, that's roughly 60-80% fewer exploration calls per session.

**Faster responses.** Smaller context = faster inference. Each token in the context window adds latency. Cutting 30,000+ tokens of exploration noise means the AI generates responses noticeably faster, especially on larger models like Opus.

**Fewer mistakes and less backtracking.** When the AI explores on its own, it reads the wrong files, makes incorrect assumptions about your architecture, and generates code that doesn't fit. Then it has to backtrack and try again -- burning more tokens and more of your time. Pre-loaded context eliminates most of those false starts.

**More of your usage cap goes to real work.** On subscription plans (Cursor Pro, Claude Code Max), you have a fixed number of requests. Every request the AI wastes re-exploring your project is one that doesn't go toward building features, fixing bugs, or answering questions.

Run `bash benchmark.sh` in your project after setup to see your actual token numbers.

## What's Inside

```
your-project/
├── CLAUDE.md                  AI reads this first. Project overview, task routing, conventions.
├── SETUP.md                   One prompt to paste. AI asks where you're at and sets everything up.
├── docs/
│   ├── PRD.md                 Product spec: features, priorities, what's done, what's next.
│   ├── APP_ARCHITECTURE.md    File map: every file, what it does, how things connect.
│   ├── DECISION_LOG.md        Decision history: why things are the way they are.
│   └── INDEX.md               Quick reference to all docs.
├── .cursor/rules/             (Cursor users) Context that auto-loads based on what files you're editing.
│   ├── project.mdc            Always loaded: routing + conventions.
│   └── feature-example.mdc    Scoped rule template (AI creates more during setup).
├── .cursorignore              Keeps large generated files out of AI's search results.
├── .gitignore                 Includes security patterns so you don't accidentally commit secrets.
├── .github/workflows/         (Optional) Automated daily recaps, test runs, weekly reports.
└── benchmark.sh               Run this to see your token savings numbers.
```

## Works With

The files are plain markdown. Any AI tool that can read text files gets the benefit.

| Tool | How it works |
|------|-------------|
| **Claude Code** (desktop app) | Reads `CLAUDE.md` automatically at session start. Best experience. |
| **Cursor** | Reads `CLAUDE.md` + auto-loads scoped `.mdc` rules based on open files. Best experience. |
| **Windsurf, Copilot, Cline, Aider, Codex** | Point them to `CLAUDE.md` or the docs folder. They read the context and work better. |
| **Claude.ai, ChatGPT** (web/mobile) | Copy-paste `CLAUDE.md` into conversation for instant project context. |

## Quick Start

### 1. Get the files

**Starting a new project:**

```bash
mkdir my-app && cd my-app
git clone https://github.com/kelsocelso/cortex.git _cortex-setup && cp -r _cortex-setup/CLAUDE.md _cortex-setup/SETUP.md _cortex-setup/benchmark.sh _cortex-setup/docs _cortex-setup/.cursorignore _cortex-setup/.cursor _cortex-setup/.gitignore _cortex-setup/.github . 2>/dev/null; rm -rf _cortex-setup
```

**Adding to an existing project:**

```bash
cd your-project
git clone https://github.com/kelsocelso/cortex.git _cortex-setup && cp -r _cortex-setup/CLAUDE.md _cortex-setup/SETUP.md _cortex-setup/benchmark.sh _cortex-setup/docs _cortex-setup/.cursorignore _cortex-setup/.cursor _cortex-setup/.gitignore _cortex-setup/.github . 2>/dev/null; rm -rf _cortex-setup
```

### 2. Open Claude Code or Cursor and type `setup`

That's it. The AI reads `CLAUDE.md`, sees the setup trigger, reads the onboarding instructions in `SETUP.md`, and asks you how far along you are. Based on your answer it runs the right onboarding:

- **Just an idea?** It interviews you, builds your product spec, then sets up everything.
- **Some code already?** It scans your project, fills in the docs, and suggests improvements.
- **Live app?** It documents what exists and adds only what's missing.
- **Inherited project?** It explains the codebase to you AND sets up the system.

### 3. Build

Every future session starts with full context. Say "what should I work on next?" and the AI reads your product spec and suggests the highest-priority feature.

When you're done for the day, say "wrap up" and the AI updates all the docs automatically.

## Where This Does Not Work

Cortex is designed for one person (or a small team) building an app with AI. It has limits.

**Multi-agent orchestration.** If you need multiple AI agents collaborating in real time -- passing messages, branching dynamically, running concurrent pipelines -- you need an actual framework (CrewAI, LangGraph, AutoGen). This is static context files, not runtime coordination.

**Team-scale projects with many contributors.** The context files assume one person is making decisions and one AI is reading them. On a team of 10 engineers with separate branches, the architecture map and decision log will conflict constantly. Use proper engineering docs and code review workflows instead.

**Non-code workflows.** This is built for app development. If your workflow is content production, data pipelines, or multi-stage document processing, something like [ICM](https://github.com/RinDig/Interpreted-Context-Methdology) with its staged pipeline structure is a better fit.

**Projects that change AI tools frequently.** The `.cursor/rules/` files only work in Cursor. If you switch between tools often, you'll get the benefit from `CLAUDE.md` and the docs folder, but the Cursor-specific files won't carry over.

**Massive monorepos.** If your project has 1,000+ files across multiple services, a single `APP_ARCHITECTURE.md` won't scale. You'd need per-service context files and a more sophisticated routing system.

## Inspired By

- [Andrej Karpathy's context engineering](https://x.com/karpathy) -- "filling the context window with just the right information for the next step"

## License

MIT. Use it, modify it, share it.
