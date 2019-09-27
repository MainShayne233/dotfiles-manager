function __fish_dotfiles_needs_command
    set -l cmd (commandline -opc)
    if test (count $cmd) -eq 1
        return 0
    end
    return 1
end

function __fish_dotfiles_using_command -a current_command
    set -l cmd (commandline -opc)
    if test (count $cmd) -gt 1
        if test $current_command = $cmd[2]
            return 0
        end
    end
    return 1
end

complete -f -c dotfiles -n '__fish_dotfiles_needs_command' -a help -d "dotfiles help for command"
complete -x -c dotfiles -d "script" -a "(dotfiles commands)"
