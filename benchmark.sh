#!/bin/bash
# Measures the token savings of your context files vs raw codebase exploration.
# Run from your project root: bash benchmark.sh

echo ""
  echo "  Cortex Benchmark"
  echo "  ================"
echo ""

# Detect source files (common extensions)
SOURCE_FILES=$(find . -type f \( \
  -name "*.swift" -o -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \
  -o -name "*.py" -o -name "*.dart" -o -name "*.kt" -o -name "*.java" \
  -o -name "*.go" -o -name "*.rb" -o -name "*.rs" -o -name "*.cs" \
  -o -name "*.vue" -o -name "*.svelte" \
  \) \
  -not -path "*/node_modules/*" \
  -not -path "*/DerivedData/*" \
  -not -path "*/.build/*" \
  -not -path "*/build/*" \
  -not -path "*/dist/*" \
  -not -path "*/.git/*" \
  -not -path "*/_context-setup/*" \
  2>/dev/null)

if [ -z "$SOURCE_FILES" ]; then
  echo "  No source files found. Run this from your project root."
  exit 1
fi

FILE_COUNT=$(echo "$SOURCE_FILES" | wc -l | tr -d ' ')
TOTAL_LINES=$(echo "$SOURCE_FILES" | xargs cat 2>/dev/null | wc -l | tr -d ' ')

# Estimate tokens (~1.3 tokens per line of code is a rough average)
EXPLORE_TOKENS=$((TOTAL_LINES * 13 / 10))

echo "  Your Codebase"
echo "  ─────────────"
echo "  Source files:      $FILE_COUNT"
echo "  Total lines:       $TOTAL_LINES"
echo "  Est. tokens:       ~$EXPLORE_TOKENS (if AI read everything)"
echo ""

# Measure context files
CONTEXT_LINES=0
CONTEXT_FILES=""

for f in CLAUDE.md docs/PRD.md docs/APP_ARCHITECTURE.md docs/DECISION_LOG.md; do
  if [ -f "$f" ]; then
    LINES=$(wc -l < "$f" | tr -d ' ')
    CONTEXT_LINES=$((CONTEXT_LINES + LINES))
    CONTEXT_FILES="$CONTEXT_FILES\n    $f: $LINES lines"
  fi
done

if [ "$CONTEXT_LINES" -eq 0 ]; then
  echo "  No context files found (CLAUDE.md, docs/). Run setup first."
  exit 1
fi

CONTEXT_TOKENS=$((CONTEXT_LINES * 13 / 10))

echo "  Your Context Files"
echo "  ──────────────────"
printf "$CONTEXT_FILES\n"
echo "    ──────────"
echo "    Total: $CONTEXT_LINES lines (~$CONTEXT_TOKENS tokens)"
echo ""

# Calculate savings
if [ "$CONTEXT_TOKENS" -gt 0 ]; then
  # AI typically reads 15-25% of codebase per session, not 100%
  TYPICAL_EXPLORE=$((EXPLORE_TOKENS * 20 / 100))
  RATIO=$((TYPICAL_EXPLORE / CONTEXT_TOKENS))

  echo "  Estimated Savings"
  echo "  ─────────────────"
  echo "  Without Cortex:    ~$TYPICAL_EXPLORE tokens/session (AI explores ~20% of codebase)"
  echo "  With Cortex:       ~$CONTEXT_TOKENS tokens/session (AI reads context files)"
  echo "  Savings:           ~${RATIO}x fewer tokens per session"
  echo ""
  
  SESSIONS_PER_WEEK=10
  WEEKLY_SAVED=$((  (TYPICAL_EXPLORE - CONTEXT_TOKENS) * SESSIONS_PER_WEEK  ))
  MONTHLY_SAVED=$((WEEKLY_SAVED * 4))

  echo "  Monthly Impact (40 sessions)"
  echo "  ────────────────────────────"
  echo "  Tokens saved:      ~$MONTHLY_SAVED per month"
  echo ""
  echo "  On subscription plans (Cursor Pro, Claude Code Max), this means"
  echo "  fewer wasted requests and more of your usage cap going toward"
  echo "  real work instead of re-exploring your project."
  echo ""
fi
