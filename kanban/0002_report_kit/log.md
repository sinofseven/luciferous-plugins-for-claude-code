# 0002_report_kit 作業ログ

## 基本情報

- **タスクファイル**: kanban/0002_report_kit/0002_report_kit.md
- **開始日時**: 2026-04-22T15:48:34+09:00
- **完了日時**: 2026-04-22T15:51:47+09:00

## タスク概要

いくつかの `/kanban` スキルを元に、ローカルのドキュメント調査用のプラグイン `report-kit` を作ってほしい。

## 調査結果

### `plugins/kanban-kit/.claude-plugin/plugin.json`

```json
{
  "name": "kanban-kit",
  "version": "0.1.0",
  "description": "Kanban ワークフロー一式（タスク追加・実行スキル、未完了リマインド hook）を提供するプラグイン",
  "author": { "name": "sinofseven" },
  "homepage": "https://github.com/sinofseven/luciferous-plugins-for-claude-code",
  "repository": "https://github.com/sinofseven/luciferous-plugins-for-claude-code",
  "license": "MIT",
  "keywords": ["kanban", "task-management", "workflow"]
}
```

plugin.json の構造確認。author.name / homepage / repository / license の形式が分かった。

### `plugins/kanban-kit/hooks/hooks.json`

```json
{
  "UserPromptSubmit": [
    {
      "matcher": "",
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/check-kanban.sh"
        }
      ]
    }
  ]
}
```

`UserPromptSubmit` イベントでスクリプトを呼び出す構造。`${CLAUDE_PLUGIN_ROOT}` 変数を使用。

### `plugins/kanban-kit/hooks/check-kanban.sh`

```bash
#!/usr/bin/env bash
if [ -n "$CLAUDE_PROJECT_DIR" ]; then
    cd "$CLAUDE_PROJECT_DIR" || exit 0
fi
KANBAN_DIR="kanban"
# kanban/{xxxx}_{title}/ ディレクトリ形式
for dir in "$KANBAN_DIR"/*/; do
    base="$(basename "$dir")"
    task_file="${dir}${base}.md"
    if ! grep -q "## 完了サマリー" "$task_file"; then
        incomplete+=("$base")
    fi
done
echo "[kanban reminder] 未完了タスクがあります: ${incomplete[*]}"
echo "作業が進んだら kanban/{xxxx}_{title}/log.md へ記録..."
```

kanban-kit はすでにディレクトリ形式 `kanban/{xxxx}_{title}/{xxxx}_{title}.md` に対応している。`$CLAUDE_PROJECT_DIR` でプロジェクトルートに cd してからディレクトリ探索している。

### `plugins/kanban-kit/skills/add-kanban/SKILL.md`（kanban-kit 開発用）

- frontmatter: `name: add-kanban`, `effort: medium`, `model: Haiku`
- 採番: `ls kanban/ 2>/dev/null | grep -E '^[0-9]{4}_' | sort | tail -1` で最大番号取得。出力が空なら `0001` 開始
- ファイル生成先: `kanban/{xxxx}_{title}/{xxxx}_{title}.md`（ディレクトリ形式）
- テンプレート: `## 目的` / `## 要望` の2セクション
- git 連携なし
- `/kanban` 起動: AskUserQuestion で確認してから Skill tool で起動

### `plugins/kanban-kit/skills/kanban/SKILL.md`（kanban-kit 開発用）

- frontmatter: `name: kanban`
- 対象ファイル: `kanban/{xxxx}_{title}/{xxxx}_{title}.md`
- ログ: `kanban/{xxxx}_{title}/log.md`
- 目的セクションが**ない場合**: プランモードに入らず終了
- プランモード（EnterPlanMode / ExitPlanMode）あり
- コーディング・実装作業フォーカス
- git commit 自動実行しない
- references: `references/kanban-workflow.md`

### `slack_docs/.claude/skills/add-kanban/SKILL.md`（ドキュメント調査用）

