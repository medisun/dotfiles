# Setup fzf
# ---------
if [[ ! "$PATH" == */home/morock/packages/fzf-master/fzf-master/bin* ]]; then
  export PATH="$PATH:/home/morock/packages/fzf-master/fzf-master/bin"
fi

# Man path
# --------
if [[ ! "$MANPATH" == */home/morock/packages/fzf-master/fzf-master/man* && -d "/home/morock/packages/fzf-master/fzf-master/man" ]]; then
  export MANPATH="$MANPATH:/home/morock/packages/fzf-master/fzf-master/man"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/morock/packages/fzf-master/fzf-master/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/morock/packages/fzf-master/fzf-master/shell/key-bindings.bash"

