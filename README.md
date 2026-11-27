English | [Русский](README.ru.md)

# music-reference

Music reference charts and documents for learning, practice, and use in your own
projects.

## Download the book

- [English PDF](https://github.com/zhunkoff/music-reference/releases/download/v1.1.0/music-reference.en.pdf)
- [Russian PDF](https://github.com/zhunkoff/music-reference/releases/download/v1.1.0/music-reference.ru.pdf)

A book built from this checkout includes all the materials below, with finger
numbers on the chord chart and note names on the fretboard map. Other variants
can be built separately from the TeX sources.

## Materials

<a name="ref-guitar-chords"></a>

### Guitar chords

A chord fingering chart for a six-string guitar in standard tuning E A D G B E,
from the sixth string to the first.

- [TeX source with Russian and English support](guitar/chords/6-string-standard-tuning.tex)

<a name="ref-fretboard"></a>

### Guitar fretboard map

A one-page landscape A4 map of sounding notes on a six-string guitar in standard
tuning, from the open strings through fret 12. The two label variants share the
same layout.

- [Shared TeX source](guitar/fretboard/6-string-fretboard.tex)

<a name="ref-triad-inversions"></a>

### Guitar triad inversions

Two landscape A4 pages with 24 movable C major and C minor shapes in standard
tuning. Each page shows root position and both inversions on four groups of
adjacent strings, with chord degrees, fret numbers, and a transposition guide.

- [Shared TeX source](guitar/triads/triad-inversions.tex)

<a name="ref-intervals"></a>

### Musical intervals

A two-page landscape A4 reference with interval names, semitone distances, and
examples from C4. Guitar diagrams show sounding pitches on one string and on
all five adjacent string pairs in standard tuning.

- [Shared TeX source](theory/intervals/intervals.tex)

<a name="ref-chord-construction"></a>

### Chord construction

A one-page landscape A4 reference for guitarists with chord symbols, degree
formulas, and examples from C for 14 chord types. The guide explains suspended
and added tones, seventh spellings, and how to turn a formula into a voicing.

- [Shared TeX source](theory/harmony/chord-construction.tex)

<a name="ref-circle-of-fifths"></a>

### Circle of fifths

A one-page landscape A4 reference for guitarists showing 15 major keys and their
relative minors, including separate enharmonic spellings. The table lists the
accidentals for each key signature, and the guide shows how to find relative
keys and the tonic, subdominant, and dominant.

- [Shared TeX source](theory/keys/circle-of-fifths.tex)

<a name="ref-note-frequencies"></a>

### Note frequencies

A one-page landscape A4 reference for C0-B10 in 12-tone equal temperament,
with A4 = 440 Hz. The table highlights the conventional 20 Hz-20 kHz hearing
interval and marks values outside it for color and black-and-white printing.
Grand-piano symbols mark A0 and C8, the endpoints of a standard 88-key keyboard.
Silhouette markers identify classical guitar (19 frets), electric guitar (24 frets),
four-string bass (24 frets), four-string double bass, and prima balalaika
(24 frets). The legend gives standard tunings and ranges; the double bass's G4
upper bound is a reference limit. A small `bass` subscript distinguishes the bass
guitar's silhouette from the electric guitar's.

- [Shared TeX source](theory/pitch/note-frequencies.tex)

TeX sources are grouped by instrument or area of music theory and topic.
PDFs are generated during the build.

## Building the documents

With TeX Live and `just` installed, run this command from the repository root to
build the English book.

```sh
just build-book
```

Use `just build-book ru` for the Russian book. Both files are written to `build/`.

Use `just build` for individual PDFs. To customize the build, copy
[build.example.yaml](build.example.yaml) to a local `build.yaml`.
Use `just build ru` to select Russian or `just build-all` for both languages and
all four fretboard PDFs. Individual PDFs are saved beside their sources.
Use `just build-fretboard en octaves` to build only the English fretboard map
with octave numbers.
The guitar chord chart shows finger numbers by default. Use `just build en false`
for English with plain dots, or `just build-all false` for both languages without
finger numbers.
The triad inversion, interval, chord construction, and circle of fifths
references each have one PDF per language.
The note-frequency chart has one PDF per language.
See the [build guide](BUILD.md) for Windows, Linux, and macOS installation
and detailed build instructions.

## Author and license

© 2026 Sergey Zhunkov.

The materials in this repository, including PDFs and TeX sources, are licensed
under Creative Commons Attribution 4.0 International (CC BY 4.0).
The full text is provided in [LICENSE](LICENSE), and a summary of the terms is
available on the [Creative Commons website](https://creativecommons.org/licenses/by/4.0/).

The license permits copying, sharing, and adapting the materials, including for
commercial projects. When publicly sharing original or modified materials, you
must retain attribution and license information, link to the source where
reasonably practicable, and indicate any changes made.

Please credit **Sergey Zhunkov** as the author. Use the
[music-reference repository](https://github.com/zhunkoff/music-reference) as the
source link.
