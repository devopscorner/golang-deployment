#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  Docker Build Container
# -----------------------------------------------------------------------------
#  Author     : Dwi Fahni Denni (@zeroc0d3)
#  License    : Apache v2
# -----------------------------------------------------------------------------
set -e

TITLE="DOCKER BUILD CONTAINER SCRIPT" # script name
VER="3.1"                             # script version
ENV="0"                               # container environment (0 = development, 1 = staging, 2 = production)
SKIP_BUILD="0"                        # (0 = with build process, 1 = bypass build process)
REMOVE_CACHE="0"                      # (0 = using cache, 1 = no-cache)
RECREATE_CONTAINER="0"                # (0 = disable recreate container, 1 = force recreate container)
DAEMON_MODE="1"                       # (0 = disable daemon mode, 1 = running daemon mode / background)
CHMOD_DATA="0"                        # (0 = disable chmod 777 folder data, 1 = skip chmod 777 folder data)

USERNAME=$(echo $USER)
PATH_HOME=$(echo $HOME)

PATH_APP=$(pwd)
PATH_CONTAINER_DATA="$PATH_APP/data"
COMPOSE_PATH="$PATH_APP"
COMPOSE_APP="$COMPOSE_PATH/docker-compose.yml"

COL_RED="\033[22;31m"
COL_GREEN="\033[22;32m"
COL_BLUE="\033[22;34m"
COL_END="\033[0m"

export RUBY_VERSION="2.7.1"

get_time() {
  DATE=$(date '+%Y-%m-%d %H:%M:%S')
}

print_line0() {
  echo "$COL_GREEN=====================================================================================$COL_END"
}

print_line1() {
  echo "$COL_GREEN-------------------------------------------------------------------------------------$COL_END"
}

print_line2() {
  echo "-------------------------------------------------------------------------------------"
}

logo() {
  clear
  print_line0
  echo "$COL_RED'########:'########:'########:::'#######:::'######::::'#####:::'########:::'#######:: $COL_END"
  echo "$COL_RED..... ##:: ##.....:: ##.... ##:'##.... ##:'##... ##::'##.. ##:: ##.... ##:'##.... ##: $COL_END"
  echo "$COL_RED:::: ##::: ##::::::: ##:::: ##: ##:::: ##: ##:::..::'##:::: ##: ##:::: ##:..::::: ##: $COL_END"
  echo "$COL_RED::: ##:::: ######::: ########:: ##:::: ##: ##::::::: ##:::: ##: ##:::: ##::'#######:: $COL_END"
  echo "$COL_RED:: ##::::: ##...:::: ##.. ##::: ##:::: ##: ##::::::: ##:::: ##: ##:::: ##::...... ##: $COL_END"
  echo "$COL_RED: ##:::::: ##::::::: ##::. ##:: ##:::: ##: ##::: ##:. ##:: ##:: ##:::: ##:'##:::: ##: $COL_END"
  echo "$COL_RED ########: ########: ##:::. ##:. #######::. ######:::. #####::: ########::. #######:: $COL_END"
  echo "$COL_RED........::........::..:::::..:::.......::::......:::::.....::::........::::.......::: $COL_END"
  print_line1
  echo "$COL_GREEN# $TITLE :: ver-$VER $COL_END"
}

header() {
  logo
  print_line0
  get_time
  echo "$COL_RED# BEGIN PROCESS..... (Please Wait)  $COL_END"
  echo "$COL_RED# Start at: $DATE  $COL_END\n"
}

footer() {
  print_line0
  get_time
  echo "$COL_RED# Finish at: $DATE  $COL_END"
  echo "$COL_RED# END PROCESS.....  $COL_END\n"
}

chmod_data() {
  if [ "$CHMOD_DATA" = "1" ]; then
    sudo chmod 777 -R $PATH_CONTAINER_DATA
  fi
}

build_env() {
  if [ "$ENV" = "0" ]; then
    BUILD_ENV="$CONTAINER_DEVELOPMENT"
  elif [ "$ENV" = "1" ]; then
    BUILD_ENV="$CONTAINER_STAGING"
  else
    BUILD_ENV="$CONTAINER_PRODUCTION"
  fi
}

cache() {
  if [ "$REMOVE_CACHE" = "0" ]; then
    CACHE=""
  else
    CACHE="--no-cache "
  fi
}

recreate() {
  if [ "$RECREATE_CONTAINER" = "0" ]; then
    RECREATE=""
  else
    RECREATE="--force-recreate "
  fi
}

daemon_mode() {
  if [ "$DAEMON_MODE" = "0" ]; then
    DAEMON=""
  else
    DAEMON="-d "
  fi
}

prepare_volume() {
  print_line2

  VOL_PATH="/opt/data/docker"

  # VOL_CONTAINER="$VOL_PATH/airflow/dags \
  # $VOL_PATH/airflow/logs \
  # $VOL_PATH/airflow/plugins \
  # $VOL_PATH/postgresql14/pgdata \
  # $VOL_PATH/portainer"

  get_time
  echo "$COL_BLUE[ $DATE ] ##### Prepare Volume Container: $COL_END"
  echo "$COL_GREEN[ $DATE ]       sudo mkdir -p [vol_docker]\n"

  # for VOL in $VOL_CONTAINER; do
  #   get_time
  #   print_line2
  #   echo "$COL_GREEN[ $DATE ]       sudo mkdir -p $VOL $COL_END"
  #   print_line2
  #   sudo mkdir -p $VOL
  #   echo '- DONE -'
  # done

  sudo chmod -R 777 $VOL_PATH
  echo "-- VOLUME DONE --"
  echo ''
}

docker_build() {
  if [ "$SKIP_BUILD" = "0" ]; then
    print_line2
    get_time
    echo "$COL_BLUE[ $DATE ] ##### Docker Compose Build: $COL_END"
    echo "$COL_GREEN[ $DATE ]       docker-compose -f $COMPOSE_APP build $CACHE$BUILD_ENV $COL_END\n"

    for CONTAINER in $BUILD_ENV; do
      get_time
      print_line2
      echo "$COL_GREEN[ $DATE ]       docker-compose -f $COMPOSE_APP build $CONTAINER $COL_END"
      print_line2
      docker-compose -f $COMPOSE_APP build $CONTAINER
      echo '- DONE -'
      echo ''
    done
  fi
  echo "-- BUILD DONE --"
  echo ''
}

docker_up() {
  daemon_mode
  print_line2
  get_time
  echo "$COL_BLUE[ $DATE ] ##### Docker Compose Up: $COL_END"
  echo "$COL_GREEN[ $DATE ]       docker-compose -f $COMPOSE_APP up $DAEMON $RECREATE$BUILD_ENV $COL_END\n"
  get_time
  print_line2
  echo "$COL_GREEN[ $DATE ]       docker-compose -f $COMPOSE_APP up $DAEMON $RECREATE$BUILD_ENV $COL_END"
  print_line2
  docker-compose -f $COMPOSE_APP up $DAEMON $RECREATE$BUILD_ENV
  echo "-- UP DONE --"
  echo ''
}

main() {
  header
  cache
  recreate
  build_env
  #prepare_volume
  docker_build
  docker_up
  footer
  # chmod_data
}

### START HERE ###
main $@