- frontmatter: `name: add-kanban`, `argument-hint: [title]`
- git pull 実行（手順0）、失敗時 `temp-kanban/` へ退避
- 採番: Glob `kanban/[0-9][0-9][0-9][0-9]_*.md`、`0000` 開始
- ファイル生成先: `kanban/{padded}_{title}.md`（フラットファイル形式）
- テンプレート: `## 知りたいこと` / `## 目的` の2セクション
- `/kanban` 自動起動（確認なし、git pull 成功時のみ）

### `slack_docs/.claude/skills/kanban/SKILL.md`（ドキュメント調査用）

- frontmatter: `name: kanban`, `argument-hint: [task-number-or-filename]`
- 対象ファイル: `kanban/{xxxx}_{title}.md`（フラットファイル形式）
- ログ: `logs/{xxxx}_{title}.md`
- 目的セクションが**ない場合**: 確認の上続行可能（柔軟）
- プランモードなし（調査タスク）
- ドキュメント調査フォーカス
- git commit & push あり（手順6）
- references: `$HOME/.claude/skills/kanban/references/kanban-workflow.md`

### `slack_docs/.claude/skills/kanban/references/kanban-workflow.md`（ドキュメント調査用）

- フラットファイル形式 `kanban/{xxxx}_{title}.md` と `logs/{xxxx}_{title}.md`
- kanban ファイルテンプレートに `## 知りたいこと` と `## 目的`
- 完了サマリーに「調査サマリー」と「完了サマリー」の2段構成
- ログには「調査ファイル一覧」「調査結果」「調査アプローチ」「会話内容」「判断・意思決定」「問題・疑問点」

### `slack_docs/.claude/hooks/check-kanban.sh`（ドキュメント調査用）

- フラットファイル形式 `kanban/*.md` を検索
- `$CLAUDE_PROJECT_DIR` への cd なし
- ログ参照先として `logs/` に言及

### `.claude-plugin/marketplace.json`（リポジトリルート）

```json
{
  "name": "luciferous-plugins",
  "plugins": [
    {
      "name": "kanban-kit",
      "source": "./plugins/kanban-kit",
      "description": "...",
      "category": "productivity",
      "keywords": ["kanban", "task-management", "workflow"]
    }
  ]
}
```

`plugins` 配列に追記する形式が確認できた。

## 実装プラン

### 方針確定（ユーザー確認済み）

- Marketplace 登録: このタスクで同時に行う
- move-report スキル: 含めない（add-report / report の 2 つのみ）
- git 連携: 全て削除（pull/commit/push 不要）
- スキル名: `/kanban` → `/report`、`/add-kanban` → `/add-report`
- ディレクトリ: `kanban/` → `reports/`

### 作成ファイル一覧

| ファイル | 方針 |
|---------|------|
| `plugins/report-kit/.claude-plugin/plugin.json` | kanban-kit の json 構造を踏襲、name/description を変更 |
| `plugins/report-kit/hooks/check-report.sh` | kanban-kit の check-kanban.sh から KANBAN_DIR/メッセージを report に変更 |
| `plugins/report-kit/hooks/hooks.json` | kanban-kit の hooks.json から check-report.sh に変更 |
| `plugins/report-kit/skills/add-report/SKILL.md` | slack_docs の add-kanban をベースに: git 削除、ディレクトリ形式変更、スキル名変更 |
| `plugins/report-kit/skills/report/SKILL.md` | slack_docs の kanban をベースに: git 削除、ディレクトリ形式変更、スキル名変更 |
| `plugins/report-kit/skills/report/references/report-workflow.md` | slack_docs の kanban-workflow.md をベースに: パス変更 |
| `plugins/report-kit/README.md` | 新規作成 |
| `.claude-plugin/marketplace.json` | report-kit エントリを追記 |

### add-report と report スキルの主な変更点

**add-report**:
- git pull（手順0）削除
- temp-kanban/ 退避ロジック削除
- ファイル生成先: `reports/{padded}_{title}/{padded}_{title}.md`（ディレクトリ形式）
- 採番: `ls reports/ 2>/dev/null | grep -E '^[0-9]{4}_' | sort | tail -1`（kanban-kit 形式）
- 開始番号: `0000` → `0001`
- `/report` 起動: AskUserQuestion で確認（kanban-kit 方式に近い）

