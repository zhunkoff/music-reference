# Copyright (c) 2026 Sergey Zhunkov.
# SPDX-License-Identifier: CC-BY-4.0

# This form also supports older just releases packaged by Linux distributions.
set windows-shell := ["powershell.exe", "-NoLogo", "-NoProfile", "-Command"]

# Build in English (default) or Russian; set fingers to false for plain dots.
build language="en" fingers="true":
    latexmk \
        '-jobname=%A.{{ if language =~ "^(en|ru)$" { language } else { error("Language must be en or ru") } }}{{ if fingers == "true" { "" } else if fingers == "false" { "-dots" } else { error("Finger numbers must be true or false") } }}' \
        '-usepretex={{ '\def\ChartLanguage{' + language + '}\def\ShowFingerNumbers{' + fingers + '}' }}'

# Build every registered document in both languages.
build-all fingers="true": (build "en" fingers) (build "ru" fingers)

# Remove auxiliary files for registered documents.
clean:
    latexmk -c
    latexmk -c '-jobname=%A.en'
    latexmk -c '-jobname=%A.ru'
    latexmk -c '-jobname=%A.en-dots'
    latexmk -c '-jobname=%A.ru-dots'
