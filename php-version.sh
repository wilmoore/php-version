################################################################################
# name: php-version
# what: function that allows switching between compiled PHP versions
# why : there was previously no easy and unobtrusive way to do this AFAIK
################################################################################

function php-version {
    local PROGRAM_VERSION=0.0.1

    # correct # of arguments?
    if (($# != 1)); then
        echo "php-version ${PROGRAM_VERSION}" >&2
        echo ""                               >&2
        echo "Usage  : php-version <version>" >&2
        echo "Example: php-version 5.4.0RC6"  >&2
        return 1
    fi

    # local variables
    local _PHP_VERSION=$1
    local _PHP_HOME=${PHP_HOME-$HOME/local/php/versions}
    local _PHP_ROOT=${_PHP_HOME}/${_PHP_VERSION}

    # bail-out if _PHP_ROOT does not exist
    if [[ ! -d $_PHP_ROOT ]]; then
        echo "Sorry, but PHP version '${_PHP_VERSION}' is not installed under directory '${_PHP_HOME}'." >&2
        return 1
    fi

    # it is now safe to export these
    export PHP_VERSION=${_PHP_VERSION}
    export PHP_ROOT=${_PHP_ROOT}

    # update binary search path
    export PATH="$PHP_ROOT/bin:$PATH"

    # update manpage search path
    export MANPATH="$PHP_ROOT/man:$MANPATH"
    export MANPATH="$PHP_ROOT/share/man:$MANPATH"

    echo "SWITCHED PHP VERSION TO: ${PHP_VERSION}"
    echo "NEW PHP ROOT DIRECTORY : ${PHP_ROOT}"
}


################################################################################
# bash completion for php-version function
################################################################################

# bash shell
if [[ ! -d ${PHP_HOME} ]]; then
    echo "Unable to initialize bash completion for php-version because \$PHP_HOME is not set." >&2
    return 1
fi

if [[ -n ${BASH_VERSION-""} ]]; then
    complete -W "$(echo $(find ${PHP_HOME} -d -maxdepth 1 | sed -e "s@${PHP_HOME}[/]*@@" | grep -v '^$'))" php-version
fi

