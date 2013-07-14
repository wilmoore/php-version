# php-version: stupid simple PHP version management

**php-version** exposes a single command `php-version` allowing developers to switch between multiple versions of PHP.

**php-version** is conceptually similar to [rbenv](https://github.com/sstephenson/rbenv); however, **much** `simpler`.

**php-version** consists of a single function and command completion.

**php-version** lives in a single file which can be sourced into your shell profile.


## This _IS_ for you if

- You are not satisifed with installers with *AMP in the name.
- You [compile multiple versions][php-build] of PHP on Linux or Mac.
- You download [pre-compiled PHP binaries for Windows][windows-bin] ([coming soon][windows-port]).
- You are not happy that the default PHP installation sprays a bunch of seemingly random files across your filesystem.


## This is _NOT_ for you if

- You dig installers with *AMP in the name.
- You think the command-line is stupid and hard.
- You are 100% sure you will only ever need a single global version of PHP installed at once.


## Rationale

**php-version** attempts to stick to the classic UNIX notion that tools should do one thing well.

>   While there are [smart](https://github.com/c9s/phpbrew) [alternative](https://github.com/CHH/phpenv)
>   [tools](http://sourceforge.net/p/phpfarm/wiki/Home/) that attempt to [solve](https://github.com/convissor/php_version_solution)
>   this problem, [none](http://www.gnu.org/s/stow/) of the tools I've found were simple enough for me.


**php-version** is excellent for automated testing of applications against multiple PHP versions on a single machine.


## Features

-   keeps it simple...no magic
-   promotes multiple, per-user PHP installs
-   shell completion (e.g. php-version 5.[PRESS-TAB-NOW])
-   provides access to the manpages of the current version by updating your `$MANPATH` environment variable
-   defers to native shell commands where possible (e.g. `man phpize`)
-   unobtrusive install/uninstall (we won't leave files and symlinks all over the place)
-   gets out of the way so you can work with `php` the same as if you had a single version installed.


## Non-Features

-   does not rely on symlinks or sub-shells
-   does not attempt to manage Apache, MySQL, etc.
-   does not attempt to compile, build, or install PHP. Current options are **(1)** [php-build][php-build], **(2)** [homebrew-php][homebrew-php], or **(3)** [manually build PHP from source][manual-build].


## Usage Examples

### Switch to a specific PHP version

    % php-version <version>

### List installed and active (*) PHP version(s)

    % php-version
      5.3.9
      5.3.10
      5.4.0RC8
      5.4.0RC6
      5.4.0
    * 5.4.8

### Identify full path to PHP binaries

    % which php

    % which php-fpm

    % which pear

    % which pecl

    % which phar

    % which php-cgi

    % which php-config

    % which phpize

### View manual pages

    % man php

    % man php-fpm

    % man php-config

    % man phpize


## Download and Installation

**Git/Github**

    % cd $HOME/local
    % git clone https://github.com/wilmoore/php-version.git

**homebrew**

Using homebrew-php (`brew tap josegonzalez/homebrew-php`)

    % brew install php-version

Via Github Gist

    % brew install https://raw.github.com/gist/1702891/php-version.rb

**Manual/cURL**

    % mkdir -p $HOME/local/php-version
    % cd !$
    % curl -# -L https://github.com/wilmoore/php-version/tarball/master | tar -xz --strip 1


## Activate Default PHP version

Add the following script block to `$HOME/.bashrc`, `$HOME/.zshrc`, or your shell's equivalent configuration file (the comment block is optional):

### for standard installs

    ########################################################################################
    # php-version (activate default PHP version and autocompletion)
    # export PHP_VERSIONS                  => reflects location of compiled PHP versions
    # export PHPVERSION_DISABLE_COMPLETE=1 => to disable shell completion
    ########################################################################################
    export PHP_VERSIONS=$HOME/local/php/versions
    source $HOME/local/php-version/php-version.sh && php-version 5.x.x >/dev/null

Change `5.x.x` to the version of PHP you'd like your shell to default to or remove `php-version 5.x.x >/dev/null` if you do not wish to have a default version of PHP loaded into your `$PATH`.

### for Homebrew installs

    ########################################################################################
    # php-version (activate default PHP version and autocompletion)
    # export PHP_VERSIONS                  => reflects location of compiled PHP versions
    # export PHPVERSION_DISABLE_COMPLETE=1 => to disable shell completion
    ########################################################################################
    export PHP_VERSIONS=$(dirname $(brew --prefix php))
    source $(brew --prefix php-version)/php-version.sh && php-version 5.x.x >/dev/null

Change `5.x.x` to the version of PHP you'd like your shell to default to or remove `php-version 5.x.x >/dev/null` if you do not wish to have a default version of PHP loaded into your `$PATH`.

## Deactivate / Uninstall

**Remove Configuration**

From your `$HOME/.bashrc`, `$HOME/.zshrc`, or your shell's equivalent configuration file
remove the above mentioned configuration block.

**Remove Files**

    % rm -rf /path-to/php-version # or (brew uninstall php-version)


## Switching Versions

**Call it like this in your terminal**

    $ php-version 5.4.3

**Bash Completion**

    % php-version 5.[PRESS-TAB-NOW]


## Compilation Recommendations

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


## Troubleshooting

**How should I configure `$PHP_VERSIONS` if my PHP versions are stored multiple directories (i.e. Homebrew)?**

-   Set `$PHP_VERSIONS` as a space-delimited, quoted list of directories as depicted below:

        export PHP_VERSIONS="/usr/local/Cellar/php53 /usr/local/Cellar/php54"

**Sorry, but `php-version` requires that `$PHP_VERSIONS` is set and points to an existing directory.'.**

-   The version was entered incorrectly **(i.e. "php-version 5.3.i" instead of "php-version 5.4.3")**.

**Sorry, but `php-version` was unable to find directory '5.4.3' under ...**

-   You have not installed the requested version of PHP.

**Sorry, but `php-version` requires that the environment variable `$PHP_VERSIONS` is set in order to initialize bash completion.**

-   The `$PHP_VERSIONS` environment variable has not been configured or is configured incorrectly.


## Contributors

```
86  Wil Moore III
 3  Tugdual Saunier
 1  Martin Lundberg
```

## Alternatives

-   [phpbrew](https://github.com/c9s/phpbrew)
-   [phpenv](https://github.com/CHH/phpenv)
-   [phpenv](https://github.com/humanshell/phpenv)
-   [php_version_solution](https://github.com/convissor/php_version_solution)
-   [phpfarm](http://sourceforge.net/p/phpfarm/wiki/Home/)
-   [GNU Stow](http://www.gnu.org/s/stow/)
-   [Encap](http://www.encap.org/)


## Inspiration

-   [n](https://github.com/visionmedia/n)
-   [nvm](https://github.com/creationix/nvm)
-   [rbenv](https://github.com/sstephenson/rbenv)
-   [rbfu](https://github.com/hmans/rbfu)
-   [ry](https://github.com/jayferd/ry)


## LICENSE

    (The MIT License)

    Copyright (c) 2013 Wil Moore III <wil.moore@wilmoore.com>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is furnished
    to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.





[php-build]:    https://github.com/CHH/php-build
[homebrew-php]: https://github.com/josegonzalez/homebrew-php
[windows-bin]:  http://windows.php.net/download
[windows-port]: https://github.com/wilmoore/php-version/issues/2
[manual-build]: https://github.com/wilmoore/php-version#compilation-recommendations
