################################################################################
# name: php-version
# what: function that allows switching between compiled PHP versions
# why : there is nothing wrong with trying to keep it simple...
################################################################################

function php-version {
  local PROGRAM_APPNAME='php-version'
  local PROGRAM_VERSION=0.9.0

  # correct # of arguments?
  if [ $# != 1 ]; then
    echo "${PROGRAM_APPNAME} ${PROGRAM_VERSION}" >&2
    echo ""                                      >&2
    echo "Usage  : ${PROGRAM_APPNAME} <version>" >&2
    echo "Example: ${PROGRAM_APPNAME} 5.4.3"     >&2
    return 1
  fi

  # local variables
  local _PHP_VERSION=$1
  local _PHP_VERSIONS=${PHP_VERSIONS-''}
  local _PHP_ROOT=${_PHP_VERSIONS}/${_PHP_VERSION}

  # bail-out if _PHP_VERSIONS does not exist
  if [[ ! -d ${_PHP_VERSIONS} ]]; then
    echo "Sorry, but ${PROGRAM_APPNAME} requires that \$PHP_VERSIONS is set and points to an existing directory." >&2
    return 1
  fi

  # bail-out if _PHP_ROOT does not exist
  if [[ ! -d $_PHP_ROOT ]]; then
    echo "Sorry, but ${PROGRAM_VERSION} was unable to find directory '${_PHP_VERSION}' under '${_PHP_VERSIONS}'." >&2
    return 1
  fi

  # safe to export these now!
  export PHP_VERSION=${_PHP_VERSION}
  export PHP_ROOT=${_PHP_ROOT}

  # add the "bin" path to the front (prepend) of $PATH
  export PATH="${PHP_ROOT}/bin:$PATH"

  # find php manpath
  local _MANPATH=$(php-config --man-dir)
  if [ -z $_MANPATH ]; then
    _MANPATH=${PHP_ROOT}/share/man
  fi

  # prepend $_MANPATH to $MANPATH if the directory exists
  if [ -d $_MANPATH ]; then
    export MANPATH="${_MANPATH}:$MANPATH"
  fi

  echo "SWITCHED PHP VERSION TO: ${PHP_VERSION}"
  echo "NEW PHP ROOT DIRECTORY : ${PHP_ROOT}"
}


################################################################################
# shell completion for php-version function
################################################################################

if [[ ! -d ${PHP_VERSIONS} ]]; then
  echo "Sorry, but php-version requires that the environment variable \$PHP_VERSIONS is set in order to initialize bash completion." >&2
  return 1
fi

if [[ ! -z ${PHPVERSIONDISABLE_COMPLETE} ]]; then
  return 1
fi

_PHPVERSION_OPTIONS="$(echo $(find ${PHP_VERSIONS} -d -maxdepth 1 | sed -e "s@${PHP_VERSIONS}[/]*@@" | grep -v '^$'))"

# completion for zsh
if [[ -n ${ZSH_VERSION-""} ]]; then
  _arguments "1: :(${_PHPVERSION_OPTIONS})"
  return $?
fi

# completion for bash
if [[ -n ${BASH_VERSION-""} ]]; then
  complete -W "${_PHPVERSION_OPTIONS}" php-version
  return $?
fi


