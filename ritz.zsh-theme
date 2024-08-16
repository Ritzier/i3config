function _git_repo_name { 
    gittopdir=$(git rev-parse --git-dir 2> /dev/null)
    if [[ "foo$gittopdir" == "foo.git" ]]; then
        echo `basename $(pwd)`
    elif [[ "foo$gittopdir" != "foo" ]]; then
        echo `dirname $gittopdir | xargs basename`
    fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="%F{163}(%F{057}$(_git_repo_name):%F{214}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{163})"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{160}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" %F{042}✔"

function custom_prompt {
  ((spare_width = ${COLUMNS}))
  prompt=" "

  # Git
  branch=$(git_current_branch)
  if [[ ${#branch} -eq 0 ]] then
    git_prompt=""
  else
    git_prompt="$(_git_repo_name):$branch"
    git_prompt_colored="%F{163}(%F{057}$(_git_repo_name)%F{111}:%F{214}$branch%F{163})"
  fi

  git_prompt_size=${#git_prompt}
  ((git_prompt_size=git_prompt_size+2))
  if [[ -n $(git status -s 2> /dev/null) ]]; then
    git_c=" %F{160}X"
    ((git_prompt_size=git_prompt_size+2))
    git_prompt_colored="%F{163}(%F{057}$(_git_repo_name)%F{111}:%F{214}$branch%F%F{160}$git_c%F{163})"
  fi

  # path word: 
  cuspath="${PWD}"

  # Time
  custime="{HH:MM:SS}"

  path_size=${#cuspath}
  custime_size=${#custime}
  word_size=5

  (( spare_width = ${spare_width} - (${path_size} + ${git_prompt_size} + ${custime_size} + ${word_size}) ))
  while [ ${#prompt} -lt $spare_width ]; do
    prompt=" $prompt"
  done

  prompt="%F{092}┌─{%F{215}%*%F{092}}-[%F{051}$cuspath%F{092}]$prompt$git_prompt_colored"
  echo $prompt
}

preexec() {
    COMMAND_TIME_BEIGIN="$(date +%s.%3N)";
}

function update_command_status() {
    local arrow="";
    local color_reset="%{$reset_color%}";
    local reset_font="%{$fg_no_bold[white]%}";
    COMMAND_RESULT=$1;
    export COMMAND_RESULT=$COMMAND_RESULT
    if $COMMAND_RESULT;
    then
        arrow="%{$fg_bold[red]%}❱%{$fg_bold[yellow]%}❱%{$fg_bold[green]%}❱";
    else
        arrow="%{$fg_bold[red]%}❱❱❱";
    fi
    COMMAND_STATUS="${arrow}${reset_font}${color_reset}";
}

function output_command_execute_after() {
    if [ "$COMMAND_TIME_BEIGIN" = "-20200325" ] || [ "$COMMAND_TIME_BEIGIN" = "" ];
    then
        return 1;
    fi

    # cmd
    local cmd="${$(fc -l | tail -1)#*  }";
    local color_cmd="";
    if $1;
    then
        color_cmd="$fg_no_bold[green]";
    else
        color_cmd="$fg_bold[red]";
    fi
    local color_reset="$reset_color";
    cmd="${color_cmd}${cmd}${color_reset}"

    # time
    local time="[$(date +%H:%M:%S)]"
    local color_time="$fg_no_bold[cyan]";
    time="${color_time}${time}${color_reset}";

    # cost
    local time_end="$(date +%s.%3N)";
    local cost=$(bc -l <<<"${time_end}-${COMMAND_TIME_BEIGIN}");
    COMMAND_TIME_BEIGIN="-20200325"
    local length_cost=${#cost};
    if [ "$length_cost" = "4" ];
    then
        cost="0${cost}"
    fi
    cost="[cost ${cost}s]"
    local color_cost="$fg_no_bold[cyan]";
    cost="${color_cost}${cost}${color_reset}";

    echo -e "${time} ${cost} ${cmd}";
    echo -e "";
}
precmd() {
  local last_cmd_return_code=$?;
  local last_cmd_result=true;
  
if [ "$last_cmd_return_code" = "0" ];
    then
        last_cmd_result=true;
    else
        last_cmd_result=false;
    fi

  update_command_status $last_cmd_result;
  output_command_execute_after $last_cmd_result;
}

setopt prompt_subst

PROMPT='
$(custom_prompt)
%F{092}└─> %F{reset}'
