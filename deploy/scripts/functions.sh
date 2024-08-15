normalize() {
    local normalizeText=$(echo "$1" | sed '2,$ s/^/    /')
    echo "$normalizeText"
}
