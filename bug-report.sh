################################################################################
# bug-report: collect environment information for bug reports.
# % source bug-report.sh
################################################################################

cat <<-EOF
## System

  $(uname -a)

## Script

  TYPE:    $(command -v php-version 2>/dev/null || echo 'NOT FOUND')
  VERSION: $(php-version --version  2>/dev/null || echo 'NOT FOUND')

## Environment

  SHELL:        $(echo $SHELL)
  PATH:         $(echo $PATH)
  PHPS:         $(find ~/.phps -maxdepth 1 -mindepth 1 -type d 2>/dev/null)
  PHP_VERSIONS: $(echo $PHP_VERSIONS)

## Homebrew

  VERSION: $(test -n `command -v brew` && brew --version)
  PATH:    $(command -v brew)
  PHPS:    $(find $(brew --cellar) -maxdepth 1 -type d | grep -E 'php[0-9]+$')

## PHP

  VERSION: $(php-config --version)

## INI

$(php --ini | sed 's/^/  /')

EOF
