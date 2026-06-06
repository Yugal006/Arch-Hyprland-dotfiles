if not status is-interactive
    exit
end

# -----------------------
# Environment
# -----------------------
set -gx PATH $HOME/.local/bin $PATH
set -gx TERMINAL kitty
set -gx TERM xterm-kitty
set -gx LS_COLORS "di=1;96:ex=1;92:ln=1;95:*.sh=1;93:*.md=1;97:*.txt=0;37:*.html=1;94:fi=0;37"

# -----------------------
# Keep theme dynamic (Matugen handles LS_COLORS externally)
# -----------------------
# DO NOT override LS_COLORS manually unless needed
# (Matugen already exports it)

# autosuggestions (use terminal dim color, not custom hex)
set -g fish_color_autosuggestion brblue --bold

# valid paths (highlight only)
set -g fish_color_valid_path --underline --bold

# commands (use theme accent automatically)
set -g fish_color_command normal

# parameters (let theme decide color)
set -g fish_color_param normal

# errors (keep strong default red from theme)
set -g fish_color_error brred --strikethrough --bold

# -----------------------
# eza functions
# -----------------------
function ls
    eza --icons --git --group-directories-first --color=always $argv
end

function ll
    eza -l --icons --git --header --color=always $argv
end

function lt
    eza --tree --icons --color=always $argv
end

function ff-tree
    eza --tree \
        --icons \
        --git \
        --level=3 \
        --group-directories-first \
        --color=always
end

# -----------------------
# Prompt
# -----------------------
starship init fish | source

# -----------------------
# zoxide (smart cd)
# -----------------------
zoxide init fish | source
abbr --add cd z
abbr --add zz z

# -----------------------
# fzf (safe load)
# -----------------------
if type -q fzf
    fzf --fish | source
end

# -----------------------
# Disable fish greeting (correct way)
# -----------------------
set -U fish_greeting ""
