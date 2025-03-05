### p10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

### kport
function kport() {
  kill -9 $(lsof -t -i:$1)
}

### repeat_cmd
repeat_cmd() {
  local times=$1
  shift

  # Input validation
  if ! [[ "$times" =~ ^[0-9]+$ ]]; then
    echo "Error: First argument must be a positive number" >&2
    return 1
  fi

  if [ $# -eq 0 ]; then
    echo "Error: No command specified to repeat" >&2
    return 1
  fi

  # Use a counter variable with a more descriptive name
  local iteration
  for ((iteration = 1; iteration <= times; iteration++)); do
    # Use eval to support shell aliases
    eval "$@"
  done
}
