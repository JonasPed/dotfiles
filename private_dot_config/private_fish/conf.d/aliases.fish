function kit
        cd ~/development/kvalitetsit/
end

function pfa
        cd ~/development/pfa/
end

function dev
        cd ~/development/
end

function medcom
        cd ~/development/medcom
end

if command -v htop &> /dev/null
        abbr -a top htop
        abbr -a topp top
end

abbr -a dff df -h

if command -v zypper &> /dev/null
        abbr -a zs zypper search
end

if command -v yq &> /dev/null
        abbr yc "yq -C | less -r"
end

if command -v kubecolor &> /dev/null
        alias kubectl=kubecolor
end

if command -v lsd &> /dev/null
        alias ls=lsd
end

function jwtd
    if type -q jq
        echo $argv[1] | jq -R 'split(".") | .[0],.[1] | @base64d | fromjson'
        echo "Signature: (echo $argv[1] | awk -F'.' '{print $3}')"
    end
end