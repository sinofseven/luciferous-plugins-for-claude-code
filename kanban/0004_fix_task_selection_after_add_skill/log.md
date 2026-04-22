# 作業ログ: 0004 add スキル後に正しいタスクを実行する修正

開始時刻: 2026-04-22T16:13:28+09:00
完了時刻: 2026-04-22T16:14:53+09:00

---

## タスク概要

`/add-kanban` でカンバンを作らせた後、即座に `/kanban` を実行させるときに、きちんと作成したカンバンを実行するようにして欲しい。kanban-kit と report-kit（`/add-report` → `/report`）の両方を修正すること。

---

## 調査結果

### `plugins/kanban-kit/skills/add-kanban/SKILL.md`（47行目）

手順7に以下の記述がある:
```
7. **`/kanban` 起動**: ユーザーが「はい」を選んだ場合、Skill ツールで `kanban` スキルを `args: "{xxxx}"` 指定（作成した番号）で起動する。
```

- `{xxxx}` はプレースホルダーだが、これを実際の番号に置換することが明示されていない
- Claude がこの文言を「プレースホルダー文字列をそのまま渡す」と解釈すると症状が出る
- または `args` を省略してしまうケースも起きうる

### `plugins/kanban-kit/skills/kanban/SKILL.md`（10-11行目）

```
skill tool の args パラメータに値が渡された場合、その値をタスク番号またはファイル名として解釈する（例: `0001` または `0001_add-feature`）。
args が空・未指定の場合は、`kanban/{xxxx}_{title}/{xxxx}_{title}.md` のうち `## 完了サマリー` を含まないものから番号が最大のタスクを自動選択する。
```

- 「解釈する」だけで、完了状態の確認・エラーハンドリングが書かれていない
- args が渡されたときに「完了済みかどうか確認する」動作が未定義
- フォールバック（最大番号選択）は「args が空のみ」であることが弱い

### `plugins/report-kit/skills/add-report/SKILL.md`（64行目）

kanban と同じ設計:
```
ユーザーが「はい」を選んだ場合、Skill ツールで `report` スキルを `args: "{xxxx}"` 指定（作成した番号）で起動する。
```

### `plugins/report-kit/skills/report/SKILL.md`（11-14行目）

```
$ARGUMENTS
引数としてタスク番号またはファイル名を指定できます（例: `0001` または `0001_research-topic`）。
引数がない場合は、`reports/` 内の未完了タスク（`## 完了サマリー` を含まないファイル）のうち番号が最大のものを自動選択します。
```

- kanban と同様の問題がある（args 指定時の完了確認が不明確）

### 既存 kanban タスクの状態

- `kanban/0001_*`、`kanban/0002_*`、`kanban/0003_*` は全て `## 完了サマリー` を含む完了済み
- `kanban/0004_*`（本タスク）は未完了

### 根本原因の推定

1. `add-kanban` が Skill ツール呼び出し時に `args` に正しい番号を渡さないケースが起きる
2. `kanban` スキルが args を受け取れなかった場合（または空文字列になった場合）、フォールバックで「未完了タスクの最大番号」を選択
3. 結果として作成直後の 0003 ではなく、0002（当時未完了だった可能性）が実行される

---

## 実装プラン

1. `plugins/kanban-kit/skills/kanban/SKILL.md` の `## 引数` セクションを修正
   - args 指定時: そのタスクを対象とし、完了サマリーがあれば「実行済み」と報告して終了
   - args 空: 未完了タスクの最大番号フォールバック（現行維持）
2. `plugins/kanban-kit/skills/add-kanban/SKILL.md` の手順7を修正
   - 具体例（例: `args: "0004"`）を追加、プレースホルダーの置換が必須であることを明示
3. `plugins/report-kit/skills/report/SKILL.md` の `## 引数` セクションを修正（kanban と同様）
4. `plugins/report-kit/skills/add-report/SKILL.md` の手順5を修正（add-kanban と同様）

---

## プランニング経緯

最初の提案では「args 指定時は完了状態に関わらず実行する」方針だったが、ユーザーから「args で番号を受け取ったとき、完了サマリーがあれば実行済みと言って終了するようにしてください」というフィードバックを受け、最終プランに反映した。

---

## 会話内容

1. ユーザーが `/add-kanban` → `/kanban` で作成したタスクではなく別のタスクが実行される問題を報告
2. 「修正方針ではなく、kanbanの中で調査修正してほしい」と言われ、kanban タスク 0004 を作成
3. プランモードで 4 つの SKILL.md を調査し、原因を特定
4. 初回プランを提示。args 指定時の完了確認動作についてユーザーから修正要求
5. 「args で完了サマリーがあれば実行済みと言って終了」に修正し承認を取得

---

## 編集したファイル

- [x] plugins/kanban-kit/skills/kanban/SKILL.md — `## 引数` セクションを修正。args 指定時の完了確認と終了動作を追加
- [x] plugins/kanban-kit/skills/add-kanban/SKILL.md — 手順7を修正。実際の番号を args に渡すことを明示、具体例と警告を追加
- [x] plugins/report-kit/skills/report/SKILL.md — `## 引数` セクションを修正（kanban と同様）
- [x] plugins/report-kit/skills/add-report/SKILL.md — 手順5を修正（add-kanban と同様）

---

## 実行したコマンド

（なし）

---

## 判断・意思決定

- report/SKILL.md の `$ARGUMENTS` プレースホルダー行（11行目）は削除しない（既存 report-kit スタイルを維持）
- kanban-workflow.md は今回修正しない（参考資料のみ、args 処理の主仕様は SKILL.md にある）

---

## エラー・問題

（なし）
