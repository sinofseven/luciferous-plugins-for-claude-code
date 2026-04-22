# kanban-kit

Claude Code 向け kanban ワークフロープラグイン。タスク管理に kanban 方式を採用したいプロジェクトで使用する。

## 提供する機能

| コンポーネント | 種別 | 内容 |
|---|---|---|
| `kanban` | スキル | kanban タスクをプランモードで計画→実装する |
| `add-kanban` | スキル | `kanban/` に新規タスクファイルを作成する |
| `check-kanban.sh` | hook | ユーザーのプロンプト送信時に未完了タスクをリマインドする |

## 前提

プロジェクトルートに `kanban/` ディレクトリを用意する。ディレクトリがない場合、hook は何も出力せずスキルも正常に動作する。

## 使い方

### タスクを追加する

```
/add-kanban
```

または引数付きで:

```
/add-kanban 要望: ログ出力を構造化したい 目的: 本番障害時の調査を効率化するため
```

タスクファイルが `kanban/{xxxx}_{title}/{xxxx}_{title}.md` に作成される。

### タスクを実行する

```
/kanban
```

未完了タスクのうち番号が最大のものを自動選択する。タスク番号を指定することもできる:

```
/kanban 0001
```

### ワークフローの流れ

1. `/add-kanban` でタスクファイルを作成（目的・要望を記載）
2. `/kanban` でタスクを実行
   - フェーズ1: プランモードで計画を立て、ユーザーが承認
   - フェーズ2: 承認後に実装し、`kanban/{xxxx}/log.md` にログを記録
3. 完了時にタスクファイルへ `## 完了サマリー` を追記

## プロジェクト CLAUDE.md への追記例

このプラグインを導入したプロジェクトでは、CLAUDE.md に以下を追記することを推奨する:

```markdown
## Kanban ワークフロー

タスク管理に kanban 方式を採用している。

- `kanban/{xxxx}_{title}/{xxxx}_{title}.md` にタスクファイルを配置する
- `kanban/{xxxx}_{title}/log.md` にログファイルが自動生成される（git 管理対象）
- **タスク開始時は `/kanban` スキルを使用すること**
- `/kanban` はまずプランモードで計画を立て、承認後に実装に移る
- **タスク作業中は、各ステップ完了時に必ずログファイルを更新すること**
- kanban ファイルへの追記時・ログへの記録時は JST タイムゾーンの ISO 8601 形式で日時を記載する
```

## インストール

### Marketplace 経由（推奨）

このプラグインは Luciferous Plugins Marketplace に登録されています。

```bash
/plugin marketplace add sinofseven/luciferous-plugins-for-claude-code
/plugin install kanban-kit@luciferous-plugins
```

### ローカルパス直指定

ローカルリポジトリから直接インストールする場合:

```bash
/plugin install /path/to/luciferous-plugins-for-claude-code/plugins/kanban-kit
```
