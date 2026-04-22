# luciferous-plugins

Claude Code 向けプラグイン集。複数のプラグインを提供する Marketplace。

## 含まれるプラグイン

- **kanban-kit** (v0.1.0): Kanban ワークフロー一式（タスク追加・実行スキル、未完了リマインド hook）

## インストール

このリポジトリを Claude Code Plugin Marketplace として追加し、プラグインをインストールする:

```bash
/plugin marketplace add sinofseven/luciferous-plugins-for-claude-code
/plugin install kanban-kit@luciferous-plugins
```

または、ローカルパスから追加する場合:

```bash
/plugin marketplace add /Users/yuta/space/private/luciferous-plugins-for-claude-code
/plugin install kanban-kit@luciferous-plugins
```

### プラグイン詳細

各プラグインの詳細は `plugins/{plugin-name}/README.md` を参照。

## ライセンス

MIT License © sinofseven
