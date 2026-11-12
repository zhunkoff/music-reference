English | [Русский](BUILD.ru.md)

# Building PDFs

This guide covers tool installation on Windows, Linux, and macOS, and building the
documents from their TeX sources. Return to the [project overview](README.md).

## Requirements

Project commands are defined in `justfile` and use `latexmk` to run LuaLaTeX as many
times as needed. The guitar chord chart uses TikZ, Babel with English and Russian
language data, and DejaVu Sans Condensed in regular and bold weights.
[latexmk documentation](https://www.cantab.net/users/johncollins/latexmk/index.html).

| Component | TeX Live package |
| --- | --- |
| Build automation | `latexmk` |
| LuaLaTeX engine and Lua font loading | `luatex`, `luaotfload` |
| TikZ diagrams | `pgf` |
| Language support | `babel`, `babel-english`, `babel-russian` |
| English and Russian hyphenation | `hyphen-english`, `hyphen-russian` |
| Font selection | `fontspec` |
| DejaVu Sans Condensed fonts | `dejavu` |
| Page layout and document helpers | `geometry`, `etoolbox`, `hyperref` |

A full TeX Live installation supplies these components and their dependencies
and takes several gigabytes to download and install. The Gentoo instructions
select the required collections through Portage options. An existing installation
can be checked using the commands in
[Checking the installation](#checking-the-installation).

Install `just` separately using the platform instructions below. Official binary
downloads are also available for platforms with older package repositories.
[just installation](https://just.systems/man/en/installation.html).

## Installing the tools

### Windows

1. Download `install-tl-windows.exe` from the TeX Live network installation page.
2. Run the installer and select the full installation scheme, `scheme-full`.
3. Keep the option to add TeX Live to the executable search path enabled and
   complete installation.
4. Install `just` from PowerShell with Windows Package Manager.

```powershell
winget install --id Casey.Just --exact
```

Open a new PowerShell window after installation and continue with the checks below.
The project uses PowerShell for its Windows recipes.
[just packages](https://just.systems/man/en/packages.html).

The installer and platform instructions are maintained by the TeX Users Group.
[TeX Live network installer](https://tug.org/texlive/acquire-netinstall.html),
[TeX Live on Windows](https://tug.org/texlive/windows.html).

### Linux

The following commands cover Debian/Ubuntu, Fedora, Gentoo, and SUSE/openSUSE.
Run the commands for your distribution in a terminal.

#### Debian 13+ and Ubuntu 24.04+

```sh
sudo apt update
sudo apt install texlive-full just
```

`texlive-full` installs the TeX Live collections available in the distribution.
The release supplied depends on the operating system version.
[Debian package](https://packages.debian.org/trixie/texlive-full),
[Ubuntu package](https://packages.ubuntu.com/noble/texlive-full).

#### Fedora

```sh
sudo dnf install texlive-scheme-full just
```

This package installs Fedora's full TeX Live scheme.
[Fedora package](https://packages.fedoraproject.org/pkgs/texlive/texlive-scheme-full/).

The `just` package is available through `apt` and `dnf` on the distributions listed
above. [just packages](https://just.systems/man/en/packages.html).

#### Gentoo

Add the following entry to your `/etc/portage/package.use` configuration. When
that path is a directory, put the entry in a file such as
`/etc/portage/package.use/texlive`.

```text
app-text/texlive extra graphics luatex l10n_en l10n_ru
```

These flags select additional fonts and LaTeX packages, graphics packages,
LuaTeX, and English/Russian language collections.
[Gentoo TeX Live package](https://packages.gentoo.org/packages/app-text/texlive).

Run the installation command as root.

```sh
emerge --ask app-text/texlive dev-tex/latexmk dev-build/just
```

Portage installs the selected TeX Live collections and the two build tools.
[Gentoo latexmk package](https://packages.gentoo.org/packages/dev-tex/latexmk),
[Gentoo just package](https://packages.gentoo.org/packages/dev-build/just).

#### SUSE / openSUSE

On SUSE Linux Enterprise, enable the Package Hub extension for your registered
release. List the available extensions and use the activation command shown for
Package Hub, matching your service pack and architecture.
[SUSE Package Hub setup](https://packagehub.suse.com/how-to-use/).

```sh
sudo SUSEConnect --list-extensions
```

On openSUSE, use the repositories configured for your release. On either system,
refresh repository metadata and check that the required packages are available.

```sh
sudo zypper refresh
zypper search -s texlive-scheme-full
zypper search -s texlive-latexmk-bin
zypper search -s just
```

Install the full TeX Live scheme, the `latexmk` executable package, and `just`.

```sh
sudo zypper install texlive-scheme-full texlive-latexmk-bin just
```

Package availability depends on the release and enabled repositories. SUSE's
catalog lists the TeX Live scheme and executable packages, and `just`.
[TeX Live schemes](https://packagehub.suse.com/packages/texlive-filesystem/),
[TeX Live executables](https://packagehub.suse.com/packages/texlive/),
[just package](https://packagehub.suse.com/packages/just/).

If a package is unavailable for your release, use the upstream TeX Live installer
and official `just` binary downloads linked in this guide, then run the
installation checks below.

For other Linux distributions, or to install the current upstream TeX Live
release, follow the TeX Users Group's installer guide. After installation, add the
binary directory printed by the installer to your shell's `PATH`.
[TeX Live installation guide](https://tug.org/texlive/quickinstall.html).

For an upstream TeX Live installation that omits `latexmk`, add it with
`tlmgr install latexmk`, using the permissions of that installation.

### macOS

1. Download `MacTeX.pkg` from the MacTeX download page.
2. Run the package installer and include the full TeX Live component.
3. Install `just` using Homebrew or the official binary download linked above.
4. Open a new Terminal window and continue with the installation checks below.

MacTeX provides the TeX Live distribution and configures its command-line tools.
[MacTeX download](https://tug.org/mactex/mactex-download.html).

If you already use Homebrew, you can install both tools with the following commands.
Open a new Terminal window after installation.
[Homebrew MacTeX package](https://formulae.brew.sh/cask/mactex),
[just packages](https://just.systems/man/en/packages.html).

```sh
brew install --cask mactex
brew install just
```

## Checking the installation

In PowerShell on Windows, check which executable will run.

```powershell
Get-Command just
Get-Command latexmk
Get-Command lualatex
```

In Bash or Zsh on Linux/macOS, use the following command.

```sh
command -v just latexmk lualatex
```

The remaining checks work in PowerShell, Bash, and Zsh. Each `kpsewhich` command
should print the path to the requested file.

```sh
just --version
latexmk -v
lualatex --version
kpsewhich fontspec.sty
kpsewhich babel.sty
kpsewhich babel-english.tex
kpsewhich babel-russian.tex
kpsewhich tikz.sty
kpsewhich DejaVuSansCondensed.ttf
kpsewhich DejaVuSansCondensed-Bold.ttf
kpsewhich geometry.sty
kpsewhich etoolbox.sty
kpsewhich hyperref.sty
```

## Building documents

Download or clone the repository and open PowerShell on Windows, or a terminal
with Bash/Zsh on Linux/macOS, in the repository root. Use the same `just` commands
on each platform.

```sh
just build
just build ru
just build-all
```

| Command | Action |
| --- | --- |
| `just build` or `just build en` | Build every registered document in English |
| `just build ru` | Build every registered document in Russian |
| `just build-all` | Build every registered document in both languages |
| `just build en false` | Build English documents without finger numbers |
| `just build ru false` | Build Russian documents without finger numbers |
| `just build-all false` | Build both languages without finger numbers |
| `just clean` | Remove auxiliary files for registered documents |
| `just --list` | List available commands |

English is the default language. `latexmk` performs repeat passes automatically
and checks whether a document needs rebuilding. Repeating `just build` after a
successful build reuses up-to-date results.

PDFs are written next to each document's TeX source. For the guitar chord chart,
the resulting files appear in `guitar/chords`.

| File | Contents |
| --- | --- |
| `6-string-standard-tuning.en.pdf` | English chart |
| `6-string-standard-tuning.ru.pdf` | Russian chart |
| `6-string-standard-tuning.en-dots.pdf` | English chart without finger numbers |
| `6-string-standard-tuning.ru-dots.pdf` | Russian chart without finger numbers |

Finger numbers are shown by default. The optional second argument of `just build`
is `true` or `false`; `just build-all` accepts the same argument after its name.
For example:

```sh
just build ru false
just build-all false
```

The `false` variants use the `-dots` suffix and keep the numbered PDFs separate.
Only finger numbers inside dots, including dots on barres, are hidden. Dots,
barres, fret numbers, and open/muted string markings stay in place. The legend
describes plain dots instead of finger numbers.

For a direct LuaLaTeX build, define `\ShowFingerNumbers` as `false` before loading
the source. Its default is `true`. Invalid language or finger-number values stop
the build with an error.

Each PDF contains two landscape A4 pages and 96 chord diagrams in total. Open the
PDF in a viewer and check the language, symbols, finger numbers, and page layout.
For a print check, select A4 landscape and 100% / actual size.

LaTeX and `latexmk` also create `.aux`, `.log`, `.out`, `.fls`, and `.fdb_latexmk`
files with the same job name. The `.log` file records errors and warnings. These
auxiliary files are covered by `.gitignore` and removed by the cleanup command.

```sh
just clean
```

The chart uses fixed 6.8-point finger numbers with thicker strokes for print
readability. Font size and weight are part of the document's layout and do not
require build parameters.

### Adding a document

Add the path to each document's main TeX source to `@default_files` in
[`latexmkrc`](latexmkrc), relative to the repository root. `just build`,
`just build-all`, and `just clean` use this list. Shared LuaLaTeX settings are also
stored in that file. Bilingual documents can use `\ChartLanguage` with `en` and
`ru`, following the guitar chart's source.
Documents with fingerings can use `\ShowFingerNumbers` (`true` or `false`) to
support both numbered and plain-dot variants.

## Troubleshooting

| Symptom | Action |
| --- | --- |
| `just` or `latexmk` is unavailable | Install the tool using the platform instructions above, open a new shell, and check its executable path. |
| `lualatex` is unavailable | Open a new shell and check the executable path. On Windows, check the TeX Live installer search-path option. On Linux, use the binary directory reported by the upstream installer if you installed TeX Live that way. |
| A `.sty` file or Babel locale is missing | Use `kpsewhich` to check the file. Install its package through TeX Live Manager / MacTeX's TeX Live Utility, or through the Linux distribution's package manager (`apt`, `dnf`, `emerge`, or `zypper`). |
| DejaVu Sans Condensed cannot be found | Check both `.ttf` files with `kpsewhich` and install the `dejavu` TeX Live package. The source loads these font files from the TeX installation. |
| The TeX source file cannot be found | Check the path in `@default_files` in `latexmkrc`. Run `just` from the repository root or a directory inside it. |
| Compilation stops with a LaTeX error | Read the first error in the matching `.log` file. Check `lualatex --version` and the packages listed above. |

On macOS, MacTeX exposes its active executables through `/Library/TeX/texbin`. If
the command is unavailable in a new Terminal window, check that directory and your
`PATH` configuration. [MacTeX installation details](https://tug.org/mactex/What_Is_Installed.pdf).

Package updates for a Linux distribution installation are managed through that
distribution's package manager. Upstream TeX Live installations use `tlmgr`.
[Debian TeX Live Manager documentation](https://manpages.debian.org/unstable/texlive-base/tlmgr.1.en.html).

## Verified environment

The English and Russian builds with and without finger numbers, incremental
builds, and cleanup have been checked on macOS 26.7.1 (Apple Silicon) with
LuaHBTeX 1.21.0 from TeX Live
2025, `latexmk` 4.86a, and `just` 1.21.0 and 1.59.0. Both language versions contain
two pages. Windows and Linux installation instructions were checked against the
supplier documentation. Execution on those platforms remains to be verified.
