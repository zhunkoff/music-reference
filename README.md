English | [Русский](README.ru.md)

# music-reference

Music reference charts and documents for learning, practice, and use in your own
projects.

## Materials

The first document is a chord fingering chart for a six-string guitar
in standard tuning E A D G B E, from the sixth string to the first.

- [English PDF](guitar/chords/6-string-standard-tuning.en.pdf), [without finger numbers](guitar/chords/6-string-standard-tuning.en-dots.pdf)
- [Russian PDF](guitar/chords/6-string-standard-tuning.ru.pdf), [without finger numbers](guitar/chords/6-string-standard-tuning.ru-dots.pdf)
- [TeX source with Russian and English support](guitar/chords/6-string-standard-tuning.tex)

Materials are grouped by instrument and topic, with each document's PDF and TeX
source stored together.

## Building the chart

With TeX Live and `just` installed, run this command from the repository root to
build all registered documents in English.

```sh
just build
```

The chart is saved as `guitar/chords/6-string-standard-tuning.en.pdf`.
Use `just build ru` for Russian or `just build-all` for both languages.
Finger numbers are shown by default. Use `just build en false` to build English
with plain dots, or `just build-all false` for both languages without numbers.
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
