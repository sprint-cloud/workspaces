source antigen.zsh

antigen use oh-my-zsh
antigen bundle git
antigen bundle pip
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle command-not-found
antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme robbyrussell
antigen apply

source $("/home/coder/bin/trdl" use werf "2" "stable")