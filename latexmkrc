# Copyright (c) 2026 Sergey Zhunkov.
# SPDX-License-Identifier: CC-BY-4.0

# Add each document's main TeX source here, relative to the repository root.
@default_files = (
    'guitar/chords/6-string-standard-tuning.tex',
);

# Compile in each document's directory using LuaLaTeX.
$do_cd = 1;
$pdf_mode = 4;
$lualatex_default_switches = '-interaction=nonstopmode -halt-on-error';
