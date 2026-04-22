# Claude Code Plugin Marketplace化

## 目的
開発に使っているkanban-kit pluginを配布できるようにしたい

## 要望
このリポジトリをClaude CodeのPluginのMarketplaceとして機能するようにして欲しい

## 完了サマリー

**完了日時**: 2026-04-22T14:22:30+09:00

**実装内容**:

1. `.claude-plugin/marketplace.json` を新規作成
   - Marketplace 名: `luciferous-plugins`
   - Owner: `sinofseven`
   - kanban-kit プラグインをエントリ登録

2. `plugins/kanban-kit/.claude-plugin/plugin.json` を補強
   - author, homepage, license, keywords を追加
   - author は `sinofseven` で owner と統一

3. ルート `README.md` を更新
   - Marketplace 説明、プラグイン一覧、インストール手順（GitHub 経由＋ローカルパス）を記載

4. `plugins/kanban-kit/README.md` のインストール部を更新
   - Marketplace 経由（推奨）と ローカルパス直指定（開発用）の 2 手順を記載

**検証**: `jq empty` で marketplace.json と plugin.json の JSON 正当性を確認 → 両者とも成功

**次ステップ**: 本 Marketplace は以下のいずれかの形で利用可能
- ローカルパス指定: `/plugin marketplace add /Users/yuta/space/private/luciferous-plugins-for-claude-code`
- GitHub 経由（push 後）: `/plugin marketplace add sinofseven/luciferous-plugins-for-claude-code`
- その後 `/plugin install kanban-kit@luciferous-plugins` でプラグインをインストール
