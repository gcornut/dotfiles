# Easier navigation: .., ..., ...., .....
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# IP addresses
#alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Reload zsh rc
alias srczshrc="source ~/.zshrc"

# Git
alias g="git"

# Clear swap & cache mem
alias clearswap="echo 'swapoff -a && swapon -a' | sudo sh"
alias clearcache="echo 'sync && echo 3 > /proc/sys/vm/drop_caches' | sudo sh"
