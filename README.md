php-version: stupid simple PHP version management
=================================================


**php-version** exposes a single command `php-version` allowing developers to switch between multiple versions of PHP.

**php-version** is conceptually similar to [rbenv](https://github.com/sstephenson/rbenv); however, **much** `simpler`.

**php-version** consists of a single function and shell completion.

**php-version** lives in a single file which can be sourced into your shell profile.


Who is it for?
----------------------------

**php-version** is primarily for developers that compile multiple versions of PHP on Linux or Mac.

**php-version** gets out of the way so you can work with `php` the same as if you only had a single version installed.


Rationale
----------------------------

**php-version** attempts to stick to the classic UNIX notion that tools should do one thing well.

>   While there are [alternative](https://github.com/CHH/phpenv) [tools](http://sourceforge.net/p/phpfarm/wiki/Home/) that
>   attempt to [solve](https://github.com/convissor/php_version_solution) this problem, [none](http://www.gnu.org/s/stow/)
>   of the tools I've found were simple enough for me.

**php-version** is excellent for automated testing of applications against multiple PHP versions on a single machine.


Features
----------------------------

-   keeps it simple...no magic
-   promotes multiple, per-user PHP installs
-   shell completion (e.g. php-version 5.[PRESS-TAB-NOW])
-   provides access to the manpages of the current version by updating your `$MANPATH` environment variable
-   defers to native shell commands where possible (e.g. `man phpize`)
-   unobtrusive install/uninstall (we won't leave files and symlinks all over the place)


Non-Features
----------------------------

-   does not rely on symlinks or sub-shells
-   does not attempt to manage Apache, MySQL, etc.
-   does not compile/install PHP. This is left up to you or you can use something like (php-build)[https://github.com/CHH/php-build]


Usage Examples
----------------------------

**Switch to a specific PHP version**

    % php-version <version>

**List installed PHP version(s)**

    % ls $PHP_HOME

**List the active PHP version**

    % echo $PHP_VERSION

**Identify full path to:**

    % which php

    % which pear

    % which pecl

    % which phar

    % which php-cgi

    % which php-config

    % which phpize

**View manual pages**

    % man php

    % man php-fpm

    % man php-config

    % man phpize


Pre-Install Recommendations
----------------------------

The following directory structure is not required; however, it is a sane default and works well. If you install PHP with
your system's package-manager (or `homebrew`), you may have to make some changes to the recommended directory structure.

    % mkdir -p $HOME/local/php/download/
    % mkdir -p $HOME/local/php/versions/${PHP_VERSION}/src/{ext,php}

**Example (PHP 5.3.9 installed)**

    % echo $PHP_VERSION

    5.3.9

    % cd $PHP_ROOT
    % pwd

    ~/local/php/versions/5.3.9/

    % ls

    drwxr-xr-x  11 wilmoore  staff   374B Jan 30 04:02 .
    drwxr-xr-x   4 wilmoore  staff   136B Jan 30 03:13 ..
    drwxr-xr-x  11 wilmoore  staff   374B Jan 30 04:05 bin
    drwxr-xr-x   5 wilmoore  staff   170B Jan 30 04:03 etc
    drwxr-xr-x   3 wilmoore  staff   102B Jan 30 04:12 etc.d
    drwxr-xr-x   3 wilmoore  staff   102B Jan 30 04:02 include
    drwxr-xr-x   3 wilmoore  staff   102B Jan 30 04:02 lib
    drwxr-xr-x   3 wilmoore  staff   102B Jan 30 04:02 sbin
    drwxr-xr-x   4 wilmoore  staff   136B Jan 30 04:02 share
    drwxr-xr-x   4 wilmoore  staff   136B Jan 30 03:13 src
    drwxr-xr-x   4 wilmoore  staff   136B Jan 30 04:02 var


Download and Installation
----------------------------

**Git/Github**

    % cd $HOME/local
    % git clone https://github.com/wilmoore/php-version.git

**cURL**

    % mkdir -p $HOME/local/php-version
    % cd !$
    % curl -# -L https://github.com/wilmoore/php-version/tarball/master | tar -xz --strip 1

**homebrew**

    % brew install https://raw.github.com/gist/1702891/php-version.rb


Activate Default PHP version
----------------------------

In `$HOME/.bash_profile` or equivalent (NOTE: the comment block is optional)

    ########################################################################################
    # php-version (activate default PHP version and autocompletion)
    ########################################################################################
    export PHP_VERSION_DEFAULT=5.3.9              # this version needs to exist before calling php-version
    export PHP_HOME=$HOME/local/php/versions      # should reflect location of compiled PHP versions
    source $HOME/local/php-version/php-version.sh
    php-version $PHP_VERSION_DEFAULT >/dev/null


Deactivate / Uninstall
----------------------------

**Remove Configuration**

From your `$HOME/.bash_profile` or equivalent; remove the call to `php-version`, `source php-version.sh`,
and the `following variables` (of course, keep the variables if you re-use them otherwise):

1.  PHP_VERSION_DEFAULT
2.  PHP_HOME

**Remove Files**

    % rm -rf /path-to/php-version # or (brew uninstall php-version)


Using (Switching Versions)
----------------------------

**Call it like this in your terminal**

    $ php-version 5.3.9

**Bash Completion**

    % php-version 5.[PRESS-TAB-NOW]


FAQ
----------------------------

**Why is the name `php-version`?**

It was the simplest thing I could think of given [phpenv](https://github.com/CHH/phpenv) was already taken.

**What if my PHP versions are not stored neatly under a single directory like `$HOME/local/php/versions`?**


    % PHP_HOME=/usr/local/Cellar/php php-version 5.4.0RC7

    SWITCHED PHP VERSION TO: 5.4.0RC7
    NEW PHP ROOT DIRECTORY : /tmp/php//5.4.0RC7

    % which php

    /usr/local/Cellar/php/5.4.0RC7/bin/php


Troubleshooting
----------------------------

**Sorry, but PHP version '#.#.#' is not installed under directory '$HOME/local/php/versions'.**

-   The version was entered incorrectly **(i.e. "php-version 5.3.i" instead of "php-version 5.3.9")**.

**Unable to initialize bash completion for php-version because $PHP_HOME is not set.**

-   The `$PHP_HOME` environment variable has not been configured or is configured incorrectly.


Alternatives
----------------------------

-   [phpenv](https://github.com/CHH/phpenv)
-   [php_version_solution](https://github.com/convissor/php_version_solution)
-   [phpfarm](http://sourceforge.net/p/phpfarm/wiki/Home/)
-   [GNU Stow](http://www.gnu.org/s/stow/)
-   [Encap](http://www.encap.org/)

Inspiration
----------------------------

-   [n](https://github.com/visionmedia/n)
-   [rbenv](https://github.com/sstephenson/rbenv)
-   [ry](https://github.com/jayferd/ry)

