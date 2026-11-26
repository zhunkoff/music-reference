# Copyright (c) 2026 Sergey Zhunkov.
# SPDX-License-Identifier: CC-BY-4.0

# This form also supports older just releases packaged by Linux distributions.
set windows-shell := ["powershell.exe", "-NoLogo", "-NoProfile", "-Command"]

# Build in English (default) or Russian; set fingers to false for plain dots.
build language="en" fingers="true": (_build-documents language fingers) (build-fretboard language "notes") (build-intervals language) (build-chord-construction language) (build-triads language)

_build-documents language fingers:
    latexmk \
        -e '@default_files = grep { $_ ne $fretboard_source && $_ ne $intervals_source && $_ ne $chord_construction_source && $_ ne $triads_source } @default_files;' \
        '-jobname=%A.{{ if language =~ "^(en|ru)$" { language } else { error("Language must be en or ru") } }}{{ if fingers == "true" { "" } else if fingers == "false" { "-dots" } else { error("Finger numbers must be true or false") } }}' \
        '-usepretex={{ '\def\ChartLanguage{' + language + '}\def\ShowFingerNumbers{' + fingers + '}' }}'

# Build the fretboard with note names (default) or with octave numbers.
build-fretboard language="en" labels="notes":
    latexmk \
        -e '@default_files = ($fretboard_source);' \
        '-jobname=%A.{{ if language =~ "^(en|ru)$" { language } else { error("Language must be en or ru") } }}{{ if labels == "notes" { "" } else if labels == "octaves" { "-octaves" } else { error("Fretboard labels must be notes or octaves") } }}' \
        '-usepretex={{ '\def\ChartLanguage{' + language + '}\def\FretboardLabels{' + labels + '}' }}'

# Build the interval reference in English (default) or Russian.
build-intervals language="en":
    latexmk \
        -e '@default_files = ($intervals_source);' \
        '-jobname=%A.{{ if language =~ "^(en|ru)$" { language } else { error("Language must be en or ru") } }}' \
        '-usepretex={{ '\def\ChartLanguage{' + language + '}' }}'

# Build the chord construction reference in English (default) or Russian.
build-chord-construction language="en":
    latexmk \
        -e '@default_files = ($chord_construction_source);' \
        '-jobname=%A.{{ if language =~ "^(en|ru)$" { language } else { error("Language must be en or ru") } }}' \
        '-usepretex={{ '\def\ChartLanguage{' + language + '}' }}'

# Build the guitar triad inversion charts in English (default) or Russian.
build-triads language="en":
    latexmk \
        -e '@default_files = ($triads_source);' \
        '-jobname=%A.{{ if language =~ "^(en|ru)$" { language } else { error("Language must be en or ru") } }}' \
        '-usepretex={{ '\def\ChartLanguage{' + language + '}' }}'

# Build every registered document in both languages and all four fretboard PDFs.
build-all fingers="true": (build "en" fingers) (build "ru" fingers) (build-fretboard "en" "octaves") (build-fretboard "ru" "octaves")

# Build a single PDF with all documents in English (default) or Russian.
build-book language="en": (build language "true")
    latexmk -e 'write_book_source(q({{ language }}));' build/music-reference.{{ language }}.tex

# Remove auxiliary files for registered documents.
clean:
    latexmk -c
    latexmk -c '-jobname=%A.en'
    latexmk -c '-jobname=%A.ru'
    latexmk -c '-jobname=%A.en-dots'
    latexmk -c '-jobname=%A.ru-dots'
    latexmk -c -e '@default_files = ($fretboard_source);' '-jobname=%A.en-octaves'
    latexmk -c -e '@default_files = ($fretboard_source);' '-jobname=%A.ru-octaves'
