# タスク 0008: add-kanban/add-report の I/O 削減 — ログファイル

**開始時刻**: 2026-04-28T16:31:00+09:00

## タスク概要

kanban-kit の add-kanban と report-kit の add-report スキルにおいて、採番のための `ls` 以外のファイル読み込みを明示的に禁止する。両スキルの SKILL.md に注意事項を追加し、Claude が独自判断でファイルを読みにいく挙動を防ぐ。

## 調査結果

### add-kanban スキル

**ファイルパス**: `/Users/yuta/space/private/luciferous-plugins-for-claude-code/plugins/kanban-kit/skills/add-kanban/SKILL.md`

**現状**:
- SKILL.md には手順1-7が記載されている
- 手順2（採番）では `ls kanban/ 2>/dev/null | grep -E '^[0-9]{4}_' | sort | tail -1` を実行するのみ
- 手順内には Read 系の記述なし、別ファイル参照なし
- 注意事項セクションは4項目（snake_case、日/英分離、/kanban の目的確認、git commit なし）
- **ファイル読み込みの明示的禁止は記載されていない**

### add-report スキル

**ファイルパス**: `/Users/yuta/space/private/luciferous-plugins-for-claude-code/plugins/report-kit/skills/add-report/SKILL.md`

**現状**:
- SKILL.md には手順1-5が記載されている
- 手順3（連番計算）では `ls reports/ 2>/dev/null | grep -E '^[0-9]{4}_' | sort | tail -1` を実行するのみ
- 手順内には Read 系の記述なし、別ファイル参照なし
- 注意事項セクションは2項目（ハイフン区切り、日/英分離、git commit なし）
- **ファイル読み込みの明示的禁止は記載されていない**

### 問題分析

ユーザーが「add-kanban で実装状況を確認しようとすることがたまにある」と述べているのは、手順書に明示的な禁止がないため、Claude が以下のような挙動を起こしている可能性を示唆している：

- 既存の kanban / reports ファイルを Read ツールで読み込んで「確認」する
- Glob / Grep で関連ファイルを探索する
- 実装前に周辺コードを読んで「参考」にしようとする

手順書上は必要ない操作だが、Claude の自由裁量により実行されている。対策は SKILL.md に明示的な禁止事項を追記することで、Claude の判断余地を削る。

### plugin.json バージョン確認

- kanban-kit: `0.1.2`
- report-kit: `0.1.2`

### 参考: kanban-workflow.md 

`references/kanban-workflow.md` では `/kanban` スキルのフェーズ2（実装）でログファイル作成を指示しており、本ログはその指示に従ったもの。

## 実装プラン

### 変更対象

1. **add-kanban SKILL.md** 注意事項セクション
   - 位置: 行 49-54（## 注意事項 から git commit は行わない まで）
   - 追加内容: 「採番のための `ls kanban/` 以外のファイル読み込み（Read / Glob / Grep 等）は一切行わないこと。引数（args）の内容のみに基づいてマークダウンを生成する。」を新規項目として追加

2. **add-report SKILL.md** 注意事項セクション
   - 位置: 行 66-70（## 注意事項 から git commit は行わない まで）
   - 追加内容: 「採番のための `ls reports/` 以外のファイル読み込み（Read / Glob / Grep 等）は一切行わないこと。$ARGUMENTS および対話で得た「知りたいこと」「目的」のみに基づいてマークダウンを生成する。」を新規項目として追加

3. **plugin.json バージョン更新**
   - kanban-kit: `0.1.2` → `0.1.3`
   - report-kit: `0.1.2` → `0.1.3`

### 実装戦略

各SKILL.md の注意事項セクションに新しい項目を挿入する。項目は「git commit は行わない」の前に配置し、既存項目との整合性を保つ。

plugin.json はバージョンのみ変更し、他は維持する。

### 利点

- SKILL.md に明示的な禁止事項を記載することで、Claude がスキル実行時に「ファイル読み込みをしてはいけない」と認識する
- 採番のための `ls` のみに許可を限定する明確な表現により、曖昧性を排除
- プロンプトインジェクション的な曖昧さを排除し、スキルの責務を明確化

## プランニング経緯

プランモード内で以下を確認：

