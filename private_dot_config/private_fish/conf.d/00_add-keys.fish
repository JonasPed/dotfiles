# Use ksshaskpass for passphrases when under KDE.
if set -q XDG_CURRENT_DESKTOP; and test "$XDG_CURRENT_DESKTOP" = "KDE"
    set -gx SSH_ASKPASS /usr/bin/ksshaskpass
    set -gx SSH_ASKPASS_REQUIRE prefer
end

set -l agentfile "$HOME/.ssh-agent"

# Load connection info for a previously started agent.
if test -f "$agentfile"
    source "$agentfile" >/dev/null 2>&1
end

# Only start an agent if none is actually reachable.
set -l alive 0
if set -q SSH_AUTH_SOCK; and test -S "$SSH_AUTH_SOCK"
    set -l as
    ssh-add -l >/dev/null 2>&1; set as $status
    if test $as -eq 0; or test $as -eq 1
        set alive 1
    end
end

if not test $alive -eq 1
    # Start agent, persist its env to a file, and import it.
    ssh-agent -c > "$agentfile"
    chmod 600 "$agentfile"
    source "$agentfile" >/dev/null 2>&1
    ssh-add -q < /dev/null
end
