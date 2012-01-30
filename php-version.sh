################################################################################
# name: php-version
# what: function that allows switching between compiled PHP versions
# why : there was previously no easy and unobtrusive way to do this AFAIK
################################################################################

function php-version {
    local $PROGRAM_VERSION=0.0.1

    # correct # of arguments?
    if (($# != 1)); then
        echo "$0 version $PROGRAM_VERSION"
        echo ""
        echo "Usage  : $0 <version>"
        echo "Example: $0 5.4.0RC6"
        return 1
    fi

    # local variables
    local PHP_VERSION=$1
    local PHP_ROOT=${PHP_HOME:=$HOME/local/php/versions}/$PHP_VERSION

    # bail-out if PHP_ROOT does not exist
    if [[! -d $PHP_ROOT ]]; then
        echo "Sorry, but PHP version '${PHP_VERSION}' is not installed."
        return 1
    fi

    # update binary search path
    export PATH="$PHP_ROOT/bin:$PATH"

    # update manpage search path
    export MANPATH="$PHP_ROOT/man:$MANPATH"
    export MANPATH="$PHP_ROOT/share/man:$MANPATH"
}
