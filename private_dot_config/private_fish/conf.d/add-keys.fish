# Ensures that ssh-agent is running.
# Adds SSH keys to ssh-agent and uses ksshaskpass as password store. 
function add_keys
    if set -q XDG_CURRENT_DESKTOP; and test "$XDG_CURRENT_DESKTOP" = "KDE"
        set -gx SSH_ASKPASS /usr/bin/ksshaskpass
        set -gx SSH_ASKPASS_REQUIRE prefer

        ssh-add -l >/dev/null 2>&1
        if test $status -eq 2
            # Could not open a connection to your authentication agent.

            # Load stored agent connection info.
            if test -r ~/.ssh-agent
                # Fish eval requires the output to be valid Fish code. 
                # Da ssh-agent spytter Bash-kode ud, bruger vi 'source' med et link til at fortolke det,
                # eller konverterer det direkte. Den sikreste måde i Fish er at køre det igennem en subshell:
                ssh-agent -c | source >/dev/null 2>&1
            end

            ssh-add -l >/dev/null 2>&1
            if test $status -eq 2
                # Start agent and store agent connection info.
                # Vi sætter umask i en blok for at holde det lokalt
                begin
                    # Gemmer ren Fish-kompatibel konfiguration via ssh-agent -c
                    umask 066
                    ssh-agent -c > ~/.ssh-agent
                end
                source ~/.ssh-agent >/dev/null 2>&1
            end
        end

        ssh-add -q < /dev/null
    end
end