1. Explore エージェント で両スキルの SKILL.md と plugin.json を調査
2. 調査結果から「現状はファイル読み込みの明示的禁止がない」と判定
3. 対策として SKILL.md に注意事項を追記する方針に決定
4. プラン承認後、フェーズ2で実装開始

ユーザーのフィードバック: 初回提案がそのまま承認された。

## 会話内容

### フェーズ1

1. **ユーザー指示**: 「kanban-kit の add-kanban と report-kit の add-report において、ユーザーの入力内容からマークダウンファイルの作成のみを行うようにしてほしい。採番するときを除いて別のファイルを読みにいかないようにして欲しい。」

2. **Claude 提案**: 
   - 両スキルの SKILL.md と plugin.json を Explore エージェント で調査
   - 調査結果から「現状のドキュメントにはファイル読み込みの明示的禁止がない」と認識
   - 対策として SKILL.md に注意事項を追記する計画を提示

3. **計画内容**:
   - add-kanban SKILL.md: 採番の `ls kanban/` 以外のファイル読み込み禁止を追記
   - add-report SKILL.md: 採番の `ls reports/` 以外のファイル読み込み禁止を追記
   - plugin.json: 0.1.2 → 0.1.3
   
4. **ユーザーのリジェクト/フィードバック**: なし。初回提案がそのまま承認された。

## 実装フェーズ

### 編集内容

#### 1. kanban-kit/skills/add-kanban/SKILL.md

ファイル: `/Users/yuta/space/private/luciferous-plugins-for-claude-code/plugins/kanban-kit/skills/add-kanban/SKILL.md`

**編集操作**: 注意事項セクション（行 49-54）に新規項目を追加

```markdown
- **採番のための `ls kanban/` 以外のファイル読み込み（Read / Glob / Grep 等）は一切行わないこと**。引数（args）の内容のみに基づいてマークダウンを生成する。
```

**理由**: 手順2で定められた採番コマンド以外にファイル読み込みを行わないことを明示的に禁止し、Claude が独自判断でファイルを読みにいく動作を防ぐ。

**結果**: ✓ 完了

#### 2. report-kit/skills/add-report/SKILL.md

ファイル: `/Users/yuta/space/private/luciferous-plugins-for-claude-code/plugins/report-kit/skills/add-report/SKILL.md`

**編集操作**: 注意事項セクション（行 66-70）に新規項目を追加

```markdown
- **採番のための `ls reports/` 以外のファイル読み込み（Read / Glob / Grep 等）は一切行わないこと**。$ARGUMENTS および対話で得た「知りたいこと」「目的」のみに基づいてマークダウンを生成する。
```

**理由**: 手順3で定められた連番計算コマンド以外にファイル読み込みを行わないことを明示的に禁止し、Claude が独自判断でファイルを読みにいく動作を防ぐ。

**結果**: ✓ 完了

#### 3. kanban-kit/.claude-plugin/plugin.json

ファイル: `/Users/yuta/space/private/luciferous-plugins-for-claude-code/plugins/kanban-kit/.claude-plugin/plugin.json`

**編集操作**: version フィールドを `0.1.2` → `0.1.3` に更新

**理由**: プラグインのバージョン更新ポリシーに従い、機能変更を反映。

**結果**: ✓ 完了

#### 4. report-kit/.claude-plugin/plugin.json

ファイル: `/Users/yuta/space/private/luciferous-plugins-for-claude-code/plugins/report-kit/.claude-plugin/plugin.json`

**編集操作**: version フィールドを `0.1.2` → `0.1.3` に更新

**理由**: プラグインのバージョン更新ポリシーに従い、機能変更を反映。

**結果**: ✓ 完了

### 判断・意思決定

**Q: 何か追加の更新（例: README.md、ドキュメント）は必要か？**
A: 不要。SKILL.md の注意事項が直接の実行指示であり、README は参考資料に過ぎない。必要に応じてユーザーが更新するもの。

**Q: 手順セクションも修正が必要か？**
A: 不要。手順セクション自体には Read 系の記述がなく、矛盾していない。注意事項で明示的に禁止することで充分。

## エラー・問題

なし。すべての編集が予定通り完了。

