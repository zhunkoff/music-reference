# Copyright (c) 2026 Sergey Zhunkov.
# SPDX-License-Identifier: CC-BY-4.0

# Add each document's main TeX source here, relative to the repository root.
$fretboard_source = 'guitar/fretboard/6-string-fretboard.tex';
$intervals_source = 'theory/intervals/intervals.tex';
$chord_construction_source = 'theory/harmony/chord-construction.tex';
@default_files = (
    'guitar/chords/6-string-standard-tuning.tex',
    'theory/pitch/note-frequencies.tex',
    $fretboard_source,
    $intervals_source,
    $chord_construction_source,
);

# Compile in each document's directory using LuaLaTeX.
$do_cd = 1;
$pdf_mode = 4;
$lualatex_default_switches = '-interaction=nonstopmode -halt-on-error';

# A failed early startup can leave a recorder file named after the engine PID.
# With $do_cd, the cleanup hook runs in each registered document's directory.
add_hook('cleanup', sub {
    for my $file (glob('lualatex[0-9]*.fls')) {
        next unless $file =~ /\Alualatex[0-9]+\.fls\z/ && -f $file;
        unlink $file or die "Cannot remove temporary recorder '$file': $!\n";
    }
    return 0;
});
