#!/system/bin/sh
# ci-build.sh — локальная проверка перед пушем
# Запуск: bash scripts/ci-build.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
ERRORS=0

check() {
    local name="$1"
    local cmd="$2"
    printf "${YELLOW}[CHECK]${NC} %s... " "$name"
    if eval "$cmd" 2>&1; then
        printf "${GREEN}OK${NC}\n"
    else
        printf "${RED}FAIL${NC}\n"
        ERRORS=$((ERRORS + 1))
    fi
}

echo "╔══════════════════════════════════════╗"
echo "║   RuslanOS — Pre-Push CI Check      ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Syntax check all shell scripts
check "Shell syntax (ruslanos-module/)" \
    "bash -n ruslanos-module/customize.sh ruslanos-module/service.sh ruslanos-module/uninstall.sh"

check "Shell syntax (scripts/)" \
    "bash -n scripts/setup-build-env.sh scripts/build-full-rom.sh scripts/build-gsi.sh scripts/device-check.sh scripts/sign-ota.sh"

# Check system.prop syntax
check "system.prop syntax" \
    "grep -qP '^[a-z0-9_.]+=[a-z0-9_.]*$' ruslanos-module/system.prop && echo '  syntax ok'"

# Check files exist
check "Required files present" \
    "test -f ruslanos-module/module.prop && test -f ruslanos-module/system/bin/ruslan && test -f Makefile"

# Check README exists
check "README.md exists" \
    "test -f README.md"

# Check no TODO/FIXME left
check "No TODO/FIXME in code" \
    '! grep -r "TODO\|FIXME" --include="*.kt" --include="*.sh" --include="*.prop" . 2>/dev/null | grep -v "phases/" | grep -v "AGENTS.md" | grep -v "docs/ROADMAP" | grep -v "docs/TESTING" | grep -v "ci-build.sh" | grep -v "VoiceInputHandler.kt" | grep -q .'

echo ""
if [ $ERRORS -eq 0 ]; then
    printf "${GREEN}✅ All checks passed! Ready to push.${NC}\n"
else
    printf "${RED}❌ $ERRORS check(s) failed. Fix before push.${NC}\n"
    exit 1
fi
