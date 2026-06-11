#!/bin/bash
# 自动推送下载的电子书到 GitHub
# 每 30 分钟检查一次，有新文件就推送

REPO_DIR="/Users/jason/Workspace/Tmp/downloads/dushupai"
LOG="/Users/jason/Workspace/Tmp/dushupai_push.log"

cd "$REPO_DIR" || exit 1

while true; do
    sleep 1800  # 30 分钟

    # 检查是否有新的 zip 文件
    new_files=$(git status --porcelain 2>/dev/null | grep '\.zip' | wc -l)

    if [ "$new_files" -gt 0 ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 发现 $new_files 个新文件，开始推送..." >> "$LOG"
        git add -A
        git commit -m "auto: $(date '+%Y-%m-%d %H:%M') +${new_files} books" >> "$LOG" 2>&1
        git push origin main >> "$LOG" 2>&1
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 推送完成" >> "$LOG"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 无新文件，跳过" >> "$LOG"
    fi
done
