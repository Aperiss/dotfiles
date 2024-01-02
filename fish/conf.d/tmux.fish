set tmux_config_path ~/.config/tmux/tmux.conf

# Check if we're inside a tmux session by looking for the TMUX environment variable
if not set -q TMUX
    # List all existing tmux sessions
    set -l tmux_sessions (tmux list-sessions -F "#S" 2>/dev/null)

    switch (count $tmux_sessions)
        case 0
            # Start a new detached tmux session named 'base' with the specified configuration
            tmux -f $tmux_config_path new-session -d -s base
            # Attach to the 'base' session
            exec tmux attach-session -t base
        case 1
            # Attach to current active session
            exec tmux attach-session -t $tmux_sessions[1]
        case '*'
            # More than one session exists, prompt user to select one
            echo "Select a tmux session to attach:"
            set -l i 1
            for session in $tmux_sessions
                echo "$i: $session"
                set i (math $i + 1)
            end
            set -l selection (read)
            if set -q tmux_sessions[$selection]
                exec tmux attach-session -t $tmux_sessions[$selection]
            else
                echo "Invalid selection."
            end
    end
end

