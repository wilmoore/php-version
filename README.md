# simple PHP version switching

**php-version** exposes a `php-version` command allowing developers to switch between versions of PHP.

![](https://i.cloudup.com/Rl7FXze6ra.png)

## This _IS_ for you if

- You are not satisifed with heavy handed \*AMP or PPA-based installers.
- You [use multiple][homebrew-php] [versions][php-build] of PHP on Linux or Mac.
- You download [pre-compiled PHP binaries for Windows][windows-bin] (**NOTE**: this is a [bash] script so you'll need [WSL]).
- You want to run your automated tests against multiple PHP versions.
- You are a developer that works on a variety of PHP projects each requiring different versions of PHP.
- You want to work on the latest PHP, but expect to support prior work that was done on older PHP versions.

## This is _NOT_ for you if

- You are content with heavy handed \*AMP installers.
- You are provisioning a production server so you only need a single PHP install.
- You **NEVER** work on more than one PHP project at a time.
- You don't plan on supporting prior work that was done on other PHP versions.

## Rationale

**php-version** attempts to stick to the classic UNIX notion that tools should do one thing well.

> While there are [smart](https://github.com/c9s/phpbrew) [alternative](https://github.com/CHH/phpenv)
> [tools](https://sourceforge.net/p/phpfarm/wiki/Home/) that attempt to [solve](https://github.com/convissor/php_version_solution)
> this problem, [none](https://www.gnu.org/s/stow/) of the tools I've found were simple enough for me.

## Features

- [Homebrew installed PHP versions][homebrew-php] are picked up automatically.
- PHP versions installed [into `~/.phps`][build-php-vers] are picked up automatically.
- PHP versions listed in the `$PHP_VERSIONS` shell variable are picked up automatically.
- **snap versioning**: Use a partial version number (i.e. `php-version 5`) to automatically use the latest 5.x version.
- **per version `php.ini`**: we `export PHPRC` if a version-specific `php.ini` exists.
- **configurable**: `php-version --help` for details.
- **[bash], [zsh], and [fish]** shells actively supported; though care has been taken such that other shells are _likely_ to work as well.
- **tiny**: less than 200 LOC; a single function sourced via your shell's initialization file.

## Non-Features

- no [shims][], sub-shells, symlinks or `cd` [hooks][].
- we won't leave files and symlinks all over the place.
- does not attempt to manage Apache, MySQL, etc.
- does not attempt to compile, build, or install PHP.
- does not attempt to support OS package manager installed (i.e. ppa, etc.) PHP versions.

## Usage Examples

### Switch to a specific PHP version

    % php-version <version>

### List installed and active (\*) PHP version(s)

    % php-version
      5.3.9
      5.3.10
      5.4.0RC8
      5.4.0RC6
      5.4.0
    * 5.4.8

## Install

**[homebrew](https://brew.sh/)** (recommended for OSX users)

    % brew tap wilmoore/formulae
    % brew install php-version

**cURL** (for non-OSX users or those that prefer not to use `homebrew`):

    % mkdir -p $HOME/local/php-version # or your place of choice
    % cd !$
    % curl -# -L https://github.com/wilmoore/php-version/tarball/master | tar -xz --strip 1

[Alternative (i.e. non-Homebrew) installation methods][opt-install] are documented on the wiki.

## Setup

> Add one of the following to your shell's initialization file:

    # Homebrew (recommended)
    source $(brew --prefix php-version)/php-version.sh
    php-version 5

    # non-Homebrew
    source $HOME/local/php-version/php-version.sh # or your place of choice
    php-version 5

Type `php-version --help` for more configuration options such as how to add extra PHP installation paths or `php-config --version` to find out which `php` version is active.

> If you have PHP versions in multiple directories, you can list them in the environment variable `PHP_VERSIONS` separated by spaces as depicted below:

    export PHP_VERSIONS="$HOME/local/php $HOME/php/versions"

**NOTE**: do this before you source `php-version.sh`:

## Deactivate / Uninstall

1.  Remove [setup](https://github.com/wilmoore/php-version#setup) configuration.

2.  Enter one of the following commands listed below to remove associated files.

        # Homebrew (recommended)
        % brew remove --force php-version

        # non-Homebrew
        % rm -rf $HOME/local/php-version

## Having Issues?

1.  Copy the bug report output to your clipboard (`pbcopy` works on Mac OSX; use your OS equivalent)

        % cd /tmp
        % git clone https://github.com/wilmoore/php-version.git
        % source php-version/bug-report.sh | pbcopy

2.  File an [issue](https://github.com/wilmoore/php-version/issues?state=open).

## More Info

- [Building PHP Versions][build-php-vers]
- [Exploring PHP][exploring]
- [Troubleshooting][trouble]

## Contributors

> https://github.com/wilmoore/php-version/graphs/contributors

## Alternatives

- [brew-php-switcher](https://github.com/philcook/brew-php-switcher)
- [phpbrew](https://github.com/c9s/phpbrew)
- [phpenv](https://github.com/CHH/phpenv)
- [phpenv](https://github.com/humanshell/phpenv)
- [php_version_solution](https://github.com/convissor/php_version_solution)
- [phpfarm](https://sourceforge.net/p/phpfarm/wiki/Home/)
- [GNU Stow](https://www.gnu.org/s/stow/)
- [phpswitch](https://github.com/jubianchi/phpswitch)

## Inspiration

- [n](https://github.com/visionmedia/n)
- [nvm](https://github.com/creationix/nvm)
- [rbenv](https://github.com/sstephenson/rbenv)
- [rbfu](https://github.com/hmans/rbfu)
- [ry](https://github.com/jayferd/ry)

## LICENSE

MIT

[bash]: https://www.gnu.org/software/bash/
[build-php-vers]: https://github.com/wilmoore/php-version/wiki/Building-PHP-Versions
[exploring]: https://github.com/wilmoore/php-version/wiki/Exploring-PHP
[fish]: https://fishshell.com/
[homebrew-php]: https://github.com/josegonzalez/homebrew-php
[hooks]: https://rvm.io/workflow/hooks
[manual-build]: https://github.com/wilmoore/php-version#compilation-recommendations
[opt-install]: https://github.com/wilmoore/php-version/wiki/Installing
[php-build]: https://github.com/CHH/php-build
[shims]: https://github.com/sstephenson/rbenv#understanding-shims
[trouble]: https://github.com/wilmoore/php-version/wiki/Troubleshooting
[windows-bin]: http://windows.php.net/download
[windows-port]: https://github.com/wilmoore/php-version/issues/2
[wsl]: https://docs.microsoft.com/en-us/windows/wsl/install-win10
[zsh]: https://www.zsh.org/
