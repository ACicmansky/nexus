#!/usr/bin/env bash
# Behavior tests for bin/fm-theme.sh and extensible persona engine.
set -u

# shellcheck source=tests/lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

TMP_ROOT=$(fm_test_tmproot fm-theme)
THEME_HOME="$TMP_ROOT/home"
mkdir -p "$THEME_HOME/config"

test_script_parses() {
  local out rc
  out=$(bash -n "$ROOT/bin/fm-theme.sh" 2>&1); rc=$?
  expect_code 0 "$rc" "bash -n bin/fm-theme.sh must parse cleanly (got: $out)"
  [ -z "$out" ] || fail "bash -n bin/fm-theme.sh emitted unexpected output: $out"
  pass "fm-theme.sh: bash -n succeeds"
}

test_default_theme_is_nautical() {
  local out
  out=$(FM_HOME="$THEME_HOME" "$ROOT/bin/fm-theme.sh" current)
  [ "$out" = "nautical" ] || fail "default theme should be nautical (got: $out)"
  pass "fm-theme.sh: defaults to nautical when unconfigured"
}

test_all_personas_registered() {
  local count
  count=$(find "$ROOT/personas" -maxdepth 1 -name '*.md' | wc -l)
  [ "$count" -ge 18 ] || fail "expected at least 18 personas, found $count"
  pass "fm-theme.sh: all 18 core personas present in personas/"
}

test_theme_switching_and_attributes() {
  local title sup worker_ship worker_scout ack

  # Test Star Trek
  FM_HOME="$THEME_HOME" "$ROOT/bin/fm-theme.sh" set star-trek >/dev/null
  [ "$(FM_HOME="$THEME_HOME" "$ROOT/bin/fm-theme.sh" current)" = "star-trek" ] || fail "failed to set star-trek"
  title=$(FM_HOME="$THEME_HOME" "$ROOT/bin/fm-theme.sh" user-title)
  sup=$(FM_HOME="$THEME_HOME" "$ROOT/bin/fm-theme.sh" supervisor-role)
  worker_ship=$(FM_HOME="$THEME_HOME" "$ROOT/bin/fm-theme.sh" worker-role ship)
  worker_scout=$(FM_HOME="$THEME_HOME" "$ROOT/bin/fm-theme.sh" worker-role scout)
  ack=$(FM_HOME="$THEME_HOME" "$ROOT/bin/fm-theme.sh" idle-ack)

  [ "$title" = "Captain" ] || fail "star-trek title expected Captain (got $title)"
  [ "$sup" = "Number One" ] || fail "star-trek supervisor expected Number One (got $sup)"
  [ "$worker_ship" = "Engineering Officer" ] || fail "star-trek ship worker mismatch"
  [ "$worker_scout" = "Science Officer" ] || fail "star-trek scout worker mismatch"
  [ "$ack" = "Captain, all decks reporting nominal." ] || fail "star-trek idle ack mismatch"

  # Test Helldivers 2
  FM_HOME="$THEME_HOME" "$ROOT/bin/fm-theme.sh" set helldivers >/dev/null
  title=$(FM_HOME="$THEME_HOME" "$ROOT/bin/fm-theme.sh" user-title)
  sup=$(FM_HOME="$THEME_HOME" "$ROOT/bin/fm-theme.sh" supervisor-role)
  worker_ship=$(FM_HOME="$THEME_HOME" "$ROOT/bin/fm-theme.sh" worker-role ship)
  ack=$(FM_HOME="$THEME_HOME" "$ROOT/bin/fm-theme.sh" idle-ack)

  [ "$title" = "Commander" ] || fail "helldivers title expected Commander (got $title)"
  [ "$sup" = "Democracy Officer" ] || fail "helldivers supervisor expected Democracy Officer (got $sup)"
  [ "$worker_ship" = "Helldiver" ] || fail "helldivers ship worker mismatch"
  [ "$ack" = "Commander, Managed Democracy is secure." ] || fail "helldivers idle ack mismatch"

  pass "fm-theme.sh: theme switching and role attributes verified"
}

test_env_var_override() {
  local out
  out=$(FM_HOME="$THEME_HOME" FM_THEME=matrix "$ROOT/bin/fm-theme.sh" current)
  [ "$out" = "matrix" ] || fail "FM_THEME should override config/theme (got: $out)"
  pass "fm-theme.sh: FM_THEME overrides config/theme"
}

test_brief_intro_generation() {
  local intro
  intro=$(FM_HOME="$THEME_HOME" FM_THEME=helldivers "$ROOT/bin/fm-theme.sh" brief-intro ship)
  assert_contains "$intro" "You are a Helldiver: an autonomous worker agent managed by Democracy Officer." \
    "helldivers brief intro did not contain correct worker identity"
  pass "fm-theme.sh: brief-intro dynamically scaffolds role identity"
}

test_prompt_strips_frontmatter() {
  local prompt
  prompt=$(FM_HOME="$THEME_HOME" FM_THEME=helldivers "$ROOT/bin/fm-theme.sh" prompt)
  assert_contains "$prompt" "# Persona: Helldivers 2" "prompt missing markdown header"
  assert_not_contains "$prompt" "---" "prompt must not contain raw YAML frontmatter markers"
  assert_not_contains "$prompt" "idle_ack:" "prompt must not contain raw YAML frontmatter keys"
  pass "fm-theme.sh: prompt extracts clean markdown body without frontmatter"
}

test_script_parses
test_default_theme_is_nautical
test_all_personas_registered
test_theme_switching_and_attributes
test_env_var_override
test_brief_intro_generation
test_prompt_strips_frontmatter
