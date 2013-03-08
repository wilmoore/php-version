################################################################################
# name: php-version
# what: function that allows switching between compiled PHP versions
# why : there is nothing wrong with trying to keep it simple...
################################################################################

function php-version {
  local PROGRAM_APPNAME='php-version'
  local PROGRAM_VERSION=0.9.4

  # correct # of arguments?
  if [ $# != 1 ]; then
    echo "${PROGRAM_APPNAME} ${PROGRAM_VERSION}" >&2
    echo ""                                      >&2
    echo "Usage  : ${PROGRAM_APPNAME} <version>" >&2
    echo "Example: ${PROGRAM_APPNAME} 5.4.3"     >&2
    echo "Example: ${PROGRAM_APPNAME} 5.4"       >&2
    return 1
  fi

  # http://stackoverflow.com/a/4025065
  function vercomp {
      if [[ $1 == $2 ]]
      then
          return 0
      fi
      local IFS=.
      local i ver1=($1) ver2=($2)
      # fill empty fields in ver1 with zeros
      for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
      do
          ver1[i]=0
      done
      for ((i=0; i<${#ver1[@]}; i++))
      do
          if [[ -z ${ver2[i]} ]]
          then
              # fill empty fields in ver2 with zeros
              ver2[i]=0
          fi
          if ((10#${ver1[i]} > 10#${ver2[i]}))
          then
              return 1
          fi
          if ((10#${ver1[i]} < 10#${ver2[i]}))
          then
              return 2
          fi
      done
      return 0
  }

  function find_best_suitable_version {
    local _PHP_FOUND_VERSION=0
    local _PHP_VERSION_PATTERN="$1.*"

    for _PHP_REPOSITORY in $_PHP_VERSIONS; do
      _PHP_CANDIDATE_VERSIONS=$(ls -d ${_PHP_REPOSITORY}/${_PHP_VERSION_PATTERN} 2>/dev/null)

      for _PHP_CANDIDATE_VERSION in $_PHP_CANDIDATE_VERSIONS; do
        _PHP_CANDIDATE_VERSION=${_PHP_CANDIDATE_VERSION#$_PHP_REPOSITORY/}

        vercomp $_PHP_FOUND_VERSION $_PHP_CANDIDATE_VERSION
        if [[ $? == 2 ]]; then
          _PHP_FOUND_VERSION=$_PHP_CANDIDATE_VERSION
        fi
      done
    done

    echo $_PHP_FOUND_VERSION
  }

  # local variables
  local _PHP_VERSION=$1
  local _PHP_VERSIONS=${PHP_VERSIONS-''}

  # bail-out if _PHP_VERSIONS does not exist
  if [[ -z ${_PHP_VERSIONS} ]]; then
    echo "Sorry, but ${PROGRAM_APPNAME} requires that \$PHP_VERSIONS is set and points to an existing directory or directories." >&2
    return 1
  fi

  local _PHP_VERSION_PARTS=($(echo -e "$_PHP_VERSION" | sed "s#\.# #g"))
  if [[ ${#_PHP_VERSION_PARTS[@]} -lt 3 ]]; then
    _PHP_VERSION=$(find_best_suitable_version $_PHP_VERSION)
  fi

  for _PHP_REPOSITORY in $_PHP_VERSIONS; do
    if [[ -d ${_PHP_REPOSITORY}/${_PHP_VERSION} ]]; then
      local _PHP_ROOT=${_PHP_REPOSITORY}/${_PHP_VERSION}
      break;
    fi
  done

  # bail-out if _PHP_ROOT does not exist
  if [[ -z $_PHP_ROOT ]]; then
    echo "Sorry, but ${PROGRAM_APPNAME} was unable to find directory '${_PHP_VERSION}' under '${_PHP_VERSIONS}'." >&2
    return 1
  fi

  # safe to export these now!
  export PHP_VERSION=${_PHP_VERSION}
  export PHP_ROOT=${_PHP_ROOT}
  export PHPRC=${_PHP_ROOT}/etc/php.ini

  # add the "bin" and "sbin" paths to the front (prepend) of $PATH
  export PATH="${PHP_ROOT}/bin:${PHP_ROOT}/sbin:$PATH"

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

if [[ -z ${PHP_VERSIONS} ]]; then
  echo "Sorry, but php-version requires that the environment variable \$PHP_VERSIONS is set in order to initialize bash completion." >&2
  return 1
fi

if [[ ! -z ${PHPVERSIONDISABLE_COMPLETE} ]]; then
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
