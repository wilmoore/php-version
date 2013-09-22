################################################################################
# name: php-version
# what: function that allows switching between compiled PHP versions
# why : there is nothing wrong with trying to keep it simple...
################################################################################

function php-version {
  local PROGRAM_APPNAME='php-version'
  local PROGRAM_VERSION=0.9.10

  # colors
  COLOR_NORMAL=$(tput sgr0)
  COLOR_REVERSE=$(tput smso)

  # target version
  local _TARGET_VERSION=$1
  local _TARGET_VERSION_FUZZY

  # PHP installation paths
  local _PHP_VERSIONS=""

  # Set Local _PHP_ROOT_LOCAL
  local _PHP_ROOT_LOCAL

  # add ~/.phps if it exists (default)
  if [[ -d $HOME/.phps ]]; then
    export _PHP_VERSIONS="$_PHP_VERSIONS $HOME/.phps"
  fi

  # add default Homebrew directories if brew is installed
  if [[ -n $(command -v brew) ]]; then
    export _PHP_VERSIONS="$_PHP_VERSIONS $(echo $(find $(brew --cellar) -maxdepth 1 -type d | grep -E 'php[0-9]+$'))"
  fi

  # add extra directories if configured
  if [[ -n $PHP_VERSIONS ]]; then
    export _PHP_VERSIONS="$_PHP_VERSIONS $PHP_VERSIONS"
  fi

  # get list of all php versions currently in $PATH
  if [[ -n $(command -v php) ]]; then
    local _LINKED_PHP_PATHS
    local _LINKED_PHP_VERSIONS
    local _LINKED_PHP_PATH_DUPLICATE
    _LINKED_PHP_PATHS=$(which -a php 2>/dev/null | sort -u)
    # Removed Paths already in $_PHP_VERSIONS
    _LINKED_PHP_PATHS=$(echo "$_LINKED_PHP_PATHS $_PHP_VERSIONS $_PHP_VERSIONS" | tr " " "\n" | sort | uniq -u)

    # Get versions for linked php binaries
    for linkedPHP in $(echo $_LINKED_PHP_PATHS); do
      _LINKED_PHP_VERSIONS="$_LINKED_PHP_VERSIONS $($linkedPHP --version 2>/dev/null | grep --only-matching --max-count=1 -E "[0-9]*\.[0-9]*\.[0-9]*")"
    done
  fi

  # clean up leading and trailing whitespace
  _PHP_VERSIONS=$(echo $_PHP_VERSIONS |  sed -e 's/^[[:space:]]*//')
  _LINKED_PHP_VERSIONS=$(echo $_LINKED_PHP_VERSIONS |  sed -e 's/^[[:space:]]*//')

  # bail-out if _PHP_VERSIONS and _LINKED_PHP_PATHS are empty
  if [[ -z $_PHP_VERSIONS && -z $_LINKED_PHP_PATHS ]]; then
    echo 'Sorry, but you do not seem to have any PHP versions installed.' >&2
    echo 'See https://github.com/wilmoore/php-version#install for assistance.' >&2
    return 1
  fi

  # argument parsing
  case "$1" in

    -h|--help)

      echo "$PROGRAM_APPNAME $PROGRAM_VERSION"                              >&2
      echo ''                                                               >&2
      echo "Usage: $PROGRAM_APPNAME <version>"                              >&2
      echo ''                                                               >&2
      echo '  Examples:'                                                    >&2
      echo ''                                                               >&2
      echo "    $PROGRAM_APPNAME 5"                                         >&2
      echo ''                                                               >&2
      echo "    $PROGRAM_APPNAME 5.5"                                       >&2
      echo ''                                                               >&2
      echo "    $PROGRAM_APPNAME 5.5.3"                                     >&2
      echo ''                                                               >&2
      echo ''                                                               >&2
      echo 'CONFIGURATION EXAMPLES'                                         >&2
      echo ''                                                               >&2
      echo '  PHP_VERSIONS'                                                 >&2
      echo '    space-delimited list of additional PHP install paths'       >&2
      echo ''                                                               >&2
      echo '    non-Homebrew:'                                              >&2
      echo '    export PHP_VERSIONS="~/.phps ~/local/php/versions"'         >&2
      echo ''                                                               >&2


      return 0
      ;;

    -v|--version)

      echo "$PROGRAM_APPNAME version $PROGRAM_VERSION" >&2

      return 0
      ;;

    "")

      _PHP_REPOSITORY=$(find $(echo $_PHP_VERSIONS) -maxdepth 1 -mindepth 1 -type d -exec basename {} \; 2>/dev/null | sort -r -t . -k 1,1n -k 2,2n -k 3,3n)

      # add system php to list
      _PHP_REPOSITORY=$(echo " $_LINKED_PHP_VERSIONS $_PHP_REPOSITORY" | tr " " "\n" | sort -r -u -t . -k 1,1n -k 2,2n -k 3,3n)

      for version in $(echo $_PHP_REPOSITORY); do
        
        local selected=" "
        local color=$COLOR_NORMAL

        if [[ "$version" == "$(php-config --version 2>/dev/null)" ]]; then
          local selected="*"
          local color=$COLOR_REVERSE
        fi

        printf "${color}%s %s${COLOR_NORMAL}\n" "$selected" "$version"
      done

      return 0
      ;;

  esac

  # locate selected PHP version
  for _PHP_REPOSITORY in $(echo $_PHP_VERSIONS); do
    if [[ -d "$_PHP_REPOSITORY/$_TARGET_VERSION" && -z $_PHP_ROOT ]]; then
      local _PHP_ROOT=$_PHP_REPOSITORY/$_TARGET_VERSION
      break;
    fi
  done

  # try a fuzzy match since we were unable to find a PHP matching given version
  if [[ -z $_PHP_ROOT ]]; then

    _TARGET_VERSION_FUZZY=$(find $(echo $_PHP_VERSIONS) -maxdepth 1 -mindepth 1 -type d -exec basename {} \; 2>/dev/null | sort -r -t . -k 1,1n -k 2,2n -k 3,3n | grep ^$_TARGET_VERSION 2>/dev/null | tail -1)

    for _PHP_REPOSITORY in $(echo $_PHP_VERSIONS); do
      if [[ -n "$_TARGET_VERSION_FUZZY" && -d $_PHP_REPOSITORY/$_TARGET_VERSION_FUZZY ]]; then
        _TARGET_VERSION=$_TARGET_VERSION_FUZZY
        local _PHP_ROOT=$_PHP_REPOSITORY/$_TARGET_VERSION_FUZZY
        break;
      fi
    done
  fi


  # if the selected version is in the system list, set its path [exact match]
  local _LINKED_PHP_VERSION_MATCH
  if [[ -n $(echo "$_TARGET_VERSION $_LINKED_PHP_VERSIONS" | tr " " "\n" | sort | uniq -d) ]]; then
    for linkedPHP in $(echo $_LINKED_PHP_PATHS); do
      _LINKED_PHP_VERSION_MATCH_TEST=$($linkedPHP --version 2>/dev/null | grep --only-matching --max-count=1 -E "[0-9]*\.[0-9]*\.[0-9]*")
      if [[ "$_LINKED_PHP_VERSION_MATCH_TEST" == "$_TARGET_VERSION" && -z $_PHP_ROOT ]]; then
        local _PHP_ROOT="$linkedPHP"
      fi
    done
  fi

  # if the selected version is in the system list, set its path [fuzzy match]
  if [[ -z $_PHP_ROOT ]]; then
    _TARGET_VERSION_FUZZY=$(echo "$_LINKED_PHP_VERSIONS" | sort -r -t . -k 1,1n -k 2,2n -k 3,3n | tr " " "\n" | grep ^$_TARGET_VERSION 2>/dev/null | tail -1)
    for linkedPHP in $(echo $_LINKED_PHP_PATHS); do
      _LINKED_PHP_VERSION_MATCH_TEST=$($linkedPHP --version 2>/dev/null | grep --only-matching --max-count=1 -E "[0-9]*\.[0-9]*\.[0-9]*")
      if [[ "$_LINKED_PHP_VERSION_MATCH_TEST" == "$_TARGET_VERSION_FUZZY" ]]; then
        _TARGET_VERSION=$_TARGET_VERSION_FUZZY
        local _PHP_ROOT="$linkedPHP"
      fi
    done
  fi

  # bail-out if we were unable to find a PHP matching given version
  if [[ -z $_PHP_ROOT ]]; then
    echo "Sorry, but $PROGRAM_APPNAME was unable to find version '$1' under '$_PHP_VERSIONS'." >&2
    return 1
  fi

  # Cleanup existing php paths and ini configuration
  #PATH=$(echo $PATH | sed -e 's/[^:]*php[0-9]*:*//g' )
  PATH=$(echo "$PATH" | sed -e 's/[^:]*php[0-9]*[^:]*\/bin:*//g')
  PHPRC=""
 
  export PHP_VERSION=$_TARGET_VERSION
  export PHP_ROOT=$_PHP_ROOT
  [[ -f $_PHP_ROOT/etc/php.ini ]] && export PHPRC=$_PHP_ROOT/etc/php.ini
  [[ -d $PHP_ROOT/bin  ]]         && export PATH="$PHP_ROOT/bin:$PATH"
  [[ -d $PHP_ROOT/sbin ]]         && export PATH="$PHP_ROOT/sbin:$PATH"

  # use configured manpath if it exists, otherwise, use `$PHP_ROOT/share/man`
  local _MANPATH=$(php-config --man-dir)
  [[ -z $_MANPATH ]] && _MANPATH=$PHP_ROOT/share/man
  [[ -d $_MANPATH ]] && export MANPATH="$_MANPATH:$MANPATH"

  echo "SWITCHED PHP VERSION TO: $PHP_VERSION"
  echo "NEW PHP ROOT DIRECTORY : $PHP_ROOT"
}

