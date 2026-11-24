English | [Русский](README.ru.md)

# music-reference

Music reference charts and documents for learning, practice, and use in your own
projects.

## Materials

### Guitar chords

A chord fingering chart for a six-string guitar in standard tuning E A D G B E,
from the sixth string to the first.

- [English PDF](guitar/chords/6-string-standard-tuning.en.pdf), [without finger numbers](guitar/chords/6-string-standard-tuning.en-dots.pdf)
- [Russian PDF](guitar/chords/6-string-standard-tuning.ru.pdf), [without finger numbers](guitar/chords/6-string-standard-tuning.ru-dots.pdf)
- [TeX source with Russian and English support](guitar/chords/6-string-standard-tuning.tex)

### Guitar fretboard map

A one-page landscape A4 map of sounding notes on a six-string guitar in standard
tuning, from the open strings through fret 12. The two label variants share the
same layout.

- [English PDF with note names](guitar/fretboard/6-string-fretboard.en.pdf), [with octave numbers](guitar/fretboard/6-string-fretboard.en-octaves.pdf)
- [Russian PDF with note names](guitar/fretboard/6-string-fretboard.ru.pdf), [with octave numbers](guitar/fretboard/6-string-fretboard.ru-octaves.pdf)
- [Shared TeX source](guitar/fretboard/6-string-fretboard.tex)

### Musical intervals

A two-page landscape A4 reference with interval names, semitone distances, and
examples from C4. Guitar diagrams show sounding pitches on one string and on
all five adjacent string pairs in standard tuning.

- [English PDF](theory/intervals/intervals.en.pdf)
- [Russian PDF](theory/intervals/intervals.ru.pdf)
- [Shared TeX source](theory/intervals/intervals.tex)

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

- [English PDF](theory/pitch/note-frequencies.en.pdf)
- [Russian PDF](theory/pitch/note-frequencies.ru.pdf)
- [Shared TeX source](theory/pitch/note-frequencies.tex)

Materials are grouped by instrument or area of music theory and topic, with each
document's PDF and TeX source stored together.

## Building the documents

With TeX Live and `just` installed, run this command from the repository root to
build all registered documents in English.

```sh
just build
```

PDFs are saved beside their sources. Use `just build ru` for Russian or
`just build-all` for both languages and all four fretboard PDFs.
A single-language build produces the fretboard with note names only.
Use `just build-fretboard en octaves` to build only the English fretboard map
with octave numbers.
Guitar finger numbers are shown by default. Use `just build en false` for English
with plain dots, or `just build-all false` for both languages without numbers.
The interval reference has one PDF per language. The note-frequency chart has
the same content in both finger-number modes.
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
