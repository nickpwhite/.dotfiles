COLOR_USERNAME='\[\033[01;33m\]'
COLOR_SEPARATOR='\[\033[01;95m\]'
COLOR_DIRECTORY='\[\033[0;34m\]'
COLOR_GIT_CLEAN='\[\033[1;32m\]'
COLOR_GIT_MODIFIED='\[\033[1;31m\]'
COLOR_GIT_STAGED='\[\033[1;34m\]'
COLOR_RESET='\[\033[0m\]'

function git_branch_name() {
  if [ -e ".git" ] || git rev-parse --git-dir > /dev/null 2>&1; then
    local branch_name

    branch_name=$(git symbolic-ref -q HEAD)
    branch_name=${branch_name##refs/heads/}
    branch_name=${branch_name:-HEAD}
    echo -n "$branch_name"
  fi
}

function git_branch_display() {
  local branch_name=$1
  local status

  if [[ -z "$branch_name" ]]; then
    return
  fi

  status=$(git status -uno 2> /dev/null)

  if [[ $(echo $status | tail -n1) = *"nothing to commit"* ]]; then
    echo -n "$COLOR_GIT_CLEAN$branch_name$COLOR_RESET"
  elif [[ $(echo $status | head -n5) = *"Changes to be committed"* ]]; then
    echo -n "$COLOR_GIT_STAGED$branch_name$COLOR_RESET"
  else
    echo -n "$COLOR_GIT_MODIFIED$branch_name*$COLOR_RESET"
  fi
}

function git_prompt() {
  local canonical_path
  local branch_name
  local branch_display

  branch_name=$(git_branch_name)
  branch_display=$(git_branch_display "$branch_name")

  if [[ -z "$branch_display" ]]; then
    return
  fi

  canonical_path=$(pwd -P)
  if [[ "$canonical_path" == */"$branch_name" ]]; then
    echo -n "$COLOR_DIRECTORY/$COLOR_RESET$branch_display"
  else
    echo -n " → $branch_display"
  fi
}

function username() {
  echo -n "$COLOR_USERNAME\u$COLOR_RESET"
}

function separator() {
  echo -n "$COLOR_SEPARATOR::$COLOR_RESET"
}

function directory() {
  local canonical_path
  local branch_name
  local base_path

  canonical_path=$(pwd -P)
  branch_name=$(git_branch_name)
  base_path=$canonical_path

  if [[ -n "$branch_name" && "$canonical_path" == */"$branch_name" ]]; then
    base_path=${canonical_path%/"$branch_name"}
  fi

  if [[ -z "$base_path" ]]; then
    base_path="/"
  fi

  if [[ "$base_path" == "$HOME" || "$base_path" == "$HOME"/* ]]; then
    base_path="~${base_path#$HOME}"
  fi

  echo -n "$COLOR_DIRECTORY${base_path}$COLOR_RESET"
}

function prompt() {
  PS1="$(username) $(separator) $(directory)$(git_prompt) % "
}

PROMPT_COMMAND=prompt
