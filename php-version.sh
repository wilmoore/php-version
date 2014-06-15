################################################################################
# php-version: function allowing one to switch between PHP versions
################################################################################

function php-version {
  local PROGRAM_APPNAME='php-version'
  local PROGRAM_VERSION=0.10.4

  # colors
  COLOR_NORMAL=$(tput sgr0)
  COLOR_REVERSE=$(tput smso)

  # target version
  local _TARGET_VERSION=$1

  # PHP installation paths
  local _PHP_VERSIONS=""

  # add ~/.phps if it exists (default)
  if [[ -d $HOME/.phps ]]; then
    export _PHP_VERSIONS="$_PHP_VERSIONS $HOME/.phps"
  fi

  # add default Homebrew directories if brew is installed
  if [[ -n $(command -v brew) ]]; then
    export _PHP_VERSIONS="$_PHP_VERSIONS $(echo $(find $(brew --cellar) -maxdepth 1 -type d | grep -E 'php[0-9]*$'))"
  fi

  # add extra directories if configured
  if [[ -n $PHP_VERSIONS ]]; then
    export _PHP_VERSIONS="$_PHP_VERSIONS $PHP_VERSIONS"
  fi

  # argument parsing
  case "$1" in

    -h|--help)

	cat <<-USAGE

	$PROGRAM_APPNAME $PROGRAM_VERSION

	Usage:
		$PROGRAM_APPNAME --help     Show this message
		$PROGRAM_APPNAME --version  Print the version
		$PROGRAM_APPNAME <version>  Modify PATH to use <version>
		$PROGRAM_APPNAME            Show all available versions and denote the currently activated version

	Example:
		$PROGRAM_APPNAME 5          Activate the latest available 5.x version
		$PROGRAM_APPNAME 5.5        Activate the latest available 5.5.x version
		$PROGRAM_APPNAME 5.5.13     Activate version 5.5.13 specifically

	Configuration Options:
		https://github.com/wilmoore/php-version#setup

	Uninstall:
		https://github.com/wilmoore/php-version#deactivate--uninstall

	USAGE

      return 0
      ;;

    -v|--version)

      echo "$PROGRAM_APPNAME version $PROGRAM_VERSION"

      return 0
      ;;

    "")

      # bail-out if _PHP_VERSIONS is empty
      if [[ -z $_PHP_VERSIONS ]]; then
        echo 'Sorry, but you do not seem to have any PHP versions installed.' >&2
        echo 'See https://github.com/wilmoore/php-version#install for assistance.' >&2
        return 1
      fi

      _PHP_REPOSITORY=$(find $(echo $_PHP_VERSIONS) -maxdepth 1 -mindepth 1 -type d -exec basename {} \; 2>/dev/null | sort -r -t . -k 1,1n -k 2,2n -k 3,3n)

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
    _TARGET_VERSION_FUZZY=$(find $(echo $_PHP_VERSIONS) -maxdepth 1 -mindepth 1 -type d -exec basename {} \; 2>/dev/null | sort -r -t . -k 1,1n -k 2,2n -k 3,3n | grep -E "^$_TARGET_VERSION" 2>/dev/null | tail -1)

    for _PHP_REPOSITORY in $(echo $_PHP_VERSIONS); do
      if [[ -n "$_TARGET_VERSION_FUZZY" && -d $_PHP_REPOSITORY/$_TARGET_VERSION_FUZZY ]]; then
        local _PHP_ROOT=$_PHP_REPOSITORY/$_TARGET_VERSION_FUZZY
        break;
      fi
    done
  fi

  # bail-out if we were unable to find a PHP matching given version
  if [[ -z $_PHP_ROOT ]]; then
    echo "Sorry, but $PROGRAM_APPNAME was unable to find version '$1' under '$_PHP_VERSIONS'." >&2
    return 1
  fi

  # export current paths
  export PHPRC=""
  [[ -f $_PHP_ROOT/etc/php.ini ]] && export PHPRC=$_PHP_ROOT/etc/php.ini
  [[ -d $_PHP_ROOT/bin  ]]        && export PATH="$_PHP_ROOT/bin:$PATH"
  [[ -d $_PHP_ROOT/sbin ]]        && export PATH="$_PHP_ROOT/sbin:$PATH"

  # use configured manpath if it exists, otherwise, use `$_PHP_ROOT/share/man`
  local _MANPATH=$(php-config --man-dir)
  [[ -z $_MANPATH ]] && _MANPATH=$_PHP_ROOT/share/man
  [[ -d $_MANPATH ]] && export MANPATH="$_MANPATH:$MANPATH"

  hash -r
}

