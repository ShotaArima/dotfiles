#!/usr/bin/env bash
set -eu

detect_os() {
  case "$(uname -s)" in
    Darwin)
      echo "mac"
      ;;
    Linux)
      echo "linux"
      ;;
    CYGWIN*|MINGW*|MSYS*)
      echo "windows"
      ;;
    *)
      echo "unknown"
      ;;
  esac
}

# スクリプトとして直接実行されたときは検出結果を表示
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  detect_os
fi
