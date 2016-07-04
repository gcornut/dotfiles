# Simple calculator
function calc() {
  local result="";
  result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')";
  #             └─ default (when `--mathlib` is used) is 20
  #
  if [[ "$result" == *.* ]]; then
    # improve the output for decimal numbers
    printf "$result" |
    sed -e 's/^\./0./'    `# add "0" for cases like ".5"` \
      -e 's/^-\./-0./'    `# add "0" for cases like "-.5"`\
      -e 's/0*$//;s/\.$//';  # remove trailing zeros
  else
    printf "$result";
  fi;
  printf "\n";
}

# Create a ssh tunnel
# Usage: tunnel <host> <port>
# result forwarded port => localhost:1<port>
function tunnel() {
  if [ $# -eq 2 ]; then
    echo "$2" | egrep -xq "[0-9]+" || {
      echo "Error: bad port number '$2'"
      return 1
    }
    CMD="ssh $1 -f -N -L 1$2:localhost:$2"
    echo "Openning tunnel: $CMD"
    eval "$CMD" || return 1
    echo "Success: forwarded port => localhost:1$2"
  fi
}

# Create a new directory and enter it
function mkd() {
  mkdir -p "$@" && cd "$@"
}

# List sorted size of a file or total size of a directory
function fs() {
  if du -b /dev/null > /dev/null 2>&1; then
    local arg=-sb
  else
    local arg=-s
  fi
  if [[ -n "$@" ]]; then
    # List size of all files and dirs in arguments
    du $arg -- "$@"
  else
    # List size of all files and dirs in current location
    find -maxdepth 1 -name '*' | perl -pe 's|^(?:\.\/)?(.*)$|"$1"|g' | xargs -n1 du $arg
  fi | \
    # Sort by file size and reformat size to human readable
    sort -n | numfmt --to=iec | perl -pe 's|\s|\t|'
}

# Use Git’s colored diff when available
hash git &>/dev/null && {
  function diff() {
		git diff --no-index --color-words "$@"
	}
}

# `a` with no arguments opens the current directory in Atom Editor, otherwise
## opens the given location
hash atom &>/dev/null && {
  function a() {
  	if [ $# -eq 0 ]; then
  		atom .
  	else
  		atom "$@"
  	fi
  }
}

# `s` with no arguments opens the current directory in Sublime Text Editor, otherwise
## opens the given location
hash subl &>/dev/null && {
  function s() {
  	if [ $# -eq 0 ]; then
  		subl .
  	else
  		subl "$@"
  	fi
  }
}

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
  local OPEN_CMD=""
  hash xdg-open &>/dev/null && OPEN_CMD="xdg-open"
  hash open &>/dev/null && OPEN_CMD="open"
  if [ $# -eq 0 ]; then
    "$OPEN_CMD" .
  else
    "$OPEN_CMD" "$@"
  fi
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
	local port="${1:-8000}"
	sleep 1 && open "http://localhost:${port}/" &
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

# Create a data URL from a file
function dataurl() {
  local mimeType=$(file -b --mime-type "$1")
  if [[ $mimeType == text/* ]]; then
    mimeType="${mimeType};charset=utf-8"
  fi
  echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}
