CURRENT_BG='NONE'

case ${SOLARIZED_THEME:-dark} in
    light) CURRENT_FG='white';;
    *)     CURRENT_FG='black';;
esac

# Special Powerline characters

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  #SEGMENT_SEPARATOR=$'\ue0b0'
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
  else
    echo -n "%{$bg%}%{$fg%}"
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR "
  else
    echo -n "%{%k%} "
  fi
  echo -n "%{%f%} "
  CURRENT_BG=' '
}

# Git: branch/detached head, dirty status
prompt_git() {
  (( $+commands[git] )) || return
  if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi
  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    #PL_BRANCH_CHAR=$' \ue0a0'         # 
    PL_BRANCH_CHAR=$' '
    #PL_BRANCH_CHAR=➜
  }
  local ref dirty mode repo_path

   if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    repo_path=$(git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment yellow black
    else
      prompt_segment green $CURRENT_FG
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    #zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' stagedstr '✔'
    #zstyle ':vcs_info:*' unstagedstr '●'
    zstyle ':vcs_info:*' unstagedstr '✚'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${ref/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
  fi
}

## Main prompt
build_prompt() {
  prompt_git
  prompt_end
  #battery_pct_prompt
}

#setopt prompt_subst
#autoload -Uz vcs_info
#zstyle ':vcs_info:*' actionformats \
    #'%F{5}(%f%s%F{5})%F{3}➜%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
#zstyle ':vcs_info:*' formats       \
    #'%F{5}(%f%s%F{5})%F{3}➜%F{5}[%F{2}%b%F{5}]%f '
#zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

#zstyle ':vcs_info:*' enable git cvs svn

## or use pre_cmd, see man zshcontrib
#vcs_info_wrapper() {
  #vcs_info
  #if [ -n "$vcs_info_msg_0_" ]; then
    #echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  #fi
#}
#RPROMPT=$'$(vcs_info_wrapper)'
#RPROMPT='$(build_prompt)'
RPROMPT='$(build_prompt)%{%B%F{green}%}$(battery_pct_prompt)%{%f%k%b%}'
PROMPT=$'%{\e[0;37m%}%B┌╼\e[42m    \e[42m\e[01;4;37m\$(date +%H:%M)\e[0m\e[42m    \e[0m%b%{\e[0m%}
%{\e[0;37m%}%B└╼%b%{\e[0m%}%{\e[1;32m%}%n%{\e[1;32m%}@%{\e[0m%}%{\e[0;32m%}%B%m%{\e[0;37m%}%b:%b%{\e[0m%}%B%{\e[1;35m%}%b%{\e[0;34m%}%B%b%{\e[1;34m%}%c%{\e[0;37m%}%B%b%{\e[0m%}%{\e[0;34m%}%B%{\e[0m%}%b❱ '

