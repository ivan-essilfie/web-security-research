certspotter() {
  curl -s "https://api.certspotter.com/v1/issuances?domain=$1&include_subdomains=true&expand=dns_names" \
  | jq -r 'select(type == "array") | .[]? | .dns_names[]?' \
  | sed 's/\*\.//g' \
  | sort -u \
  | grep "$1"
}
