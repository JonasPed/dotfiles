# Kør kun automatisk chezmoi opdatering, hvis shellen er interaktiv
if status is-interactive
    set -l CHEZMOI_UPDATE_FLAG "$HOME/.dotfiles_update"
    set -l CURRENT_TIME (date +%s)
    set -l DO_UPDATE 0

    # Tjek om filen findes
    if test -f "$CHEZMOI_UPDATE_FLAG"
        set -l LAST_TIME (cat "$CHEZMOI_UPDATE_FLAG" 2>/dev/null)
        
        # Valider at indholdet faktisk er et tal (for at undgå regnefejl, hvis filen er korrupt)
        if string match -qr '^[0-9]+$' -- "$LAST_TIME"
            set -l TIME_DIFF (math "$CURRENT_TIME - $LAST_TIME")
            
            # Tjek om der er gået mere end 86.400 sekunder (24 timer)
            if test $TIME_DIFF -ge 86400
                set DO_UPDATE 1
            end
        else
            # Hvis filen findes, men er tom eller indeholder tekst
            set DO_UPDATE 1
        end
    else
        # Hvis filen slet ikke findes endnu
        set DO_UPDATE 1
    end

    # Kør selve opdateringen og skriv det nye tidsstempel
    if test $DO_UPDATE -eq 1
        echo "Kører daglig opdatering af dotfiles (chezmoi update -a)..."
        chezmoi update -a
        
        # Overskriv filen med nuværende tid i sekunder
        echo $CURRENT_TIME > "$CHEZMOI_UPDATE_FLAG"
    end
end