**report**:
- ファイルパス: `reports/{xxxx}_{title}/{xxxx}_{title}.md`
- ログパス: `reports/{xxxx}_{title}/log.md`
- 未完了タスク検出: `reports/{xxxx}_{title}/{xxxx}_{title}.md` を検索
- 目的セクションなし → 続行確認（slack_docs 方式を維持）
- git commit/push（手順6）削除
- 調査タスクフォーカス（プランモードなし）
- references 参照: `references/report-workflow.md`

**report-workflow.md**:
- kanban → report、kanban/ → reports/ に置換
- ファイルパス表記を全て更新

## プランニング経緯

### 初回提案

- Marketplace 登録 / move-kanban 含む / git 連携残す を提案
- 「ディレクトリ構成は kanban-kit、内容は slack_docs ベース」

### ユーザーフィードバック（1回目）

- Marketplace 登録: 同時に行う → そのまま採用
- move-kanban: 含めない → 削除
- git 連携: 外す → 削除

### ユーザーフィードバック（2回目・リジェクト）

- スキル名 `/kanban` → `/report`、`/add-kanban` → `/add-report` に変更
- ディレクトリ `kanban/` → `reports/` に変更

### 最終プランへの変更

全てのスキル名とディレクトリ参照を report/reports に置換して再提案。承認された。

## 会話内容

### [15:40頃] ユーザー指示

「/kanban 0002 を実行してほしい」（kanban スキルを 0002 タスクで起動）

### [15:41頃] Claude 調査

kanban-kit と slack_docs の各スキルファイルを読み込み、差分を分析。

### [15:45頃] Claude プラン提案（1回目）

Marketplace 登録を含む、move-kanban あり、git 連携あり のプランを提示。

### [15:45頃] ユーザーによる選択

- Marketplace: 同時に行う
- move-kanban: 含めない
- git 連携: 外す

### [15:46頃] Claude プラン提案（2回目）

git 連携削除・move-kanban 除外 で再提案。

### [15:46頃] ユーザーによるリジェクト

「スキルは `/kanban` を `/report`, `/add-kanban` を `/add-report` に変更、ディレクトリも `kanban/` → `reports/` に変更してほしい」

### [15:47頃] Claude プラン提案（3回目）

スキル名・ディレクトリ名を全て変更して再提案。承認された。

## 編集したファイル

| ファイル | 変更内容 |
|---------|---------|
| `kanban/0002_report_kit/0002_report_kit.md` | `## プラン` セクション追記 |
| `kanban/0002_report_kit/log.md` | 新規作成（本ファイル） |
| `plugins/report-kit/.claude-plugin/plugin.json` | 新規作成 |
| `plugins/report-kit/hooks/check-report.sh` | 新規作成 |
| `plugins/report-kit/hooks/hooks.json` | 新規作成 |
| `plugins/report-kit/skills/add-report/SKILL.md` | 新規作成 |
| `plugins/report-kit/skills/report/SKILL.md` | 新規作成 |
| `plugins/report-kit/skills/report/references/report-workflow.md` | 新規作成 |
| `plugins/report-kit/README.md` | 新規作成 |
| `.claude-plugin/marketplace.json` | `report-kit` エントリ追記 |

## 実行したコマンド

```bash
TZ=Asia/Tokyo date +"%Y-%m-%dT%H:%M:%S+09:00"
# → 2026-04-22T15:48:34+09:00

jq empty plugins/report-kit/.claude-plugin/plugin.json
jq empty plugins/report-kit/hooks/hooks.json
jq empty .claude-plugin/marketplace.json
# → 全て OK

bash plugins/report-kit/hooks/check-report.sh
# → 出力なし（reports/ ディレクトリ未作成のため正常）
```

## 判断・意思決定

- `check-report.sh` は kanban-kit 版をベースに report/reports 置換で作成（slack_docs 版は cd なし・フラットファイル形式で不適）
- add-report の `/report` 起動: AskUserQuestion で確認してから起動（kanban-kit 方式を採用。slack_docs の自動起動より明示的）
- report SKILL.md の description は日本語・英語を混在させず、kanban-kit に近い形式で記述

## エラー・問題

- なし
