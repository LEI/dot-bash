# dot-bash

## Requirements

- bash

## Manual installation

Clone and change directory

    git clone https://github.com/LEI/dot-bash.git ~/.dot/bash && cd $_

Create the directory `~/.bash.d`

    mkdir -p "$HOME/.bash.d"

Link bash files to home directory

    ln -isv "~/.dot/bash/{*,aliases/*,environment/*,function/*,plugins/*}.bash" "$HOME"

Link other files to home directory

    ln -isv "~/.dot/bash/.inputrc" "$HOME"

Source `~/.bash_profile` from `~/.bashrc`

    echo '[[ -n "$PS1" ]] && [[ -f ~/.bash_profile ]] && source ~/.bash_profile' >> "$HOME/.bashrc"

Source `~/.bash.d/init.bash` from `~/.bash_profile`

    echo '[[ -f ~/.bash.d/init.bash ]] && source ~/.bash.d/init.bash' >> "$HOME/.bash_profile"

## Resources

- [Bash-it](https://github.com/Bash-it/bash-it)
- [Antibody](https://github.com/getantibody/antibody) (zsh)
