php-version: stupid simple PHP version management
=================================================


**php-version** exposes a single command `php-version` allowing developers to switch between multiple versions of PHP.

**php-version** is conceptually similar to [rbenv](https://github.com/sstephenson/rbenv); however, **much** `simpler`.

**php-version** consists of a single function and shell completion.

**php-version** lives in a single file which can be sourced into your shell profile.

**php-version** considers leaky abstractions to be a huge flailing `fail`.


Who is it for?
----------------------------

**php-version** is primarily for developers that compile multiple versions of PHP on Linux or Mac.

**php-version** gets out of the way so you can work with `php` the same as if you only had a single version installed.


Who is it _NOT_ for?
----------------------------

If you are a super neck-beard academic, you are likely already doing this as `a matter of fact` as part of your normal workflow;
in which case, **php-version** is likely not going to be very interesting to you. I respect that :)


Rationale
----------------------------

**php-version** attempts to stick to the classic UNIX notion that tools should do one thing well.

>   While there are [smart](https://github.com/c9s/phpbrew) [alternative](https://github.com/CHH/phpenv)
>   [tools](http://sourceforge.net/p/phpfarm/wiki/Home/) that attempt to [solve](https://github.com/convissor/php_version_solution)
>   this problem, [none](http://www.gnu.org/s/stow/) of the tools I've found were simple enough for me.


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
-   does not attempt to compile, build, or install PHP. Several methods exist for accomplishing this; including,
    `manual build PHP from source`, [php-build](https://github.com/CHH/php-build), or [Homebrew-PHP](https://github.com/josegonzalez/homebrew-php)


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

Add the following script block to `$HOME/.bashrc`, `$HOME/.zshrc`, or your shell's equivalent configuration file:

**for standard installs (the comment block is optional)**

    ########################################################################################
    # php-version (activate default PHP version and autocompletion)
    # export PHP_VERSIONS                  => reflects location of compiled PHP versions
    # export PHPVERSION_DISABLE_COMPLETE=1 => to disable shell completion
    ########################################################################################
    export PHP_VERSIONS=${HOME}/local/php/versions
    [ -f $HOME/local/php-version/php-version.sh ] &&
      source $HOME/local/php-version/php-version.sh && php-version 5.4.3 >/dev/null

**for Homebrew installs (the comment block is optional)**

    ########################################################################################
    # php-version (activate default PHP version and autocompletion)
    # export PHP_VERSIONS                  => reflects location of compiled PHP versions
    # export PHPVERSION_DISABLE_COMPLETE=1 => to disable shell completion
    ########################################################################################
    export PHP_VERSIONS=$(dirname $(brew --prefix php))
    [ -f $(brew --prefix php-version)/php-version.sh ] &&
      source $(brew --prefix php-version)/php-version.sh && php-version 5.4.3 >/dev/null


Deactivate / Uninstall
----------------------------

**Remove Configuration**

From your `$HOME/.bashrc`, `$HOME/.zshrc`, or your shell's equivalent configuration file
remove the above mentioned configuration block.

**Remove Files**

    % rm -rf /path-to/php-version # or (brew uninstall php-version)


Switching Versions
----------------------------

**Call it like this in your terminal**

    $ php-version 5.4.3

**Bash Completion**

    % php-version 5.[PRESS-TAB-NOW]


Compilation Recommendations
----------------------------

The following directory structure is not required; however, it is a recommendation that you can modify to your liking.

    % mkdir -p $HOME/local/php/download/
    % mkdir -p $HOME/local/php/versions/${PHP_VERSION}/src/{ext,php}


**php-version** assumes that you intend to compile multiple PHP versions (though you could just have one) which will be
located under a common directory such as `$HOME/local/php/versions`. In this case, you'd compile PHP as follows:

    ./configure --prefix=$HOME/local/php/versions/${PHP_VERSION} && make && make install


**Example (PHP 5.4.3 installed)**

    % echo $PHP_VERSION

    5.4.3

    % cd $PHP_ROOT
    % pwd

    ~/local/php/versions/5.4.3/

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


FAQ
----------------------------

**Why is the name `php-version`?**

It was the simplest thing I could think of given [phpenv](https://github.com/CHH/phpenv) was already taken.

**What if my PHP versions are not stored neatly under a single directory like `$HOME/local/php/versions`?**

    % PHP_VERSIONS=/usr/local/Cellar/php php-version 5.4.3

    SWITCHED PHP VERSION TO: 5.4.3
    NEW PHP ROOT DIRECTORY : /usr/local/Cellar/php/5.4.3

    % which php

    /usr/local/Cellar/php/5.4.3/bin/php


Troubleshooting
----------------------------

**Sorry, but PHP version '#.#.#' is not installed under directory '$HOME/local/php/versions'.**

-   The version was entered incorrectly **(i.e. "php-version 5.3.i" instead of "php-version 5.4.3")**.

**Unable to initialize bash completion for php-version because $PHP_HOME is not set.**

-   The `$PHP_HOME` environment variable has not been configured or is configured incorrectly.


Alternatives
----------------------------

-   [phpbrew](https://github.com/c9s/phpbrew)
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


Roadmap
----------------------------

-   bin/* wrappers
    optional shell functions that "wrap" the original bin/* binaries: php,pear,pecl,phar,php-cgi,php-config,phpize
    if activated, a wrapper simply calls the binary with the parameters passed as-is in the context of a temporarily modified $PATH environment variable:

      PATH=$PHP_HOME/5.3.10/bin:$PATH which php
      PATH=$PHP_HOME/5.4.3/bin:$PATH which php

    The version to use is determined by a file in the `cwd` called .version


TODO
----------------------------

**php-version shell wrappers**

    check for .version file [semver]
     And version file has a version
       And version is in versions directory
         And php binary exists
    Execute binary

    If file not found, walk up until found or until root.

    Disablewrappers

