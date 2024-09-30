#!/bin/zsh
tmux_config_path=~/.config/tmux/tmux.conf

# Check if we're inside a tmux sesison
if [[ -z "$TMUX" ]]; then
    # List all existing tmux sessions
    tmux_sessions=($(tmux list-sessions -F "#S" 2>/dev/null))

    case ${#tmux_sessions[@]} in
        0)
            tmux -f $tmux_config_path new-session -d -s base
            tmux attach-session -t base
            ;;
        1)
            tmux attach-session -t ${tmux_sessions[@]}
            ;;
        *)
            echo "Select a tmux session to attach:"
            i=1
            for session in "${tmux_sessions[@]}"; do
                echo "$i: $session"
                ((i++))
            done
            read -r selection
            if [[ $selection -ge 1 && $selection -le ${#tmux_sessions[@]} ]]; then
                tmux attach-session -t ${tmux_sessions[$((selection - 1))]}
            else
                echo "Invalid selection."
            fi
            ;;
    esac
fi
