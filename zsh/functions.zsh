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
# Usage: tunnel <host> <remote port> [<local port>]
# default local port => localhost:1<remote port>
function tunnel() {
  if [ $# -ge 2 ]; then
    echo "$2" | egrep -xq "[0-9]+" || {
      echo "Error: bad port number '$2'"
      return 1
    }
    local lport=1${2}
    [ -n "$3" ] && lport=$3
    cmd="ssh $1 -gNL ${lport}:localhost:$2"
    echo "Openning tunnel: $cmd"
    eval "$cmd" || return 1
    echo "Success: forwarded port => localhost:$lport"
  fi
}

# Create a new directory and enter it
function mkd() {
  mkdir -p "$@" && cd "$@"
}

# List sorted size of a file or total size of a directory
function fs() {
  local du='du -bsh'
  if hash gdu &> /dev/null; then
    du='gdu -bsh'
  fi
  local sort='sort -h'
  if hash gsort &> /dev/null; then
    sort='gsort -h'
  fi
  local dir=""
  [ $# -eq 1 ] && [ -d "$1" ] && dir=$1
  [ $# -eq 0 ] && dir="."
  if [ -n "$dir" ]; then
    # List size of all files and dirs in current location
    find "$dir" -maxdepth 1 -name '*' |
        perl -pe 's|^(?:\.\/)?(.*)$|"$1"|g' |
        eval "xargs -n1 $du"
  else
    # List size of all files and dirs in arguments
    eval "$du $@"
  fi | eval $sort
    # Sort by file size and reformat size to human readable
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

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
  local open=""
  hash xdg-open &>/dev/null && open="xdg-open"
  hash open &>/dev/null && open="open"
  if [ $# -eq 0 ]; then
    nohup "$open" . >/dev/null 2>&1 &
  else
    for arg in $@; do
      nohup "$open" $arg >/dev/null 2>&1 &
    done
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

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
  local exclude=".DS_Store"
  local tmpFile="${@%/}.tar.gz"
  if du -b /dev/null > /dev/null 2>&1; then
    local size=$(du -sb "${@%/}" | grep -o '[0-9]\+' | head -n1)
  else
    local size=$(du -sk "${@%/}" | grep -o '[0-9]\+' | head -n1)
    local size=$((1000*size))
  fi

  local gz_cmd=""
  #if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
  #  # the .tar file is smaller than 50 MB and Zopfli is available; use it
  #  gz_cmd="zopfli"
  #el
  if hash pigz 2> /dev/null; then
    gz_cmd="pigz"
  else
    gz_cmd="gzip"
  fi

  tar --exclude=$exclude -cf - "${@}" \
    | pv -N "tar | ${gz_cmd}" -s $size \
    | $gz_cmd -11 > "${tmpFile}" || return 1
  echo "${tmpFile} created successfully."
}

# Use jq and less to pretty print and color highligth json files with pagination
hash jq &>/dev/null && {
  function lessjson() {
    jq -C '.' "$@" | less -R
  }
}
