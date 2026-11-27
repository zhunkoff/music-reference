# Copyright (c) 2026 Sergey Zhunkov.
# SPDX-License-Identifier: CC-BY-4.0

# This form also supports older just releases packaged by Linux distributions.
set windows-shell := ["powershell.exe", "-NoLogo", "-NoProfile", "-Command"]

# Build all documents with the configured options or positional overrides.
build $language="" $fingers="":
    latexmk -r scripts/pdf-build.pl -e 'build_pdfs(q(documents), language => $ENV{language}, show_finger_numbers => $ENV{fingers});'

# Build the fretboard with note names or with octave numbers.
build-fretboard $language="" $labels="":
    latexmk -r scripts/pdf-build.pl -e 'build_pdfs(q(fretboard), language => $ENV{language}, fretboard_labels => $ENV{labels});'

# Build the interval reference.
build-intervals $language="":
    latexmk -r scripts/pdf-build.pl -e 'build_pdfs(q(intervals), language => $ENV{language});'

# Build the chord construction reference.
build-chord-construction $language="":
    latexmk -r scripts/pdf-build.pl -e 'build_pdfs(q(chord-construction), language => $ENV{language});'

# Build the circle of fifths reference.
build-circle-of-fifths $language="":
    latexmk -r scripts/pdf-build.pl -e 'build_pdfs(q(circle-of-fifths), language => $ENV{language});'

# Build the reference for chords in major and minor keys.
build-chords-in-keys $language="":
    latexmk -r scripts/pdf-build.pl -e 'build_pdfs(q(chords-in-keys), language => $ENV{language});'

# Build the scale and pentatonic construction reference.
build-scale-construction $language="":
    latexmk -r scripts/pdf-build.pl -e 'build_pdfs(q(scale-construction), language => $ENV{language});'

# Build the major and natural-minor guitar scale maps.
build-guitar-scales $language="":
    latexmk -r scripts/pdf-build.pl -e 'build_pdfs(q(guitar-scale-maps), language => $ENV{language});'

# Build the guitar triad inversion charts.
build-triads $language="":
    latexmk -r scripts/pdf-build.pl -e 'build_pdfs(q(triad-inversions), language => $ENV{language});'

# Build every registered document in both languages and all four fretboard PDFs.
build-all $fingers="":
    latexmk -r scripts/pdf-build.pl -e 'build_pdfs(q(all), show_finger_numbers => $ENV{fingers});'

# Build a single PDF with all documents in one language.
build-book $language="":
    latexmk -r scripts/pdf-build.pl -e 'build_pdfs(q(book), language => $ENV{language});'

# Remove auxiliary files for registered documents.
clean:
    latexmk -c
    latexmk -c '-jobname=%A.en'
    latexmk -c '-jobname=%A.ru'
    latexmk -c '-jobname=%A.en-dots'
    latexmk -c '-jobname=%A.ru-dots'
    latexmk -c -e '@default_files = ($fretboard_source);' '-jobname=%A.en-octaves'
    latexmk -c -e '@default_files = ($fretboard_source);' '-jobname=%A.ru-octaves'
