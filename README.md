php-version: stupid simple PHP version management
=================================================


What is it?
---------------------------

**php-version** is a minimal shell helper giving PHP developers the ability to switch between compiled versions. It is
named "php-version" only because "(phpenv)[https://github.com/CHH/phpenv]" was already taken.

**php-version** is heavily inspired by (rbenv)[https://github.com/sstephenson/rbenv]; however, **php-version** aims to
be even **simpler**. 

**php-version** is a shell function that is sourced into your profile (e.g. $HOME/.bashrc, $HOME/.bash_profile, etc.).


Who is it for?
---------------------------

"php-version" is primarily for developers that compile multiple versions of PHP on Linux or Mac.

**NOTE TO WINDOWS USERS**

While this is primarily a Linux/Mac tool, it is theoretically possible to port this to Windows since we are simply
updating the "PATH" environment variable to allow so the newly added path is checked first. I do not intend on
writing this port anytime soon; however, I will accept a pull request if it looks solid.


Rationale
---------------------------

While there are alternative tools that attempt to solve this problem, none of them were simple enough for my taste.
"php-version" sticks to the classic UNIX notion that tools should perform a single task and perform it well.


Features
---------------------------

-   no magic
-   promotes multiple, per-user PHP installs (though, it won't stop you from having a system-wide PHP install)
-   focuses on just PHP (e.g. not apache, mysql, etc.)
-   shell completion (php-version 5.<PRESS-TAB>)
-   unobtrusive install/uninstall
-   no magic


Non-Features
---------------------------

-   does not compile/install PHP. This is left up to you.
-   does not attempt to manage Apache, MySQL, etc.
-   does not rely on symlinks
-   does not support 


Usage Examples
---------------------------

**Switch to a specific PHP version**

    $ php-version <version>

**List installed PHP version(s)**

    $ ls $PHP_HOME

**List the active PHP version**

    $ echo $PHP_VERSION

**Identify full path to:**

    $ which php

    $ which pear

    $ which pecl

    $ which phar

    $ which php-cgi

    $ which php-config

    $ which phpize

**View manual pages**

    $ man php

    $ man php-fpm

    $ man php-config

    $ man phpize


Assumptions
---------------------------

#   PHP versions are installed to: $HOME/local/php/versions/${PHP_VERSION}


Pre-Install Recommendations
---------------------------

The following directory structure is not required; however, this has worked extremely well for me.

  % mkdir -p $HOME/local/php/download/
  % mkdir -p $HOME/local/php/versions/${PHP_VERSION}/src/{ext,php}


Installation
---------------------------

**Manually**

    $ wget -c https://raw.github.com/wilmoore/master/phpver -O $HOME/local/bin/phpver
    $ chmod a+x !$
    $ which phpver
    $ export PHP_HOME=$HOME/local/php # put this into your shell profile

*   You may alternatively install the 'phpver' binary into a directory
    other than $HOME/local/bin; however, just be sure you update your
    search path accordingly.
*   You may alternatively change the default PHP_HOME to a location of
    your choosing.



Add to search path
---------------------------

In order to be able to execute the "php" binary without typing in the
full path, you will have to add the PHP "bin" directory to your shell
profile (e.g. .profile, .bash_profile, .bashrc, etc.). The PHP version
specified in the "PHP_VERSION" environment variable will be the default
php version in the shell.

Below is one example of how this might be achieved:

  export PHP_VERSION=5.3.9
  export PHP_HOME=$HOME/local/php
  export PHP_ROOT=$PHP_HOME/$PHP_VERSION
  export PATH="$PHP_ROOT/bin:$PATH"
  export MANPATH="$PHP_ROOT/man:$MANPATH"
  export MANPATH="$PHP_ROOT/share/man:$MANPATH"


Switching Versions
---------------------------

**Add to your shell profile**

  ########################################################################################
  # switch PHP version
  #
  # this can be invoked multiple times. non-existing paths will be ignored. Multiple paths
  # are OK as the last one to be added is the one that will be used.
  ########################################################################################

  function php-version {
      local PHP_VERSION=$1
      local PHP_HOME=$HOME/local/php
      local PHP_ROOT=$PHP_HOME/$PHP_VERSION

      if [[ -d $PHP_ROOT ]]; then
        export PATH="$PHP_ROOT/bin:$PATH"
        export MANPATH="$PHP_ROOT/man:$MANPATH"
        export MANPATH="$PHP_ROOT/share/man:$MANPATH"
      fi
  }

**Call it like this in your terminal**

  $ php-version 5.3.9

**Bash Completion**


Alternatives
---------------------------

*   (phpenv)[https://github.com/CHH/phpenv]
*   (php_version_solution)[https://github.com/convissor/php_version_solution]
*   (phpfarm)[http://sourceforge.net/p/phpfarm/wiki/Home/]
*   (GNU Stow)[http://www.gnu.org/s/stow/]



















Download and Installation
---------------------------

**Git/Github**

  % cd $HOME/local
  % git clone https://github.com/wilmoore/php-version.git $HOME/local/php-version

**cURL**

  % curl -Ls https://raw.github.com/...

**wget**

  % wget https://raw.github.com/... -O ...

**homebrew**

  % brew install https://gist.github.com/...


Setup and Configuration
---------------------------

**Activate Default PHP version**

In $HOME/.bashrc or $HOME/.bash_profile or equivalent

  ########################################################################################
  # php-version (activate default PHP version and autocompletion)
  ########################################################################################
  source $HOME/local/php-version/php-version.sh

  export PHP_VERSION_DEFAULT=5.3.9
  export PHP_HOME=$HOME/local/php
  php-version $PHP_VERSION_DEFAULT >/dev/null


Switching between versions
---------------------------

...


Troubleshooting
---------------------------

**Sorry, but PHP version '#.#.#' is not installed under directory '/Users/exampleuser/local/php/versions'.**

There are generally two reasons why this error has occurred.

-   The version was entered incorrectly (i.e. "php-version 5.3.i" instead of "php-version 5.3.9".
-   The root directory has not been configured or is configured incorrectly. This can happen if you have not
    installed PHP under the recommended directory ($HOME/local/php/versions/) and have also not configured a
    "PHP_HOME" environment variable. This can be corrected by either:

    # in-line
    % PHP_HOME=$HOME/local/php php-version 5.4.0-rc6


    # ...
    % export PHP_HOME $HOME/local/php
