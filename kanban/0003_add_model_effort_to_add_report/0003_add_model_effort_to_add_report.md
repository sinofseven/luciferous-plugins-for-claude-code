# /add-report スキルの model・effort 設定

## 目的
/add-report は大した処理をさせないので、modelとeffortを軽くしたい。 /add-kanban でできているので、同様にやってください。

## 要望
report-kitの `/add-report`で kanban-kitの `/add-kanban` のようにmodelとしてHaikuをeffortとしてmediumを使うようにしてください。

## プラン

`plugins/report-kit/skills/add-report/SKILL.md` の frontmatter に以下の 2 行を追加するだけ。

```yaml
effort: medium
model: Haiku
```

kanban-kit の `add-kanban` と同じ記法・値で揃える。

## 完了サマリー

- **完了日時**: 2026-04-22T15:59:33+09:00
- **対応内容**:
  - `plugins/report-kit/skills/add-report/SKILL.md` の frontmatter に `effort: medium` と `model: Haiku` を追加
- **変更ファイル**:
  - `plugins/report-kit/skills/add-report/SKILL.md`
