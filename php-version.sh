################################################################################
# php-version: function allowing one to switch between PHP versions
################################################################################

function php-version {
  local PROGRAM_APPNAME='php-version'
  local PROGRAM_VERSION=0.13.0
  local PROGRAM_DISPLAY_VERSION="$PROGRAM_APPNAME v$PROGRAM_VERSION"

  # colors
  COLOR_NORMAL=$(tput sgr0)
  COLOR_REVERSE=$(tput smso)

  # target version
  local _TARGET_VERSION=$1

  # PHP installation paths
  local _PHP_VERSIONS=""

  # use builtin commands for sort, grep and sed
  local grep="command grep -E"
  local sort="command sort -r -t . -k 1,1n -k 2,2n -k 3,3n"
  local sed="command sed -En"

  # add ~/.phps if it exists (default)
  if [[ -d $HOME/.phps ]]; then
    export _PHP_VERSIONS="$_PHP_VERSIONS $HOME/.phps"
  fi

  # add default Homebrew directories if brew is installed
  if [[ -n $(command -v brew) ]]; then
    export _PHP_VERSIONS="$_PHP_VERSIONS $(echo $(find $(brew --cellar) -maxdepth 1 -type d | $grep 'php[0-9]*$'))"
  fi

  # add extra directories if configured
  if [[ -n $PHP_VERSIONS ]]; then
    export _PHP_VERSIONS="$_PHP_VERSIONS $PHP_VERSIONS"
  fi

  # add installed PHP ports if MacPorts is installed
  if [[ -n $(command -v port) ]]; then
    # get the list of installed php* ports
    local _PORT_NAMES_="$(echo $(port -q installed | $sed 's;.*(php[0-9]. ).*$;\1;p'))"
    _PORT_VERSIONS=()
    _PORT_NAMES=()
    for _PORT_NAME in $(echo $_PORT_NAMES_ | tr " " "\n"); do
      local _PHP_CONFIG=$(port -q contents $_PORT_NAME | $grep "/bin/php-config${_PORT_NAME#php}$" | tr -d '[:blank:]')
      _PORT_VERSIONS=("${_PORT_VERSIONS[@]}" "$($_PHP_CONFIG --version 2>/dev/null)")
      _PORT_NAMES=("${_PORT_NAMES[@]}" "$_PORT_NAME")
    done
    _PORT_NAMES_=
  fi

  # export the space-separated string as array
  _PHP_REPOSITORIES=()
  for _PHP_VERSION in $(echo $_PHP_VERSIONS | tr " " "\n"); do
    _PHP_REPOSITORIES=("${_PHP_REPOSITORIES[@]}" $_PHP_VERSION)
  done

  # unset the string
  _PHP_VERSIONS=

  # argument parsing
  case "$1" in

    -h|--help|-u|--usage)

      echo $PROGRAM_DISPLAY_VERSION

      cat <<-USAGE

      Usage:
        $PROGRAM_APPNAME --help     Show this message
        $PROGRAM_APPNAME --version  Print the version
        $PROGRAM_APPNAME <version>  Modify PATH to use <version>
        $PROGRAM_APPNAME            Show all available versions and denote the currently activated version

      Example:
        $PROGRAM_APPNAME 5          Activate the latest available 5.x version
        $PROGRAM_APPNAME 5.5        Activate the latest available 5.5.x version
        $PROGRAM_APPNAME 5.5.13     Activate version 5.5.13 specifically

      Note:
        With MacPorts you should always specify only the <major>.<minor> versions, because you cannot
        install multiple patch versions for a given release

      Configuration Options:
        https://github.com/wilmoore/php-version#setup

      Uninstall:
        https://github.com/wilmoore/php-version#deactivate--uninstall

			USAGE

      return 0
      ;;

    -v|--version)

      echo $PROGRAM_DISPLAY_VERSION

      return 0
      ;;

    -*)

      printf "\e[0;31m%s: %s: unrecognized option\e[0m\n\n" $0 $1 >&2
      php-version --help >&2

      return 1
      ;;

    "")

      if [ "${#_PORT_VERSIONS[@]}" -gt "0" ]; then
        _PHP_VERSION=
        # check if PATH contains /.php-bin directory
        if [[ $PATH =~ "/.php-bin" ]]; then
          local _PHP_VERSION=$(php-config --version 2>/dev/null)
        fi

        # loop through all macports versions
        _N=0
        echo "MacPorts versions"
        echo "-----------------"
        for version in "${_PORT_VERSIONS[@]}"; do
          local selected=" "
          local color=$COLOR_NORMAL

          if [[ "$version" == "$_PHP_VERSION" ]]; then
            local selected="*"
            local color=$COLOR_REVERSE
          fi

          printf "${color}%s %s${COLOR_NORMAL} (port name: %s)\n" "$selected" "$version" "${_PORT_NAMES[$_N]}"

          _N=$(expr $_N + 1)
        done
        echo ""
        
        [[ $PATH =~ "/.php-bin" ]] && return 0
      fi

      # bail-out if _PHP_REPOSITORIES is an empty array
      if [ ${#_PHP_REPOSITORIES[@]} -eq 0 ]; then
        if [ ${#_PORT_VERSIONS[@]} -eq 0 ]; then
          echo 'Sorry, but you do not seem to have any PHP versions installed.' >&2
          echo 'See https://github.com/wilmoore/php-version#install for assistance.' >&2
          return 1
        fi
        return 0
      fi

      # Loop through all repositories and get every single php-version
      _PHP_VERSIONS=()
      for _PHP_REPOSITORY in "${_PHP_REPOSITORIES[@]}"; do
        for _dir in $(find $(echo $_PHP_REPOSITORY) -maxdepth 1 -mindepth 1 -type d 2>/dev/null); do
          _PHP_VERSIONS=("${_PHP_VERSIONS[@]}" "$($_dir/bin/php-config --version 2>/dev/null)")
        done
      done

      _PHP_VERSIONS=$(IFS=$'\n'; echo "${_PHP_VERSIONS[*]}" | eval $sort)

      for version in $(echo $_PHP_VERSIONS | tr " " "\n"); do
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
  for _PHP_REPOSITORY in "${_PHP_REPOSITORIES[@]}"; do
    if [[ -d "$_PHP_REPOSITORY/$_TARGET_VERSION" && -z $_PHP_ROOT ]]; then
      local _PHP_ROOT=$_PHP_REPOSITORY/$_TARGET_VERSION
      break;
    fi
  done

  # try a fuzzy match since we were unable to find a PHP matching given version
  if [[ -z $_PHP_ROOT ]]; then
    _TARGET_VERSION_FUZZY=()

    for _PHP_REPOSITORY in "${_PHP_REPOSITORIES[@]}"; do
      for _dir in $(find $_PHP_REPOSITORY -maxdepth 1 -mindepth 1 -type d 2>/dev/null); do
        _TARGET_VERSION_FUZZY=("${_TARGET_VERSION_FUZZY[@]}" "$($_dir/bin/php-config --version 2>/dev/null)")
      done
    done

    _TARGET_VERSION_FUZZY=$(IFS=$'\n'; echo "${_TARGET_VERSION_FUZZY[*]}" | eval $sort | eval "$grep '^$_TARGET_VERSION' 2>/dev/null" | tail -1)

    for _PHP_REPOSITORY in "${_PHP_REPOSITORIES[@]}"; do
      for _dir in $(find $_PHP_REPOSITORY -maxdepth 1 -mindepth 1 -type d 2>/dev/null); do
        _PHP_VERSION="$($_dir/bin/php-config --version 2>/dev/null)"
        if [[ -n "$_TARGET_VERSION_FUZZY" && "$_PHP_VERSION" == "$_TARGET_VERSION_FUZZY" ]]; then
          local _PHP_ROOT=$_dir
          break;
        fi
      done
    done
  fi

  # bail-out if we were unable to find a PHP matching given version
  if [[ -z $_PHP_ROOT ]]; then
    if [ "${#_PORT_VERSIONS[@]}" -gt "0" ]; then
      _TARGET_VERSION_FUZZY=$(IFS=$'\n'; echo "${_PORT_VERSIONS[*]}" | eval $sort | eval "$grep '^$_TARGET_VERSION' 2>/dev/null" | tail -1)

      if [[ -n "$_TARGET_VERSION_FUZZY" ]]; then
        _N=0
        for _PHP_VERSION in "${_PORT_VERSIONS[@]}"; do
          if [[ "$_PHP_VERSION" == "$_TARGET_VERSION_FUZZY" ]]; then
            local _PHP_BIN="$PWD/.php-bin"

            # create .php-bin directory if not exists, relative to current dir
            [[ -d "$_PHP_BIN" ]] || mkdir "$_PHP_BIN"
            # delete all symlinks in .php-bin directory starting with php*
            find "$_PHP_BIN" -type l -name "php*" -exec rm -f {} \;
            # create symlinks in .php-bin, one foreach port's php binary
            for _BIN_FILE in $(port -q contents ${_PORT_NAMES[$_N]} | $grep '/bin/php.*$' | tr -d '[:blank:]'); do
              ln -s "$_BIN_FILE" "$_PHP_BIN/$(basename "$_BIN_FILE" | $sed 's;([^0-9].)[0-9].$;\1;p')"
            done
            
            # append .php-bin to PATH
            export PATH="$_PHP_BIN:$PATH"
            # configure MANPATH
            local _MANPATH=$($_PHP_BIN/php-config --man-dir)
            [[ -d $_MANPATH && ! $MANPATH =~ "$_MANPATH" ]] && export MANPATH="$_MANPATH:$MANPATH"
            
            hash -r
            return 0;
          fi
          _N=$(expr $_N + 1)
        done
      fi

      echo "Sorry, but $PROGRAM_APPNAME was unable to find version '$1' in installed ports." >&2
      return 1        
    fi
    echo "Sorry, but $PROGRAM_APPNAME was unable to find version '$1' under '${_PHP_PATHS[@]}'." >&2
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
