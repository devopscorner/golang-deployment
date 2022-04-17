#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  Get Official Terraform Submodules
# -----------------------------------------------------------------------------
#  Author     : DevOps Engineer DevOpsCornerId (support@devopscorner.id)
#  License    : Apache v2
# -----------------------------------------------------------------------------
set -e

TITLE="TERRAFORM OFFICIAL SUBMODULES" # script name
VER="2.3"                              # script version

PATH_FOLDER=$(pwd)
SUBMODULE_TERRAFORM="${PATH_FOLDER}/module_officials.lst"
PATH_MODULES="${PATH_FOLDER}/terraform/modules/providers/aws/officials"

COL_RED="\033[22;31m"
COL_GREEN="\033[22;32m"
COL_BLUE="\033[22;34m"
COL_END="\033[0m"

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

skip_exists() {
  if [[ -f "$1" ]]; then
    echo ">> Skip for existing file $1 ..."
  else
    git clone --depth 1 $1
  fi
}

submodule_terrafom() {
  print_line2
  get_time
  echo "$COL_BLUE[ $DATE ] ##### Download Official Submodule(s): $COL_END"

  cd $PATH_MODULES
  while IFS= read line; do
    get_time
    print_line2
    echo "$COL_GREEN[ $DATE ]       git clone --depth 1 $line $COL_END"
    print_line2
    # skip_exists $line
    git clone --depth 1 $line
    echo ""
  done <"$SUBMODULE_TERRAFORM"
  echo "- DOWNLOAD DONE -"
}

main() {
  header
  submodule_terrafom
  footer
}

### START HERE ###
main $@
