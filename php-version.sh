################################################################################
# name: php-version
# what: function that allows switching between compiled PHP versions
# why : there was previously no easy and unobtrusive way to do this AFAIK
################################################################################

function php-version {
  local PROGRAM_APPNAME='php-version'
  local PROGRAM_VERSION=0.6.0

  # correct # of arguments?
  if [ $# != 1 ]; then
    echo "php-version ${PROGRAM_VERSION}" >&2
    echo ""                               >&2
    echo "Usage  : php-version <version>" >&2
    echo "Example: php-version 5.4.0RC6"  >&2
    return 1
  fi

  # local variables
  local _PHP_VERSION=$1
  local _PHP_HOME=${PHP_HOME-''}
  local _PHP_ROOT=${_PHP_HOME}/${_PHP_VERSION}

  # bail-out if _PHP_HOME does not exist
  if [[ ! -d ${_PHP_HOME} ]]; then
    echo "Sorry, but ${PROGRAM_APPNAME} requires that \$PHP_HOME is set and points to an existing directory." >&2
    return 1
  fi

  # bail-out if _PHP_ROOT does not exist
  if [[ ! -d $_PHP_ROOT ]]; then
    echo "Sorry, but ${PROGRAM_VERSION} was unable to find directory '${_PHP_VERSION}' under '${_PHP_HOME}'." >&2
    return 1
  fi

  # it is now safe to export these
  export PHP_VERSION=${_PHP_VERSION}
  export PHP_ROOT=${_PHP_ROOT}

  # update binary search path
  export PATH="$PHP_ROOT/bin:$PATH"

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
# completion for php-version function
################################################################################

if [[ ! -d ${PHP_HOME} ]]; then
  echo "Sorry, but php-version requires that \$PHP_HOME is set in order to initialize bash completion." >&2
  return 1
fi

if [[ ! -z ${PHPVERSION_DISABLE_COMPLETE} ]]; then
  return 1
fi

# for bash
if [[ -n ${BASH_VERSION-""} ]]; then
  complete -W "$(echo $(find ${PHP_HOME} -d -maxdepth 1 | sed -e "s@${PHP_HOME}[/]*@@" | grep -v '^$'))" php-version
fi
