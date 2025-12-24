#!/bin/bash

if [[ "$1" == "-h" ]]
then
cat << EOF
$0 (tag) (command)

will start interactive shell for tag  if command empty

or

will run with the command provided 
EOF
exit 0
fi

PWD=$(pwd)
. ${PWD}/.myconfig.sh
tag=${1:-$tag}
shift
case $USER in
  codespace)
  WORKSPACE=/workspaces
  ;;
  *)
  WORKSPACE=$PWD
  ;;
esac
  
# pull the docker if necessary

docker pull $dockerrepo:$tag

# map the cache
if [[ -d .cache ]] ; then
  export DOCKEREXTRA="$DOCKEREXTRA -v $PWD/.cache:/home/rstudio/.cache"
fi
# Dropbox stuff
if [[ ! -z $DROPBOX_SECRET_BASE ]]; then export DOCKEREXTRA="$DOCKEREXTRA -e DROPBOX_SECRET_BASE=$DROPBOX_SECRET_BASE" ; fi
if [[ ! -z $DROPBOX_SECRET_RLKEY ]]; then export DOCKEREXTRA="$DOCKEREXTRA -e DROPBOX_SECRET_RLKEY=$DROPBOX_SECRET_RLKEY" ; fi



DOCKEREXTRA="$DOCKEREXTRA --entrypoint /bin/bash"
docker run $DOCKEREXTRA -v "$WORKSPACE":/home/rstudio/${PWD##*/} --rm  $dockerrepo:$tag $@
