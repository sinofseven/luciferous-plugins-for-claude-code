#!/usr/bin/env bash
# report 未完了タスクチェック
# UserPromptSubmit hook として使用
# 未完了タスクがある場合はリマインドメッセージを stdout に出力し、Claude のコンテキストに挿入される

if [ -n "$CLAUDE_PROJECT_DIR" ]; then
    cd "$CLAUDE_PROJECT_DIR" || exit 0
fi

REPORT_DIR="reports"

if [ ! -d "$REPORT_DIR" ]; then
    exit 0
fi

incomplete=()
for dir in "$REPORT_DIR"/*/; do
    [ -d "$dir" ] || continue
    base="$(basename "$dir")"
    task_file="${dir}${base}.md"
    [ -f "$task_file" ] || continue
    if ! grep -q "## 完了サマリー" "$task_file"; then
        incomplete+=("$base")
    fi
done

if [ ${#incomplete[@]} -gt 0 ]; then
    echo "[report reminder] 未完了タスクがあります: ${incomplete[*]}"
    echo "作業が進んだら reports/{xxxx}_{title}/log.md へ記録し、完了時は report ファイルへ完了サマリーを追記してください。"
fi
