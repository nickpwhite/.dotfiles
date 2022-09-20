COLOR_USERNAME='\[\033[01;33m\]'
COLOR_SEPARATOR='\[\033[01;95m\]'
COLOR_DIRECTORY='\[\033[01;34m\]'
COLOR_GIT_CLEAN='\[\033[32m\]'
COLOR_GIT_MODIFIED='\[\033[31m\]'
COLOR_GIT_STAGED='\[\033[1;34m\]'
COLOR_RESET='\[\033[0m\]'

function git_prompt() {
  if [ -e ".git" ] || git rev-parse --git-dir > /dev/null 2>&1; then
    branch_name=$(git symbolic-ref -q HEAD)
    branch_name=${branch_name##refs/heads/}
    branch_name=${branch_name:-HEAD}

    echo -n " → "

    status=$(git status -uno 2> /dev/null)

    if [[ $(echo $status | tail -n1) = *"nothing to commit"* ]]; then
      echo -n "$COLOR_GIT_CLEAN$branch_name$COLOR_RESET"
    elif [[ $(echo $status | head -n5) = *"Changes to be committed"* ]]; then
      echo -n "$COLOR_GIT_STAGED$branch_name$COLOR_RESET"
    else
      echo -n "$COLOR_GIT_MODIFIED$branch_name*$COLOR_RESET"
    fi
  fi
}

function username() {
  echo -n "$COLOR_USERNAME\u$COLOR_RESET"
}

function separator() {
  echo -n "$COLOR_SEPARATOR::$COLOR_RESET"
}

function directory() {
  echo -n "$COLOR_DIRECTORY\w$COLOR_RESET"
}

function prompt() {
  PS1="$(username) $(separator) $(directory)$(git_prompt) % "
}

PROMPT_COMMAND=prompt
