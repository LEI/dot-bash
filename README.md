# dot-bash

## Requirements

- bash

## Manual installation

    mkdir -p "$HOME/.bash.d"
    ln -isv "$DOT/{*,aliases/*,environment/*,function/*,plugins/*}.bash" "$HOME"
    ln -isv "$DOT/.inputrc" "$HOME"
    echo '[[ -n "$PS1" ]] && [[ -f ~/.bash_profile ]] && source ~/.bash_profile' >> "$HOME/.bashrc"
    echo '[[ -f ~/.bash.d/init.bash ]] && source ~/.bash.d/init.bash' >> "$HOME/.bash_profile"

## Resources

- [Bash-it](https://github.com/Bash-it/bash-it)
