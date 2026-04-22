# ドキュメント探索プラグイン report-kit

## 目的
開発用の `/kanban` スキルを元にローカルのドキュメント調査用の `/kanban` スキルを作って使ってきた。今回ドキュメント探索用のプラグインにしたい。

## 要望
いくつかの `/kanban` スキルを元に、ローカルのドキュメント調査用のプラグイン `report-kit` を作ってほしい。

## 参照
- `/Users/yuta/space/private/luciferous-plugins-for-claude-code/plugins/kanban-kit`
  - 開発用途の`/kanban`スキル等のplugin
- `/Users/yuta/space/work/slack_enterprise_search/01_docs/slack_docs`
  - ローカルのドキュメント調査用に調整した `/kanban`スキル等を使っているディレクトリ
 
## 開発方針
入出力に使うカンバン用やログ用のマークダウンファイルを設置するディレクトリ構成は開発用途のものを使って欲しい。
それ以外はローカルのドキュメント調査用に調整したものをベースにしてほしい。

## プラン

- 作成するプラグイン: `plugins/report-kit/`
- スキル名: `/add-report`（起票）、`/report`（実行）
- 管理ディレクトリ: `reports/{xxxx}_{title}/`（kanban-kit のディレクトリ形式に準拠）
- ログ: `reports/{xxxx}_{title}/log.md`

### 作成ファイル

1. `plugins/report-kit/.claude-plugin/plugin.json`
2. `plugins/report-kit/hooks/check-report.sh` — `kanban-kit` の check-kanban.sh を流用し `kanban/` → `reports/` 置換
3. `plugins/report-kit/hooks/hooks.json`
4. `plugins/report-kit/skills/add-report/SKILL.md` — slack_docs の add-kanban を元に git 連携削除・ディレクトリ形式・スキル名変更
5. `plugins/report-kit/skills/report/SKILL.md` — slack_docs の kanban を元に git 連携削除・ディレクトリ形式・スキル名変更
6. `plugins/report-kit/skills/report/references/report-workflow.md` — slack_docs の kanban-workflow.md を元にパス変更
7. `plugins/report-kit/README.md`
8. `.claude-plugin/marketplace.json` に `report-kit` を追記

## 完了サマリー

- **完了日時**: 2026-04-22T15:51:47+09:00
- **対応内容**:
  - `plugins/report-kit/` プラグインを新規作成
  - スキル: `/add-report`（起票）、`/report`（実行）
  - ディレクトリ形式: `reports/{xxxx}_{title}/` で report ファイルとログを管理
  - hooks: `check-report.sh` で未完了タスクリマインド
  - `.claude-plugin/marketplace.json` に `report-kit` を登録
- **変更ファイル**:
  - `plugins/report-kit/.claude-plugin/plugin.json`（新規）
  - `plugins/report-kit/hooks/check-report.sh`（新規）
  - `plugins/report-kit/hooks/hooks.json`（新規）
  - `plugins/report-kit/skills/add-report/SKILL.md`（新規）
  - `plugins/report-kit/skills/report/SKILL.md`（新規）
  - `plugins/report-kit/skills/report/references/report-workflow.md`（新規）
  - `plugins/report-kit/README.md`（新規）
  - `.claude-plugin/marketplace.json`（更新）