#!/usr/bin/env bats

# 各テストの前に一度だけ実行される
setup() {
  PROJECT_ROOT="$(cd "$(dirname "${BATS_TEST_DIRNAME}")/.." && pwd)"
  # detect_os.sh を読み込む（メインとして実行させず、関数だけ使う）
  # shellcheck source=/dev/null
  source "$PROJECT_ROOT/bootstrap/detect_os.sh"
}

@test "Darwin を mac と判定する" {
  # uname をモックする関数を定義
  uname() {
    echo "Darwin"
  }

  run detect_os
  [ "$status" -eq 0 ]
  [ "$output" = "mac" ]
}

@test "Linux を linux と判定する" {
  uname() {
    echo "Linux"
  }

  run detect_os
  [ "$status" -eq 0 ]
  [ "$output" = "linux" ]
}

@test "CYGWIN* を windows と判定する" {
  uname() {
    echo "CYGWIN_NT-10.0"
  }

  run detect_os
  [ "$status" -eq 0 ]
  [ "$output" = "windows" ]
}

@test "未知の文字列は unknown と判定する" {
  uname() {
    echo "SomethingElse"
  }

  run detect_os
  [ "$status" -eq 0 ]
  [ "$output" = "unknown" ]
}
