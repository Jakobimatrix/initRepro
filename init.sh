#!/bin/bash
#
#Execute this script to install clang-format on your machine (if not installed)
#and install hook in your git repository to check formating before committing.
#
#usage: sudo ./init.sh PATH_TO_YOUR_REPOSITORY


CLANG_FORMAT_VERSION="18.0";
CLANG_TIDY_VERSION="18.0";
HOOK_FILE=".git/hooks/pre-commit";
HOOK_SCRIPT="templates/format_hook";
FORMAT_FILE_F="templates/.clang-format"
FORMAT_FILE_T="templates/.clang-tidy"
GIT_ATTRIBUTES_FILE="templates/.gitattributes"
CMAKE_LISTS_FILE="templates/CMakeLists.txt"
BUILD_FILE="templates/build.sh"
PROCECT_STRUCUR="templates/src/"

# validate input
REPRO="$1"

if [ $# -lt 1 ]
then
        echo "Usage: sudo ./init.sh PATH_TO_YOUR_REPOSITORY"
        exit
elif [ ! -d "$REPRO" ]
then
        echo "Given $REPRO does not exist!"
        exit
fi
SLASH_CHAR="/"
[ "${REPRO: -1}" != "$SLASH_CHAR" ] && REPRO=$REPRO$SLASH_CHAR

if [ ! -d "$REPRO.git/hooks/" ]
then
  echo "Given $REPRO is not a git repository"
  exit
fi

askYesNo() {
  echo; echo -e "\e[33m**********************\e[0m"; echo; 
  while true; do     
    read -p $'Do you want to \e[1;4;34m'"$task"$'\e[0m? [y/n]' yn
    case $yn in
      [Yy]* ) answer=1; break;; 
      [Nn]* ) answer=0; break;;
      * ) echo -e "\e[33mPlease answer yes or no.\e[0m";; 
    esac 
  done  
}

task="Do you want to installUpdate clang-format-$CLANG_FORMAT_VERSION and hooks"
askYesNo 
if [ $answer = 1  ]
then 
  HOOK_FILE=$REPRO$HOOK_FILE

  # install clang format
  apt install clang-format-$CLANG_FORMAT_VERSION -y

  # check if a pre-commit hook already exists
  if [ -f "$HOOK_FILE" ]
  then
    read -p "pre-commit (file) already exists. Should I [c]oncatinate, [o]verwrite or [e]xit?" coe
    case $coe in
      [Cc]* ) cat $HOOK_FILE $HOOK_SCRIPT > tmp.txt && mv tmp.txt $HOOK_FILE;;
      [Oo]* ) cp $HOOK_SCRIPT $HOOK_FILE;;
      [Ee]* ) exit;;
    esac
  else
    cp $HOOK_SCRIPT $HOOK_FILE
  fi

  cp $FORMAT_FILE_F $REPRO$FORMAT_FILE_F
  cp $FORMAT_FILE_T $REPRO$FORMAT_FILE_T

  chmod +x $HOOK_FILE
  echo "Clang-format installed in $HOOK_FILE"
fi

task="Do you want to install/update clang-tidy-$CLANG_TIDY_VERSION?"
askYesNo
if [ $answer = 1 ]
then
  apt install clang-tidy-$CLANG_TIDY_VERSION -y
  echo "clang-tidy-$CLANG_TIDY_VERSION"
fi

task="Do you want to install cppcheck?"
askYesNo
if [ $answer = 1 ]
then
  apt install cppcheck -y
  echo "cppcheck installed"
fi

task="Do you want to install valgrind?"
askYesNo
if [ $answer = 1 ]
then
  apt install valgrind -y
  echo "valgrind installed"
fi

task="Do you want to enforece LF line ending for that repro?"
askYesNo
if [ $answer = 1 ]
then
  cp $GIT_ATTRIBUTES_FILE $REPRO$GIT_ATTRIBUTES_FILE
  echo ".gitattributes installed, LF line ending enforeced" 
fi

echo "Dont continue if you already initiated your repo!"

task="Do you want to copy the Cmake project?"
askYesNo
if [ $answer = 1 ]
then
  if [ -f $REPRO$CMAKE_LISTS_FILE ]; then
    cp $CMAKE_LISTS_FILE $REPRO$CMAKE_LISTS_FILE
    echo "$CMAKE_LISTS_FILE installed"
  else
    echo "$CMAKE_LISTS_FILE already exists. Dont overwrite."
  fi
fi

task="Do you want to copy the build script?"
askYesNo
if [ $answer = 1 ]
then
  if [ -f $REPRO$BUILD_FILE ]; then
    cp $BUILD_FILE $REPRO$BUILD_FILE
    echo "$BUILD_FILE installed"
  else
    echo "$BUILD_FILE already exists. Dont overwrite."
  fi
fi

task="Do you want to copy the procect structure?"
askYesNo
if [ $answer = 1 ]
then
  if [ -d $REPRO$PROCECT_STRUCUR ]; then
    cp -r $PROCECT_STRUCUR $REPRO$PROCECT_STRUCUR
    echo "$PROCECT_STRUCUR installed"
  else
    echo "$PROCECT_STRUCUR already exists. Dont overwrite."
  fi
fi



