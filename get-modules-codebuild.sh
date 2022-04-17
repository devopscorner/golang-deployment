#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  Get Terraform Submodules (Inside CodeBuild)
# -----------------------------------------------------------------------------
#  Author     : DevOps Engineer (support@devopscorner.id)
#  License    : Apache v2
# -----------------------------------------------------------------------------
set -e

TITLE="TERRAFORM SUBMODULES"           # script name
VER="2.3"                              # script version

PATH_CODEBUILD="${CODEBUILD_SRC_DIR}"
SUBMODULE_TERRAFORM_COMMUNITY="${CODEBUILD_SRC_DIR}/module_community.lst"
SUBMODULE_TERRAFORM_OFFICIALS="${CODEBUILD_SRC_DIR}/module_officials.lst"
PATH_MODULES="${PATH_CODEBUILD}/terraform/modules/providers/aws"
PATH_MODULES_COMMUNITY="${PATH_MODULES}/community"
PATH_MODULES_OFFICIALS="${PATH_MODULES}/officials"

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

submodule_cleanup(){
  print_line2
  get_time
  echo "$COL_BLUE[ $DATE ] ##### Rebuild Submodule(s): $COL_END"

  cd ${PATH_CODEBUILD}
  rm -rf modules

  mkdir -p ${PATH_MODULES_COMMUNITY}
  mkdir -p ${PATH_MODULES_OFFICIALS}
  echo '- REBUILD DONE -'
}

submodule_terrafom_community() {
  print_line2
  get_time
  echo "$COL_BLUE[ $DATE ] ##### Download Community Submodule(s): $COL_END"
  submodule_download $PATH_MODULES_COMMUNITY $SUBMODULE_TERRAFORM_COMMUNITY
}

submodule_terrafom_officials() {
  print_line2
  get_time
  echo "$COL_BLUE[ $DATE ] ##### Download Officials Submodule(s): $COL_END"
  submodule_download $PATH_MODULES_OFFICIALS $SUBMODULE_TERRAFORM_OFFICIALS
}

submodule_download() {
  cd $1
  while IFS= read line; do
    get_time
    print_line2
    echo "$COL_GREEN[ $DATE ]       git clone --depth 1 $line $COL_END"
    print_line2
    # skip_exists $line
    git clone --depth 1 $line
    echo ""
  done <"$2"
  echo '- DOWNLOAD DONE -'
}

main() {
  header
  submodule_cleanup
  submodule_terrafom_community
  submodule_terrafom_officials
  footer
}

### START HERE ###
main $@
