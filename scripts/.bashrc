#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ls='eza --icons --git --group-directories-first'
alias ll='eza -l --icons --git --header'
alias lt='eza --tree --icons'
PS1='[\u@\h \W]\$ '

# =========================
# HIGH CONTRAST LS_COLORS
# (keeps same theme, improves readability)
# =========================

export LS_COLORS="\
di=1;96:\
ex=1;92:\
ln=1;95:\
*.sh=1;93:\
*.md=1;97:\
*.txt=0;37:\
*.html=1;94:\
fi=0;37"

export PATH="/home/yloryth/.local/bin:$PATH"
export TERMINAL=kitty
