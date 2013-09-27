# simple PHP version switching

**php-version** exposes a single `php-version` command allowing developers to switch between multiple versions of PHP. It is conceptually similar to [rbenv](https://github.com/sstephenson/rbenv); however, **much** `simpler` consisting of a single function which can be sourced into your shell profile.

![](http://i.cloudup.com/Rl7FXze6ra.png)


## This _IS_ for you if

-   You are not satisifed with heavy handed *AMP installers.
-   You [use multiple][homebrew-php] [versions][php-build] of PHP on Linux or Mac.
-   You download [pre-compiled PHP binaries for Windows][windows-bin].
-   You want to run your automated tests against multiple PHP versions.
-   You are a developer that works on a variety of PHP projects each requiring different versions of PHP.
-   You want to work on the latest PHP, but expect to support prior work that was done on older PHP versions.


## This is _NOT_ for you if

-   You are content with heavy handed *AMP installers.
-   You are provisioning a production server so you only need a single PHP install.
-   You **NEVER** work on more than one PHP project at a time.
-   You don't plan on supporting prior work that was done on other PHP versions.


## Rationale

**php-version** attempts to stick to the classic UNIX notion that tools should do one thing well.

>   While there are [smart](https://github.com/c9s/phpbrew) [alternative](https://github.com/CHH/phpenv)
>   [tools](http://sourceforge.net/p/phpfarm/wiki/Home/) that attempt to [solve](https://github.com/convissor/php_version_solution)
>   this problem, [none](http://www.gnu.org/s/stow/) of the tools I've found were simple enough for me.


## Features

-   [Homebrew installed PHP versions][homebrew-php] and PHP verions installed into `~/.phps` are picked up automatically.
-   **snap versioning**: type or add `php-version 5` to your shell configuration and the latest installed 5.x version will always be used.
-   **per version `php.ini`**: we `export PHPRC` if a version-specific `php.ini` exists.
-   **configurable**: `php-version --help` for details.
-   **bash and zsh** supported.
-   **tiny**: less than 200 lines of `bash` shell scripting.


## Non-Features

-   no [shims][], sub-shells, symlinks or `cd` [hooks][].
-   we won't leave files and symlinks all over the place.
-   does not attempt to manage Apache, MySQL, etc.
-   does not attempt to compile, build, or install PHP.


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


## Install

**homebrew** (recommended for OSX users)

    % brew tap homebrew/dupes
    % brew tap josegonzalez/homebrew-php
    % brew install php-version

**cURL** (for non-OSX users or those that prefer not to use `homebrew`):

    % mkdir -p $HOME/local/php-version # or your place of choice
    % cd !$
    % curl -# -L https://github.com/wilmoore/php-version/tarball/master | tar -xz --strip 1

[Alternative (i.e. non-Homebrew) installation methods][opt-install] are documented on the wiki.


## Setup

Add one of the following to `$HOME/.bashrc`, `$HOME/.zshrc`, or your shell's equivalent configuration file:

    # Homebrew (recommended)
    source $(brew --prefix php-version)/php-version.sh && php-version 5
      
    # non-Homebrew
    source $HOME/local/php-version/php-version.sh && php-version 5

Type `php-version --help` for more configuration options such as how to add extra PHP installation paths or `php-config --version` to find out which `php` version is active.


## Deactivate / Uninstall

1. Remove [setup](https://github.com/wilmoore/php-version#setup) configuration.

2. Enter one of the following commands listed below to remove associated files.

        # Homebrew (recommended)
        % brew remove --force php-version

        # non-Homebrew
        % rm -rf $HOME/local/php-version


## Resources

**General**

-   [Exploring PHP][exploring]
-   [Troubleshooting][trouble]

**Options for Installing PHP**

-   [homebrew-php][homebrew-php] (recommended)
-   [php-build][php-build]


## Contributors

```
99  Wil Moore III
 3  Jason P. Scharf
 3  Tugdual Saunier
 1  Gábor Egyed
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

  MIT



[php-build]:    https://github.com/CHH/php-build
[homebrew-php]: https://github.com/josegonzalez/homebrew-php
[windows-bin]:  http://windows.php.net/download
[windows-port]: https://github.com/wilmoore/php-version/issues/2
[manual-build]: https://github.com/wilmoore/php-version#compilation-recommendations
[shims]:        https://github.com/sstephenson/rbenv#understanding-shims
[hooks]:        https://rvm.io/workflow/hooks
[opt-install]:  https://github.com/wilmoore/php-version/wiki/Installing
[exploring]:    https://github.com/wilmoore/php-version/wiki/Exploring-PHP
[trouble]:      https://github.com/wilmoore/php-version/wiki/Troubleshooting

