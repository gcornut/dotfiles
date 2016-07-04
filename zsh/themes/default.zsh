PROMPT='
$FG[208]%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in $FG[070]${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_info)
%(?,%{%F{white}%},%{%F{red}%})❯%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""
