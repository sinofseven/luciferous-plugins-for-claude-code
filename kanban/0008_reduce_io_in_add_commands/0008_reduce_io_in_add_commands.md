# add-kanban/add-report の I/O 削減

## 目的
add-kanban で実装状況を確認しようとすることがたまにある。add-kanban はあくまで言われた内容からマークダウンファイル生成を行うだけが目的なので、採番するときを除いて別のファイルを読みにいかないようにして欲しい。

## 要望
kanban-kit の add-kanban と report-kit の add-report において、ユーザーの入力内容からマークダウンファイルの作成のみを行うようにしてほしい。

## プラン

採番のための `ls` 以外のファイル読み込みを SKILL.md に明示的に禁止する。

### 対象ファイル
1. `plugins/kanban-kit/skills/add-kanban/SKILL.md` — 注意事項に禁止事項を追加
2. `plugins/report-kit/skills/add-report/SKILL.md` — 注意事項に禁止事項を追加
3. `plugins/kanban-kit/.claude-plugin/plugin.json` — version 0.1.2 → 0.1.3
4. `plugins/report-kit/.claude-plugin/plugin.json` — version 0.1.2 → 0.1.3

### 追記内容

**add-kanban SKILL.md** の注意事項に以下を追加:
- 採番のための `ls kanban/` 以外のファイル読み込み（Read / Glob / Grep 等）は一切行わないこと。args の内容のみでマークダウンを生成する。

**add-report SKILL.md** の注意事項に以下を追加:
- 採番のための `ls reports/` 以外のファイル読み込み（Read / Glob / Grep 等）は一切行わないこと。$ARGUMENTS および対話の内容のみでマークダウンを生成する。

## 完了サマリー

**完了日時**: 2026-04-28T16:35:00+09:00

### 実装内容

1. ✓ add-kanban SKILL.md に「採番のための `ls kanban/` 以外のファイル読み込みは一切行わないこと」を注意事項に追加
2. ✓ add-report SKILL.md に「採番のための `ls reports/` 以外のファイル読み込みは一切行わないこと」を注意事項に追加
3. ✓ kanban-kit plugin.json をバージョン 0.1.2 → 0.1.3 に更新
4. ✓ report-kit plugin.json をバージョン 0.1.2 → 0.1.3 に更新
5. ✓ ログファイルを作成し、調査結果・実装内容を記録

### 結果

両スキルの SKILL.md に明示的なファイル読み込み禁止事項を記載することで、Claude が採番以外のファイル読み込みを行わないようを厳密に指示した。これにより、add-kanban / add-report の責務が「args/対話から引き抜いた情報のマークダウン生成」に限定される。

### ログ参照

詳細は `kanban/0008_reduce_io_in_add_commands/log.md` を参照。
