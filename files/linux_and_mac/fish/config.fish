#!/usr/bin/env fish

# surpress greeting
set fish_greeting

# set envs
set -g -x BASHRC "$HOME/.config/fish/config.fish"
set -g -x SSHRC  "$HOME/.ssh/config"
set -g -x GITRC  "$HOME/.gitconfig"
set -g -x EMAIL  "shaynetremblay@gmail.com"
set -g -x EDITOR "vim"
set -g -x GOPATH "$HOME/.go"

# set path
set PATH \
  "/usr/bin" \
  "/usr/local/sbin" \
  "/usr/lib/go-1.11/bin" \
  "$HOME/.go/bin" \
  "$HOME/bin" \
  "$HOME/.yarn/bin" \
  "$HOME/opt" \
  "$HOME/opt/teleport/bin" \
  "$HOME/opt/tsh/bin" \
  "$HOME/opt/libwebp/bin" \
  "$HOME/opt/racer/target/release" \
  "$HOME/.cargo/bin" \
  "$HOME/.cabal/bin" \
  "$HOME/dotfiles-manager/bin" \
  "$HOME/provision/bin" \
$PATH

function _source_if_exists
    set file "$argv[1]"
    if test -e "$file"
        source "$file"
    end
end

# source stuff
source "$HOME/.asdf/asdf.fish"
_source_if_exists "$HOME/.workrc"
_source_if_exists "$HOME/.bash_os"
_source_if_exists "$HOME/provision/completions/dotfiles.fish"
_source_if_exists "$HOME/provision/completions/provision.fish"

# functions

function sb
    source "$BASHRC"
end

function eb
    vim "$BASHRC"
    sb
end

function trim
    echo "$argv[1]" | awk '{$1=$1};1'
end

function scpdir
    set filepath $argv[1]
    set address $argv[2]
    tar czf - "$filepath" | ssh "$address" "cd ~/ && tar xvzf -"
end

function killit
    set program "$argv[1]"
    set pids (ps -ef | grep "$program" | grep -v grep | awk '{ print $2 }' | tr '\n' ' ')
    kill -9 (trim "$pids")
end

function runproject
    if test -e "mix.exs"
        if grep -q "phoenix" "mix.exs"
            iex -S mix phx.server
        else
            iex -S mix
        end
    else if test -e "package.json"
        yarn start
    else
        echo "runproject not setup for this project type"
    end
end

function run
    runproject
end

# start tmux on start
if status is-interactive
and not set -q TMUX
    exec tmux
end

