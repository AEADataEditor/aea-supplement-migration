repo=tidyverse
space=rocker
dockerrepo=$(echo $space/$repo | tr [A-Z] [a-z] | sed 's/-internal//')
case $USER in
  vilhuber)
  #WORKSPACE=$HOME/Workspace/git/
  WORKSPACE=$PWD
  ;;
  codespace)
  WORKSPACE=/workspaces
  ;;
esac
tag=4.5.1
