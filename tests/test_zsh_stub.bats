#!/usr/bin/env bats

setup() {
  PROJECT_ROOT="$(cd "$(dirname "${BATS_TEST_DIRNAME}")/.." && pwd)"
  TEST_HOME="$BATS_TMPDIR/home"
  mkdir -p "$TEST_HOME"

  # 疑似 HOME に dotfiles を展開（今回はマウントされてるだけでもOK）
  DOTFILES="$PROJECT_ROOT"

  # テスト用の .zshrc をリンク
  ln -s "$DOTFILES/bootstrap/stub.zshrc" "$TEST_HOME/.zshrc"
  ln -s "$DOTFILES/bootstrap/stub.zprofile" "$TEST_HOME/.zprofile"
}

@test ".zshrc stub を zsh で読み込める" {
  run env HOME="$TEST_HOME" DOTFILES="$PROJECT_ROOT" zsh -i -c 'echo $DOTFILES'
  [ "$status" -eq 0 ]
  [ "$output" = "$PROJECT_ROOT" ]
}

# @test ".zprofile stub を zsh で読み込める" {
#   run env HOME="$TEST_HOME" DOTFILES="$PROJECT_ROOT" zsh -i -c 'echo $DOTFILES'
#   [ "$status" -eq 0 ]
#   [ "$output" = "$PROJECT_ROOT" ]
# }

