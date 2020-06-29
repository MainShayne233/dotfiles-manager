#!/usr/bin/env fish

# surpress greeting
set fish_greeting

# set envs
set -g -x BASHRC "$HOME/.config/fish/config.fish"
set -g -x SSHRC  "$HOME/.ssh/config"
set -g -x GITRC  "$HOME/.gitconfig"
set -g -x EMAIL  "shaynetremblay@gmail.com"
set -g -x GOPATH "$HOME/.go"
set -g -x ERL_AFLAGS "-kernel shell_history enabled"

if type -q "vim"
    set -g -x EDITOR "vim"
else
    set -g -x EDITOR "vi"
end

set -g -x VISUAL "$EDITOR"

# set path
set PATH \
  "/usr/bin" \
  "/usr/local/sbin" \
  "/usr/lib/go-1.11/bin" \
  "$HOME/.go/bin" \
  "$HOME/bin" \
  "/$HOME/.local/bin" \
  "$HOME/.yarn/bin" \
  "$HOME/opt" \
  "$HOME/.cargo/bin" \
  "$HOME/.cabal/bin" \
  "$HOME/dotfiles-manager/bin" \
  "$HOME/provision/bin" \
  "/var/lib/snapd/snap/bin" \
$PATH

# init starship
eval (starship init fish)

# init opam
eval (opam env)

# setup direnv
eval (direnv hook fish)

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
    $EDITOR "$BASHRC"
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
    echo $pids
    kill -9 (trim "$pids")
end

function runproject
    if test -e "bin/start"
        bin/start
    else if test -e "bin/run"
        bin/run
    else if test -e "mix.exs"
        if grep -q "phoenix" "mix.exs"
            iex -S mix phx.server
        else
            iex -S mix
        end
    else if test -e "Cargo.toml"
        cargo run
    else if test -e "elm.json"
        elm-app start
    else if test -e "package.json"
        yarn start
    else if test -e "stack.yaml"
        stack run
    else if test -e "__main__.py"
        python __main__.py
    else
        echo "runproject not setup for this project type"
    end
end

function run
    runproject
end

function rename
  set old_pattern "$argv[1]"
  set new_pattern "$argv[2]"

  for file in $argv[3..-1]
    set new_name (echo "$file" | awk "{ gsub(/$old_pattern/, \"$new_pattern\"); print }" )
    echo "$file -> $new_name"
    mv "$file" "$new_name"
  end
end

function backup
  bash -c '
    export RESTIC_REPOSITORY="$(pass show restic_repo)"
    export AWS_ACCESS_KEY_ID="$(pass show restic_access_key_id)"
    export AWS_SECRET_ACCESS_KEY="$(pass show restic_secret_access_key)"
    export RESTIC_PASSWORD="$(pass show restic_password)"

    restic -r $RESTIC_REPOSITORY backup "$HOME" \
      --exclude "node_modules" \
      --exclude "_build" \
      --exclude "deps" \
      --exclude "*.plt" \
      --exclude ".cache" \
      --exclude ".ansible" \
      --exclude ".asdf" \
      --exclude ".bazel" \
      --exclude ".bazel_binaries" \
      --exclude ".cabal" \
      --exclude ".cache" \
      --exclude ".cargo" \
      --exclude ".go" \
      --exclude ".hex" \
      --exclude ".linuxbrew" \
      --exclude ".rustup" \
      --exclude ".secrets" \
      --exclude ".stack" \
      --exclude ".zoom" \
      --exclude "*Cache*" \
      --exclude ".config/Slack" \
      --exclude ".config/google-chrome" \
      --exclude ".config/chromium" \
      --exclude "*VirtualBox*"
  '
end

function restic
  set REPO (pass show restic_repo)
  env RESTIC_REPOSITORY=$REPO \
  env AWS_ACCESS_KEY_ID=(pass show restic_access_key_id) \
  env AWS_SECRET_ACCESS_KEY=(pass show restic_secret_access_key) \
  env RESTIC_PASSWORD=(pass show restic_password) \
  restic -r "$REPO" $argv
end



function iexdep
 set deps ''
  for dep in $argv
    set deps (echo "$deps '$dep' ")
  end
  fish -c "
    cd /tmp
    rm -rf tmp_iex_app
    mix new tmp_iex_app
    cd tmp_iex_app
    mix_add_dep $deps
    mix deps.get
    iex -S mix
  "
end

function get_avy
  wget --output-document="$HOME/Downloads/avatar.png" "https://avatars0.githubusercontent.com/u/12074467?s=400&v=4"
end

function repeat
  set n (math "$argv[1]" - 1)
  set cmd "$argv[2..-1]"
  set cmd_status "0"
  for i in (seq 0 $n)
    eval $cmd
    set cmd_status "$status"
    if test "$cmd_status" != "0"
      break
    end
  end

  return "$cmd_status"
end

# start tmux on start
if status is-interactive
and not set -q TMUX
    exec tmux
end

