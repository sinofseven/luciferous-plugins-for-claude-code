# kanban-kit のフック読み込みエラーを修正

## 目的
hookでエラーが出ると、ワークフローを正常に動かせないため。

## 要望
kanban-kitをプロジェクトに追加して使おうとしたら、hookのloadでエラーが出ました。修正してください。

## 完了サマリー

完了日時: 2026-04-22T17:02:44+09:00

### 原因

Claude Code プラグインの `hooks/hooks.json` は公式スキーマでトップレベルに `hooks` キーが必要だが、両プラグインのファイルは `UserPromptSubmit` がルートに直接あり、スキーマバリデーションで失敗していた。

### 対応内容

- `plugins/kanban-kit/hooks/hooks.json`: `UserPromptSubmit` を `hooks` キーでラップ
- `plugins/report-kit/hooks/hooks.json`: `UserPromptSubmit` を `hooks` キーでラップ
- `plugins/kanban-kit/.claude-plugin/plugin.json`: version `0.1.0` → `0.1.1`
- `plugins/report-kit/.claude-plugin/plugin.json`: version `0.1.0` → `0.1.1`

## エラーメッセージ
```txt
    /Users/yuta/.claude/plugins/cache/luciferous-plugins/kanban-kit/0.1.0/hooks/hooks.json:
     [
      {
        "expected": "record",
        "code": "invalid_type",
        "path": [
          "hooks"
        ],
        "message": "Invalid input: expected record, received undefined"
      }
    ]
```