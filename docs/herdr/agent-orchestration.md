# herdr で AI エージェントをオーケストレーションする

herdr の CLI（`pane` / `wait` / `agent` API）を使うと、`claude` などの AI コーディングエージェントを
**スクリプトから機械的に起動・タスク投入・完了検知・結果回収** できる。
「ターミナルを人間が触る」前提が外れ、エージェントを1つの実行ユニットとして束ねて回せる。

> 検証環境: herdr 0.7.4 / macOS
> pane ID の形式は `workspace:pane`（例: `w1:p2`）。`herdr pane list` で実際の ID を確認できる。

---

## 1. 基本の流れ

```bash
# 隣にペインを作る（フォーカスは奪わない）。返ってきた JSON から pane ID を取る
PANE=$(herdr pane split --current --direction right --no-focus | jq -r '.result.pane_id')

# その pane で claude を対話起動
herdr pane run "$PANE" "claude"

# claude のプロンプトが開くまで待ってからタスクを投入する（← 待機を挟むのが安全）
herdr wait output "$PANE" --match "?" --source recent-unwrapped --timeout 15000
herdr pane run "$PANE" "Issue #42 を実装して"

# ステータスを確認
herdr pane get "$PANE"

# 完了を待って結果を読む
herdr wait agent-status "$PANE" --status done
herdr pane read "$PANE" --source recent-unwrapped
```

### 使うコマンドの要点

| コマンド | 役割 | 補足 |
|---|---|---|
| `pane split [--current] --direction right\|down [--ratio F] [--focus\|--no-focus]` | ペインを分割して新規作成 | `--direction` は `right` / `down` のみ（`left/up` 不可） |
| `pane run <pane_id> <command>` | pane にコマンドを送って実行 | 対話 TUI 中に投げるとプロンプトへの入力＋実行として働く |
| `pane get <pane_id>` | pane の状態（agent_status 等）を取得 | |
| `pane read <pane_id> --source visible\|recent\|recent-unwrapped` | pane の出力を読み出す | `recent-unwrapped` は折り返し解除した最近の出力 |
| `pane list [--workspace <id>]` | 全 pane を JSON で列挙 | pane_id / agent / agent_status を確認できる |
| `wait agent-status <pane_id> --status <idle\|working\|blocked\|done\|unknown> [--timeout MS]` | エージェントの状態変化をブロッキング待機 | 完了検知に使う |
| `wait output <pane_id> --match <text> [--source ...] [--regex] [--timeout MS]` | 特定の出力が現れるまで待機 | プロンプト起動待ちなどに使う |

---

## 2. 運用上の注意点

1. **`pane run` を連続で使うときはタイミングに注意**
   `pane run "claude"` の直後に次の `pane run "タスク"` を投げると、プロンプトが起動途中で
   取りこぼす可能性がある。間に `herdr wait output ... --match` を挟んで起動を待つ。

2. **pane ID はハードコードせず返り値から取る**
   `split --no-focus` は新しい pane ID を返すので、`w1:p2` 決め打ちではなく
   `jq -r '.result.pane_id'` で拾う（`pane list` などの応答は JSON）。

3. **`--direction` は `right` / `down` のみ**
   左・上方向への分割はできない。

---

## 3. これで何ができるようになるか

### 3-1. 並列エージェント（マルチエージェント開発）
複数 pane にそれぞれ claude を起動し、別々の Issue を同時に振る。

```bash
for issue in 42 43 44; do
  P=$(herdr pane split --current --direction right --no-focus | jq -r '.result.pane_id')
  herdr pane run "$P" "claude"
  herdr wait output "$P" --match "?" --timeout 15000
  herdr pane run "$P" "Issue #$issue を実装して"
done
```
→ 複数の Issue を複数の claude が並行で着手。人間が張り付かなくても進む。

### 3-2. 完了検知と自動フォローアップ
`wait agent-status --status done` で「エージェントが手を止めた瞬間」を検知し、次処理へ繋げる。

```bash
herdr wait agent-status "$P" --status done
herdr pane read "$P" --source recent-unwrapped > result.txt
# 続けて「テスト書いて」「PR 出して」を自動投入、など
```

### 3-3. パイプライン化（CI 的な使い方）
「実装 → テスト → レビュー → PR」を段階ごとのタスクとして投げ、各段の `done` を待って次へ。
人間の承認ポイントだけ差し込む半自動フローが組める。

### 3-4. 監視・ダッシュボード
`pane get` / `pane list` で全エージェントの `agent_status`（idle/working/blocked/done）を
定期ポーリングし、「blocked（人間の入力待ち）になったものだけ通知」などの見張り役を作れる。

### 3-5. 結果の集約
各 pane の `pane read` で出力を吸い上げ、レポートにまとめる・Slack に流す、など。

---

## 4. まとめ

- **非同期・放置運用**: 投げて `wait` で待つ → 人間が張り付かなくていい
- **スケール**: エージェントの数 = pane の数。横に並べるだけで増やせる
- **自動化の連結**: シェル / Makefile / CI から呼べるので、既存ワークフローに「AI 実行ステップ」を差し込める

herdr が **AI エージェントのプロセスマネージャ／オーケストレータ** になり、
`claude` を実行ユニットとして束ねて回せる、というのが本質。
