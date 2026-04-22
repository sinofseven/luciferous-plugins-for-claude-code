# add-kanban と add-report のモデル設定を修正

## 目的
modelの値の指定方法が間違えていたので修正したい

## 要望
`/add-kanban`と`/add-report`のFrontmatterで設定している modelの値を `haiku`に変更し、パッチバージョンをインクリメントしてください

## 完了サマリー
**完了日時**: 2026-04-22T19:22:58+09:00

### 実施内容
- ✅ `/add-kanban` スキル (SKILL.md) の Frontmatter: `model: Haiku` → `model: haiku`
- ✅ `/add-report` スキル (SKILL.md) の Frontmatter: `model: Haiku` → `model: haiku`
- ✅ kanban-kit プラグイン (plugin.json) のバージョン: `0.1.1` → `0.1.2`
- ✅ report-kit プラグイン (plugin.json) のバージョン: `0.1.1` → `0.1.2`

4 ファイルの修正をすべて完了し、grep による検証も全て成功しました。
