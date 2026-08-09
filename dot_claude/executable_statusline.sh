#!/bin/bash
# Read JSON input from stdin
input=$(cat)

# \u2500\u2500 helpers \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500

get_current_dir() {
    local dir
    dir=$(echo "$input" | jq -r '.workspace.project_dir // .cwd // ""')
    # Bold white
    printf '\033[1;37m%s\033[0m' "${dir##*/}"
}

get_model_effort() {
    local model effort thinking
    model=$(echo "$input" | jq -r '.model.display_name // ""')
    effort=$(echo "$input" | jq -r '.effort.level // ""')
    thinking=$(echo "$input" | jq -r '.thinking.enabled // false')

    # Bold magenta model name; dim+italic tag
    local colored_model
    colored_model=$(printf '\033[1;35m%s\033[0m' "$model")
    if [ -n "$effort" ]; then
        printf '%s \033[0m[%s]' "$colored_model" "$effort"
    elif [ "$thinking" = "true" ]; then
        printf '%s \033[0m[thinking]' "$colored_model"
    else
        printf '%s' "$colored_model"
    fi
}

get_context() {
    local used
    used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
    if [ -z "$used" ]; then
        echo "Ctx: -"
        return
    fi

    # Read raw token counts
    local used_tokens max_tokens
    used_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
    max_tokens=$(echo "$input"  | jq -r '.context_window.context_window_size // empty')

    # Format a raw number as e.g. 85k or 1.2M
    fmt_tokens() {
        local n="$1"
        if [ -z "$n" ] || [ "$n" = "null" ]; then
            echo "?"
            return
        fi
        awk -v n="$n" 'BEGIN {
            if (n >= 1000000) {
                v = n / 1000000
                # one decimal place, strip trailing .0
                s = sprintf("%.1f", v)
                sub(/\.0$/, "", s)
                print s "M"
            } else if (n >= 1000) {
                v = n / 1000
                s = sprintf("%.1f", v)
                sub(/\.0$/, "", s)
                print s "k"
            } else {
                print n
            }
        }'
    }

    local used_fmt max_fmt
    used_fmt=$(fmt_tokens "$used_tokens")
    max_fmt=$(fmt_tokens "$max_tokens")

    # Build a 20-cell wide loading bar
    local bar_width=20
    local filled
    filled=$(printf "%.0f" "$(echo "$used $bar_width" | awk '{printf "%f", $1 * $2 / 100}')")
    # Clamp to [0, bar_width]
    [ "$filled" -lt 0 ] && filled=0
    [ "$filled" -gt "$bar_width" ] && filled=$bar_width
    local empty=$(( bar_width - filled ))

    # Pick fill colour: green <=60, yellow <=80, red >80
    local fill_color
    if awk "BEGIN {exit !($used <= 60)}"; then
        fill_color='\033[32m'      # green
    elif awk "BEGIN {exit !($used <= 80)}"; then
        fill_color='\033[33m'      # yellow
    else
        fill_color='\033[31m'      # red
    fi

    local filled_bar="" empty_bar=""
    local i
    for (( i=0; i<filled; i++ )); do filled_bar="${filled_bar}▓"; done
    for (( i=0; i<empty;  i++ )); do empty_bar="${empty_bar}░"; done

    # coloured fill blocks + dim-grey empty blocks | bold percentage | token counts
    printf "Ctx: ${fill_color}%s\033[0m\033[2;37m%s\033[0m \033[1m%.0f%%\033[0m \033[2;37m%s/%s\033[0m" \
        "$filled_bar" "$empty_bar" "$used" "$used_fmt" "$max_fmt"
}


get_reset_timer() {
    # Five-hour window resets_at (unix epoch)
    local resets_at now diff h m
    resets_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
    if [ -z "$resets_at" ]; then
        echo ""
        return
    fi
    now=$(date +%s)
    diff=$((resets_at - now))
    if [ "$diff" -le 0 ]; then
        # Dim white/grey
        printf '\033[2;37mReset: now\033[0m'
        return
    fi
    h=$((diff / 3600))
    m=$(( (diff % 3600) / 60 ))
    # Dim white/grey
    printf '\033[2;37mReset: %dh%02dm\033[0m' "$h" "$m"
}

get_git_branch_info() {
    local cwd
    cwd=$(echo "$input" | jq -r '.cwd // ""')
    if [ -z "$cwd" ]; then
        echo ""
        return
    fi
    # Run git in the session's cwd to avoid lock races
    local branch changes
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
    if [ -z "$branch" ]; then
        echo ""
        return
    fi

    # Count staged + unstaged + untracked changes
    local status_output
    status_output=$(git -C "$cwd" status --porcelain 2>/dev/null)
    local change_count
    change_count=$(echo "$status_output" | grep -c '^' 2>/dev/null || echo 0)
    # grep -c returns 1 even for empty input on some platforms; guard it
    if [ -z "$status_output" ]; then
        change_count=0
    fi

    if [ "$change_count" -gt 0 ]; then
        # Bold green branch, yellow change count
        printf '\033[1;32m\u2387 %s\033[0m \033[33m(%d)\033[0m' "$branch" "$change_count"
    else
        # Bold green branch
        printf '\033[1;32m\u2387 %s\033[0m' "$branch"
    fi
}

# \u2500\u2500 assemble \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500

CURRENT_DIR=$(get_current_dir)
MODEL_EFFORT=$(get_model_effort)
CONTEXT=$(get_context)
RESET=$(get_reset_timer)
GIT_INFO=$(get_git_branch_info)

parts=()
[ -n "$CURRENT_DIR" ]  && parts+=("$CURRENT_DIR")
[ -n "$MODEL_EFFORT" ] && parts+=("$MODEL_EFFORT")
[ -n "$CONTEXT" ]      && parts+=("$CONTEXT")
[ -n "$RESET" ]        && parts+=("$RESET")
[ -n "$GIT_INFO" ]     && parts+=("$GIT_INFO")

# Join with " | "
result=""
for part in "${parts[@]}"; do
    if [ -z "$result" ]; then
        result="$part"
    else
        result="$result\033[2m | \033[0m$part"
    fi
done

printf '%b\n' "$result"
