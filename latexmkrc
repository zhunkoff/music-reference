# Copyright (c) 2026 Sergey Zhunkov.
# SPDX-License-Identifier: CC-BY-4.0

# Keep the sources in book order, with a reference anchor and both bookmark titles.
$fretboard_source = 'guitar/fretboard/6-string-fretboard.tex';
$intervals_source = 'theory/intervals/intervals.tex';
$chord_construction_source = 'theory/harmony/chord-construction.tex';
$triads_source = 'guitar/triads/triad-inversions.tex';
@documents = (
    ['guitar/chords/6-string-standard-tuning.tex', 'guitar-chords',
        'Guitar chords', 'Гитарные аккорды'],
    ['theory/pitch/note-frequencies.tex', 'note-frequencies',
        'Note frequencies', 'Частоты нот'],
    [$fretboard_source, 'fretboard',
        'Guitar fretboard map', 'Карта нот на грифе гитары'],
    [$intervals_source, 'intervals',
        'Musical intervals', 'Музыкальные интервалы'],
    [$chord_construction_source, 'chord-construction',
        'Chord construction', 'Построение аккордов'],
    [$triads_source, 'triad-inversions',
        'Guitar triad inversions', 'Обращения трезвучий на гитаре'],
);
@default_files = map { $_->[0] } @documents;

sub write_book_source {
    my ($language) = @_;
    die "Language must be en or ru\n" unless $language =~ /\A(?:en|ru)\z/;
    my $book_source = "build/music-reference.$language.tex";
    my $title_index = $language eq 'en' ? 2 : 3;
    my $sections = join '', map {
        my ($source, $anchor) = @$_;
        $source =~ s/\.tex\z//;
        "\\BookDocument{$source}{$anchor}{$_->[$title_index]}%\n";
    } @documents;

    my $contents = "\\def\\ChartLanguage{$language}\n"
        . "\\def\\BookDocuments{%\n$sections}\n"
        . "\\input{../book/music-reference.tex}\n";

    if (open my $existing, '<:raw', $book_source) {
        local $/;
        my $previous = <$existing>;
        return if defined $previous && $previous eq $contents;
    }

    mkdir 'build' unless -d 'build';
    open my $output, '>:raw', $book_source or die "Cannot write $book_source: $!\n";
    print {$output} $contents or die "Cannot write $book_source: $!\n";
    close $output or die "Cannot close $book_source: $!\n";
}

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
