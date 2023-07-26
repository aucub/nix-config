if status is-interactive
    # Commands to run in interactive sessions can go here
end
function fish_greeting

end
set -x EDITOR nvim
mcfly init fish | source
thefuck --alias | source
zoxide init fish | source