php-version: stupid simple PHP version management
=================================================


**php-version** is a minimal shell helper giving PHP developers the ability to switch between compiled versions. It is
named "php-version" only because [phpenv](https://github.com/CHH/phpenv) was already taken.

**php-version** is heavily inspired by [rbenv](https://github.com/sstephenson/rbenv); however, **php-version** aims to
be even **simpler**. 

**php-version** is a shell function that is sourced into your profile (e.g. $HOME/.bashrc, $HOME/.bash_profile, etc.).


Who is it for?
---------------------------

**php-version** is primarily for developers that compile multiple versions of PHP on Linux or Mac.


Rationale
---------------------------

While there are [alternative](https://github.com/CHH/phpenv) [tools](http://sourceforge.net/p/phpfarm/wiki/Home/) that
attempt to [solve](https://github.com/convissor/php_version_solution) this problem, [none](http://www.gnu.org/s/stow/)
of the tools I've found were simple enough for me.

**php-version** attempts to stick to the classic UNIX notion that tools should one thing and do it well.


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


Pre-Install Recommendations
---------------------------

**The following directory structure is not required; however, this has worked extremely well for me.**

    % mkdir -p $HOME/local/php/download/
    % mkdir -p $HOME/local/php/versions/${PHP_VERSION}/src/{ext,php}


Download and Installation
---------------------------

**Git/Github**

    % cd $HOME/local
    % git clone https://github.com/wilmoore/php-version.git $HOME/local/php-version

**cURL**

    % mkdir -p $HOME/local/php-version
    % cd !$
    % curl -# -L https://github.com/wilmoore/php-version/tarball/master | tar -xz

**homebrew**

    % brew install https://raw.github.com/gist/1702891/s3dd.rb

    # -- or -- #

    % brew install --HEAD https://raw.github.com/gist/1702891/s3dd.rb


Setup and Configuration
---------------------------

**Activate Default PHP version**

In $HOME/.bashrc or $HOME/.bash_profile or equivalent (NOTE: the comment block is optional)

    ########################################################################################
    # php-version (activate default PHP version and autocompletion)
    ########################################################################################
    export PHP_VERSION_DEFAULT=5.3.9              # this version needs to exist before calling php-version
    export PHP_HOME=$HOME/local/php/versions      # should reflect location of compiled PHP versions
    source $HOME/local/php-version/php-version.sh
    php-version $PHP_VERSION_DEFAULT >/dev/null


Switching Versions
---------------------------

**Call it like this in your terminal**

    $ php-version 5.3.9

**Bash Completion**

    % php-version 5.<PRESS-TAB>


Troubleshooting
---------------------------

**Sorry, but PHP version '#.#.#' is not installed under directory '/Users/exampleuser/local/php/versions'.**

There are generally two reasons why this error has occurred.

-   The version was entered incorrectly **(i.e. "php-version 5.3.i" instead of "php-version 5.3.9")**.


**Unable to initialize bash completion for php-version because $PHP_HOME is not set.**

-   The $PHP_HOME environment variable has not been configured or is configured incorrectly.


Alternatives
---------------------------

-   [phpenv](https://github.com/CHH/phpenv)
-   [php_version_solution](https://github.com/convissor/php_version_solution)
-   [phpfarm](http://sourceforge.net/p/phpfarm/wiki/Home/)
-   [GNU Stow](http://www.gnu.org/s/stow/)

