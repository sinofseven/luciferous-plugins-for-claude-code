# add スキル後に正しいタスクを実行する修正

## 目的

`/add-kanban` でタスクを作成した直後に `/kanban` を実行すると、作成したタスク（例：0003）ではなく別のタスク（例：0002）が実行されてしまう問題がある。作成したばかりのタスクをそのまま実行するワークフローが壊れているため、修正が必要。kanban-kit で起きているということは report-kit でも同様の問題が起きると考えられるので、kanban-kit の修正方針を元に report-kit も同様に修正する。

## 要望

`/add-kanban` でカンバンを作らせた後、即座に `/kanban` を実行させるときに、きちんと作成したカンバンを実行するようにして欲しい。kanban-kit と report-kit（`/add-report` → `/report`）の両方を修正すること。

## プラン

以下の 4 ファイルの SKILL.md を修正する（ドキュメント文面強化）:

1. **`plugins/kanban-kit/skills/kanban/SKILL.md`** — `## 引数` セクションを修正
   - args 指定時: 対象タスクに `## 完了サマリー` があれば「実行済み」と報告して終了
   - args 空のときのみ未完了タスクの最大番号フォールバックを使う

2. **`plugins/kanban-kit/skills/add-kanban/SKILL.md`** — 手順7を修正
   - `args` に採番した実際の番号（例: `"0004"`）を文字列で渡すことを明示
   - プレースホルダー `{xxxx}` は必ず置換することを明記

3. **`plugins/report-kit/skills/report/SKILL.md`** — `## 引数` セクションを修正（kanban と同様）

4. **`plugins/report-kit/skills/add-report/SKILL.md`** — 手順5を修正（add-kanban と同様）

## 完了サマリー

完了日時: 2026-04-22T16:14:53+09:00

以下の 4 ファイルの SKILL.md を修正した:

1. `plugins/kanban-kit/skills/kanban/SKILL.md` — `## 引数` セクション修正。args 指定時はその番号を対象とし、完了サマリーがあれば「実行済み」と報告して終了するよう明記。フォールバックは args 未指定時のみ。
2. `plugins/kanban-kit/skills/add-kanban/SKILL.md` — 手順7修正。`args` に実際の4桁番号を文字列で渡すことを必須化し、具体例（`args: "0004"`）と警告を追加。
3. `plugins/report-kit/skills/report/SKILL.md` — kanban と同様の修正を `## 引数` セクションに適用。
4. `plugins/report-kit/skills/add-report/SKILL.md` — add-kanban と同様の修正を手順5に適用。
