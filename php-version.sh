################################################################################
# name: php-version
# what: function that allows switching between compiled PHP versions
# why : there is nothing wrong with trying to keep it simple...
################################################################################

function php-version {
  local PROGRAM_APPNAME='php-version'
  local PROGRAM_VERSION=0.9.7

  # local variables
  local _PHP_VERSION=$1
  local _PHP_VERSIONS=${PHP_VERSIONS-''}

  # colors
  COLOR_NORMAL=$(tput sgr0)
  COLOR_REVERSE=$(tput smso)

  # bail-out if _PHP_VERSIONS does not exist
  if [[ -z $_PHP_VERSIONS ]]; then
    echo "Sorry, but $PROGRAM_APPNAME requires that \$PHP_VERSIONS is set and points to an existing directory or directories." >&2
    return 1
  fi

  # argument parsing
  case "$1" in

    -h|--help)

      echo "$PROGRAM_APPNAME $PROGRAM_VERSION" >&2
      echo ""                                      >&2
      echo "Usage  : $PROGRAM_APPNAME <version>"   >&2
      echo "Example: $PROGRAM_APPNAME 5.4.3"       >&2

      return 0
      ;;

    -v|--version)

      echo "$PROGRAM_APPNAME version $PROGRAM_VERSION" >&2

      return 0
      ;;

    "")

      _PHP_REPOSITORY=$(find $_PHP_VERSIONS -type d -maxdepth 1 -mindepth 1 -exec basename {} \; 2>/dev/null | sort -r -t . -k 1,1n -k 2,2n -k 3,3n)

      for version in $_PHP_REPOSITORY; do
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
  for _PHP_REPOSITORY in $_PHP_VERSIONS; do
    if [[ -d $_PHP_REPOSITORY/$_PHP_VERSION ]]; then
      local _PHP_ROOT=$_PHP_REPOSITORY/$_PHP_VERSION
      break;
    fi
  done

  # bail-out if we were unable to find a PHP matching given version
  if [[ -z $_PHP_ROOT ]]; then
    echo "Sorry, but $PROGRAM_APPNAME was unable to find directory '$_PHP_VERSION' under '$_PHP_VERSIONS'." >&2
    return 1
  fi

  # export current paths
  export PHP_VERSION=$_PHP_VERSION
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

################################################################################
# shell completion for php-version function
################################################################################

if [[ -z $PHP_VERSIONS ]]; then
  echo "Sorry, but php-version requires that the environment variable \$PHP_VERSIONS is set in order to initialize bash completion." >&2
  return 1
fi

if [[ ! -z $PHPVERSIONDISABLE_COMPLETE ]]; then
  return 1
fi

# completion for bash
if [[ -n ${BASH_VERSION-""} ]]; then
  _phpversions() {
    local CURRENTWD="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=()
    for _PHP_REPOSITORY in $PHP_VERSIONS; do
      COMPREPLY=("${COMPREPLY[@]}" $(compgen -d ${_PHP_REPOSITORY%/}/${CURRENTWD} | sed "s#${_PHP_REPOSITORY%/}/##g" ))
    done
  }

  complete -o nospace -F _phpversions php-version
  return $?
fi
