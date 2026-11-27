English | [Русский](BUILD.ru.md)

# Building PDFs

This guide covers tool installation on Windows, Linux, and macOS, and building the
documents from their TeX sources. Return to the [project overview](README.md).

## Requirements

Project commands are defined in `justfile` and use `latexmk` to run LuaLaTeX as many
times as needed. The guitar chord chart uses TikZ, Babel with English and Russian
language data, and DejaVu Sans Condensed in regular and bold weights.
Use `latexmk` 4.84 or newer for the project's cleanup hook.
[latexmk documentation](https://www.cantab.net/users/johncollins/latexmk/index.html).

| Component | TeX Live package |
| --- | --- |
| Build automation | `latexmk` |
| LuaLaTeX engine and Lua font loading | `luatex`, `luaotfload` |
| Embedded Lua calculations in the note-frequency chart | `luacode` |
| TikZ diagrams | `pgf` |
| Language support | `babel`, `babel-english`, `babel-russian` |
| English and Russian hyphenation | `hyphen-english`, `hyphen-russian` |
| Font selection | `fontspec` |
| DejaVu Sans Condensed fonts | `dejavu` |
| Page layout and document helpers | `geometry`, `etoolbox`, `hyperref` |
| Combined PDF | `pdfpages`, `newpax`, `bookmark`, `xcolor` |

A full TeX Live installation supplies these components and their dependencies
and takes several gigabytes to download and install. The Gentoo instructions
select the required collections through Portage options. An existing installation
can be checked using the commands in
[Checking the installation](#checking-the-installation).

Install `just` separately using the platform instructions below. Official binary
downloads are also available for platforms with older package repositories.
[just installation](https://just.systems/man/en/installation.html).

The optional local `build.yaml` requires YAML::PP 0.027 or newer for the Perl
that runs latexmk. The default build in a fresh checkout and direct LuaLaTeX
compilation work without this module. [YAML::PP documentation](https://metacpan.org/pod/YAML::PP).

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

### YAML::PP

Follow these steps if you plan to use a local `build.yaml`.

On Linux and macOS, install YAML::PP through your package manager or run
`cpan YAML::PP` with the Perl used by latexmk. If CPAN offers a choice of
installation directories, choose `local::lib` for a user installation and
apply the shell setup that it prints. For example, add the following to your
shell startup file if you installed modules under `~/perl5`.

```sh
export PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:$PERL5LIB}"
```

On Windows, install a full Perl distribution such as Strawberry Perl, put its
`perl.exe` on `PATH`, and run `cpan YAML::PP` from a new PowerShell window.
Set `TEXLIVE_WINDOWS_TRY_EXTERNAL_PERL = 1` in the `texmf.cnf` at the root of
the TeX Live installation so its launcher uses that Perl for latexmk. Use the
check below to confirm that latexmk sees the module. Build execution on Windows
has yet to be verified. [TeX Live guide](https://tug.org/texlive/doc/texlive-en/texlive-en.html).

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
kpsewhich luacode.sty
kpsewhich babel.sty
kpsewhich babel-english.tex
kpsewhich babel-russian.tex
kpsewhich tikz.sty
kpsewhich DejaVuSansCondensed.ttf
kpsewhich DejaVuSansCondensed-Bold.ttf
kpsewhich geometry.sty
kpsewhich etoolbox.sty
kpsewhich hyperref.sty
kpsewhich pdfpages.sty
kpsewhich newpax.sty
kpsewhich bookmark.sty
kpsewhich xcolor.sty
```

If you use a local `build.yaml`, check that latexmk can load YAML::PP.

```sh
latexmk -e 'require YAML::PP; YAML::PP->VERSION(0.027);' -v
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
| `just build` | Build every registered document with the configured options |
| `just build en` | Build every registered document in English |
| `just build ru` | Build every registered document in Russian |
| `just build-book` | Build the combined PDF in the configured default language |
| `just build-book en` | Build the English combined PDF |
| `just build-book ru` | Build the Russian combined PDF |
| `just build-all` | Build every registered document in both languages, including all four fretboard PDFs |
| `just build en false` | Build English documents without finger numbers |
| `just build ru false` | Build Russian documents without finger numbers |
| `just build-all false` | Build both languages without finger numbers, including all four fretboard PDFs |
| `just build-fretboard en octaves` | Build only the English fretboard map with octave numbers |
| `just build-intervals en` | Build only the English interval reference |
| `just build-chord-construction en` | Build only the English chord construction reference |
| `just build-circle-of-fifths en` | Build only the English circle of fifths reference |
| `just build-chords-in-keys en` | Build only the English reference for chords in major and minor keys |
| `just build-triads en` | Build only the English guitar triad inversion charts |
| `just clean` | Remove auxiliary files for registered documents |
| `just --list` | List available commands |

### Build configuration

To customize the build, copy [build.example.yaml](build.example.yaml) to
`build.yaml` in the repository root and edit the copy. Git ignores the local file.
The example lists every registered source and the options it supports.
Both `defaults` and `documents` are optional mappings. In `documents`, use the
exact paths from the registry in [latexmkrc](latexmkrc), relative to the
repository root and with forward slashes.

| Key | Values | Sources |
| --- | --- | --- |
| `language` | `en` or `ru` | All registered documents |
| `accent_color` | Quoted `"#RRGGBB"` with six hexadecimal digits | All registered documents, under `defaults` only |
| `show_finger_numbers` | YAML boolean `true` or `false` | Guitar chord chart |
| `fretboard_labels` | `notes` or `octaves` | Guitar fretboard map |

The built-in defaults match the TeX sources (`en`, `"#195755"`, `true`, and `notes`).
Values in `defaults` override those settings for sources that support them.
An entry in `documents` takes precedence for that source. Explicit positional
arguments take precedence for the current invocation. Omitted arguments use
the configuration. A missing configuration file falls back to the built-in
defaults. The build checks the entire file before starting LaTeX and reports
invalid syntax, duplicate or unknown keys, unknown paths, invalid values, and
options unsupported by the specified source.

```yaml
defaults:
  language: en
  accent_color: "#195755"
  show_finger_numbers: false
  fretboard_labels: notes
documents:
  guitar/chords/6-string-standard-tuning.tex:
    show_finger_numbers: true
  guitar/fretboard/6-string-fretboard.tex:
    language: ru
    fretboard_labels: octaves
```

With these settings, `just build` produces numbered chords in English and
the Russian fretboard map with octave numbers. `just build en false` selects
English for all documents and plain dots for the chord chart. The fretboard
map still uses octave numbers. `just build-fretboard en notes` explicitly
selects English and note names for that map.

`just build-all` always builds both languages and both fretboard label modes.
It uses the configured finger-number setting unless an argument overrides it.

`defaults.accent_color` sets the accent for standalone PDFs and all sections
of the combined PDF in both languages and all chart variants. Keep the quotes
so YAML reads the leading `#` as part of the string. Rerun the build after changing
the color to update the PDFs at the same paths. Direct LuaLaTeX builds use the TeX
default of `#195755`.

### Combined PDF

```sh
just build-book
just build-book en
just build-book ru
```

The book uses its explicit language argument, then `defaults.language`, then
`en`. This language applies to every section, the bookmarks, and the metadata.
Per-document language settings apply to standalone PDFs. The book still uses
the effective finger-number and fretboard options for its sections.
The output is `build/music-reference.en.pdf` or `build/music-reference.ru.pdf`.
Changing a section variant or the accent color rebuilds the book at the same path.

The build compiles the selected individual variants and includes each once in
the order defined in [latexmkrc](latexmkrc), with a bookmark for each section.
LuaLaTeX runs [the book wrapper](book/music-reference.tex).
`pdfpages` inserts the pages at their original sizes, and `newpax` restores
clickable links. Links between book sections open the corresponding pages.
The separate PDFs link to the matching sections of the language's README.
The `build/` directory contains the books and their intermediate files.

To prepare a release, set the download links in both READMEs to the release tag.
Build both language versions from a fresh checkout of the release commit.
Check the bookmarks and links, then manually attach both PDFs to the GitHub
Release for that tag. Keep generated PDFs out of Git tracking.

### Individual PDFs

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

The note-frequency chart is written to `theory/pitch`.

| File | Contents |
| --- | --- |
| `note-frequencies.en.pdf` | English note-frequency chart |
| `note-frequencies.ru.pdf` | Russian note-frequency chart |

Each language version is one landscape A4 page covering C0-B10, with the
conventional 20 Hz-20 kHz hearing interval highlighted. Select A4 landscape and
100% / actual size when checking print legibility and the black-and-white legend.
Check the shared endpoint markers and the legend's instrument configurations,
tunings, and conditional double-bass upper bound as well.

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

The note-frequency chart always uses its standard language-specific filename.

For a direct LuaLaTeX build of the guitar chart, define `\ShowFingerNumbers` as
`false` before loading the source. Its default is `true`. Invalid language or
finger-number values stop the build with an error.

Each guitar chord PDF contains two landscape A4 pages and 96 chord diagrams in total.
Open the PDF in a viewer and check the language, symbols, finger numbers, and
page layout.
For a print check, select A4 landscape and 100% / actual size.

### Guitar fretboard map

The four PDFs in `guitar/fretboard` each use one landscape A4 page and share
the same grid.

| File | Contents |
| --- | --- |
| `6-string-fretboard.en.pdf` | English, note names |
| `6-string-fretboard.en-octaves.pdf` | English, note names with sounding octave numbers |
| `6-string-fretboard.ru.pdf` | Russian, note names |
| `6-string-fretboard.ru-octaves.pdf` | Russian, note names with sounding octave numbers |

`just build-all` builds all four PDFs. `just build` and `just build ru` use the
configured labels. To build just the map, pass the language and label mode to
`just build-fretboard` or omit them to use the configuration.

```sh
just build-fretboard en notes
just build-fretboard en octaves
just build-fretboard ru notes
just build-fretboard ru octaves
```

Direct LuaLaTeX builds default to `en` and `notes`. Set `\ChartLanguage` and
`\FretboardLabels` before loading the source. Use `notes` or `octaves` for
the labels. In a print check, use A4 landscape and 100% / actual size in both
color and grayscale. Check all fret labels and accidentals, the nut line
after column 0, and the outline around fret 12.

### Musical intervals

The interval reference in `theory/intervals` uses two landscape A4 pages per
language.

| File | Contents |
| --- | --- |
| `intervals.en.pdf` | English interval reference |
| `intervals.ru.pdf` | Russian interval reference |

`just build-all` builds both PDFs. `just build` and `just build ru` build the
selected language. To build only the reference, use:

```sh
just build-intervals en
just build-intervals ru
```

The default is `en`. For direct LuaLaTeX builds, set `\ChartLanguage` to `en`
or `ru` before loading the source. Each language has one PDF regardless of the
chord chart's finger-number setting.

For print verification, select A4 landscape and 100% / actual size. Check both
pages in color and grayscale for legible accidentals and fret labels, and for
clear starting and target markers.

### Chord construction

The chord construction reference in `theory/harmony` uses one landscape A4 page
per language.

| File | Contents |
| --- | --- |
| `chord-construction.en.pdf` | English chord construction reference |
| `chord-construction.ru.pdf` | Russian chord construction reference |

`just build-all` builds both PDFs. `just build` and `just build ru` build the
selected language. The standalone recipe accepts the same language options.

```sh
just build-chord-construction en
just build-chord-construction ru
```

The default is `en`. For direct LuaLaTeX builds, set `\ChartLanguage` to `en`
or `ru` before loading the shared source. Each language has one PDF regardless
of the guitar chord chart's finger-number setting.

For print verification, select A4 landscape and 100% / actual size. Check each
language in color and grayscale, especially the chord symbols, flats, sharps,
and the double flat in `Cdim7`.

### Circle of fifths

The reference in `theory/keys` uses one landscape A4 page per language.
`just build-all` generates both PDFs. To build just this reference, use

```sh
just build-circle-of-fifths en
just build-circle-of-fifths ru
```

The files are `circle-of-fifths.en.pdf` and `circle-of-fifths.ru.pdf`. For print
verification, select A4 landscape and 100% / actual size. In both color and
grayscale, check the labels and signatures in the three shared sectors and
the accidental lists in the table.

### Chords in major and minor keys

The [shared TeX source](theory/harmony/chords-in-keys.tex) produces two landscape
A4 pages per language, one for major and one for natural minor. `just build-all`
generates both PDFs. To build just this reference, use

```sh
just build-chords-in-keys en
just build-chords-in-keys ru
```

The files are `chords-in-keys.en.pdf` and `chords-in-keys.ru.pdf`. For print
verification, select A4 landscape and 100% / actual size. In color and grayscale,
check the Roman numerals, accidentals in the six- and seven-sign rows, chord
symbols, and the layout of the worked examples in both languages.

### Guitar triad inversions

Each PDF in `guitar/triads` has two landscape A4 pages, one for C and one for Cm.
The charts use compact closed shapes at the lowest available frets and label
chord degrees beside each dot.

| File | Contents |
| --- | --- |
| `triad-inversions.en.pdf` | English guitar triad inversion charts |
| `triad-inversions.ru.pdf` | Russian guitar triad inversion charts |

`just build-all` builds both PDFs. To build just these charts, run the recipe
with the desired language.

```sh
just build-triads en
just build-triads ru
```

The default is `en`. For direct LuaLaTeX builds, set `\ChartLanguage` to `en`
or `ru` before loading the shared source. Each language has one PDF regardless
of the guitar chord chart's finger-number setting.

For print verification, select A4 landscape and 100% / actual size. Check both
pages in each language in color and grayscale, especially the degree labels,
fret numbers, string numbers, and muted-string marks.

### Cleaning build files

LaTeX and `latexmk` also create `.aux`, `.log`, `.out`, `.fls`, and `.fdb_latexmk`
files with the same job name. The `.log` file records errors and warnings. These
auxiliary files are covered by `.gitignore` and removed by the cleanup command.
Cleanup also removes temporary recorder files named `lualatex<digits>.fls`
left by failed engine startup, only in registered documents' directories.
PDFs and TeX sources are preserved.

```sh
just clean
```

The guitar chart uses fixed 6.8-point finger numbers with thicker strokes for print
readability. Font size and weight are part of the document's layout and do not
require build parameters.

### Adding a document

Register each document's repository-relative TeX path in `@documents` in
[`latexmkrc`](latexmkrc) with its reference anchor, English and Russian bookmark
titles, and any supported variant keys. All registered documents support
`language` through `\ChartLanguage` and define `ChartAccent` from the HTML
color macro `\ChartAccentHex`, with a fallback of `195755` for direct builds.
Documents with fingerings can declare `show_finger_numbers` and use
`\ShowFingerNumbers` (`true` or `false`).
The registry also supplies `@default_files` for latexmk and cleanup.

## Troubleshooting

| Symptom | Action |
| --- | --- |
| `just` or `latexmk` is unavailable | Install the tool using the platform instructions above, open a new shell, and check its executable path. |
| `lualatex` is unavailable | Open a new shell and check the executable path. On Windows, check the TeX Live installer search-path option. On Linux, use the binary directory reported by the upstream installer if you installed TeX Live that way. |
| A `.sty` file or Babel locale is missing | Use `kpsewhich` to check the file. Install its package through TeX Live Manager / MacTeX's TeX Live Utility, or through the Linux distribution's package manager (`apt`, `dnf`, `emerge`, or `zypper`). |
| DejaVu Sans Condensed cannot be found | Check both `.ttf` files with `kpsewhich` and install the `dejavu` TeX Live package. The source loads these font files from the TeX installation. |
| The TeX source file cannot be found | Check the path in `@documents` in `latexmkrc`. Run `just` from the repository root or a directory inside it. |
| Compilation stops with a LaTeX error | Read the first error in the matching `.log` file. Check `lualatex --version` and the packages listed above. |

On macOS, MacTeX exposes its active executables through `/Library/TeX/texbin`. If
the command is unavailable in a new Terminal window, check that directory and your
`PATH` configuration. [MacTeX installation details](https://tug.org/mactex/What_Is_Installed.pdf).

Package updates for a Linux distribution installation are managed through that
distribution's package manager. Upstream TeX Live installations use `tlmgr`.
[Debian TeX Live Manager documentation](https://manpages.debian.org/unstable/texlive-base/tlmgr.1.en.html).

## Verified environment

YAML configuration, the English and Russian variants, both combined PDFs,
direct LuaLaTeX compilation, incremental builds, and cleanup were checked on
macOS with LuaHBTeX 1.21.0 from TeX Live 2025, `latexmk` 4.86a, `just` 1.59.0,
and YAML::PP 0.43.0. Windows and Linux installation instructions were checked
against the supplier documentation. Build execution on those platforms
remains to be verified.
