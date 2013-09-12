autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

git_branch() {
  echo $(command git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  if [ ! -z "$DISABLE_GIT_PROMPT" ]; then
    echo ""
    exit
  fi
  st=$(command git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo ""
  else
    if [[ $st == "nothing to commit (working directory clean)" ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
 ref=$(command git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

unpushed () {
  command git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [ ! -z "$DISABLE_GIT_PROMPT" ]; then
    echo ""
    exit
  fi
  
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
  fi
}

rb_prompt(){
  if $(which rbenv &> /dev/null)
  then
	  echo "%{$fg_bold[yellow]%}$(rbenv version | awk '{print $1}')%{$reset_color%}"
	else
	  echo ""
  fi
}

# This keeps the number of todos always available the right hand side of my
# command line. I filter it to only count those tagged as "+next", so it's more
# of a motivation to clear out the list.
todo(){
  if $(which todo.sh &> /dev/null)
  then
    num=$(echo $(todo.sh ls +next | wc -l))
    let todos=num-2
    if [ $todos != 0 ]
    then
      echo "$todos"
    else
      echo ""
    fi
  else
    echo ""
  fi
}

abbreviated_path () {
  if [[ "$1" == "/" ]]; then
    echo $1
    return
  fi

  # Substitute $HOME at the beginning with ~
  home_substituted=${1/#$HOME/"~"}
  # Split path by slash
  components=(${(s:/:)home_substituted})
  # Variable holding the result
  shortened_path=""

  # Abbreviate all components except the last one
  for component in $components[1,-2]; do
    current_component=$component[1]
    # Add an additional character if path component starts 
    # with "." so hidden directories along the path makes
    # more sense
    if [[ $current_component == "." ]]; then
      current_component="${current_component}${component[2]}"
    fi

    shortened_path="${shortened_path}${current_component}/"
  done

  # Add the last path component unchanged
  shortened_path="${shortened_path}${components[-1]}/"

  # Prefix with "/" if it's not in $HOME
  if [[ ! "${components[1]}" == "~" ]]; then
    shortened_path="/${shortened_path}"
  fi

  echo $shortened_path;
}

abbreviated_pwd () {
  abbreviated_path $PWD
}

directory_name(){
  # Any "%" in $(abbreviated_pwd) must be escaped
  echo "%{$fg_bold[cyan]%}${$(abbreviated_pwd)//\%/%%}%{$reset_color%}"
}

export PROMPT=$'\n$(rb_prompt) in $(directory_name) $(git_dirty)$(need_push)\n› '
set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}$(todo)%{$reset_color%}"
}

precmd() {
  title "zsh" "%m:%1/\/" "%55<...<%~"
  set_prompt
}
