alias l='ls -lahF'
alias tmux='tmux -2'
alias bconfig='vim $HOME/.bashrc'
alias breload='. $HOME/.bashrc'
alias vssh='eval "$(ssh-agent)" && ssh-add && z vagrant && AWS_PROFILE=academia ACADEMIA_LDAP_USERNAME=nickwhite vagrant ssh -- -Y'
