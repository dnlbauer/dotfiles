#!/bin/bash
# Read JSON input from stdin
input=$(cat)

get_model_name() { echo "$input" | jq -r '.model.display_name'; }
get_current_dir() { echo "$input" | jq -r '.workspace.project_dir'; }
get_git_branch() {
    branch=""
    if git rev-parse --git-dir > /dev/null 2>&1; then
        branch=$(git branch --show-current 2>/dev/null)
    fi
    echo $branch;
}
get_transcript_path() { echo "$input" | jq -r '.transcript_path'; }
get_context_length() {
    local transcript_path=$(get_transcript_path)
    if [ -f "$transcript_path" ]; then
        local last_usage=$(tail -n 50 "$transcript_path" | grep '"usage"' | tail -n 1)
        if [ -n "$last_usage" ]; then
            local input_tokens=$(echo "$last_usage" | jq -r '.message.usage.input_tokens // 0')
            local cache_read=$(echo "$last_usage" | jq -r '.message.usage.cache_read_input_tokens // 0')
            local cache_creation=$(echo "$last_usage" | jq -r '.message.usage.cache_creation_input_tokens // 0')
            local total_tokens=$((input_tokens + cache_read + cache_creation))
            local tokens_k=$((total_tokens / 1000))
            local percentage=$((total_tokens * 100 / 200000))
            echo "Ctx: ${tokens_k}k (${percentage}%)"
        else
            echo "Ctx: 0k (0%)"
        fi
    else
        echo "0k (0%)"
    fi
}

MODEL_DISPLAY=$(get_model_name)
CURRENT_DIR=$(get_current_dir)
GIT_BRANCH=$(get_git_branch)
TRANSCRIPT_PATH=$(get_transcript_path)
CONTEXT_LENGTH=$(get_context_length)

if [ -n "$GIT_BRANCH" ]; then
    echo "$MODEL_DISPLAY | $CONTEXT_LENGTH | ${CURRENT_DIR##*/} | $(printf '\uE0A0') $GIT_BRANCH"
else
    echo "$MODEL_DISPLAY | $CONTEXT_LENGTH | ${CURRENT_DIR##*/}"
fi
