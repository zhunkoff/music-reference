# Copyright (c) 2026 Sergey Zhunkov.
# SPDX-License-Identifier: CC-BY-4.0

# Keep the sources in book order, with an anchor, both bookmark titles, and
# any supported build options other than language (which all sources support).
$fretboard_source = 'guitar/fretboard/6-string-fretboard.tex';
@documents = (
    ['guitar/chords/6-string-standard-tuning.tex', 'guitar-chords',
        'Guitar chords', 'Гитарные аккорды', 'show_finger_numbers'],
    ['theory/pitch/note-frequencies.tex', 'note-frequencies',
        'Note frequencies', 'Частоты нот'],
    [$fretboard_source, 'fretboard',
        'Guitar fretboard map', 'Карта нот на грифе гитары', 'fretboard_labels'],
    ['theory/intervals/intervals.tex', 'intervals',
        'Musical intervals', 'Музыкальные интервалы'],
    ['theory/harmony/chord-construction.tex', 'chord-construction',
        'Chord construction', 'Построение аккордов'],
    ['guitar/triads/triad-inversions.tex', 'triad-inversions',
        'Guitar triad inversions', 'Обращения трезвучий на гитаре'],
);
@default_files = map { $_->[0] } @documents;

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
