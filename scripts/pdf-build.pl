# Copyright (c) 2026 Sergey Zhunkov.
# SPDX-License-Identifier: CC-BY-4.0

use strict;
use warnings;
use File::Basename ();
use File::Path ();
use File::Spec ();
use File::Temp ();
use JSON::PP ();

# Loaded after latexmkrc, which owns the document registry and engine settings.
our @documents;

# The defaults match those in the standalone TeX sources.
my %build_options = (
    language            => { macro => 'ChartLanguage', values => [qw(en ru)] },
    show_finger_numbers => { macro => 'ShowFingerNumbers', values => [qw(true false)] },
    fretboard_labels    => { macro => 'FretboardLabels', values => [qw(notes octaves)] },
    accent_color        => { default => '195755' },
);

sub supported_build_options {
    my ($document) = @_;
    return ('language', @{$document}[4 .. $#$document]);
}

sub validate_build_value {
    my ($name, $value, $location) = @_;
    if ($name eq 'accent_color') {
        die "$location: expected a quoted #RRGGBB color (for example \"#195755\")\n"
            unless defined $value && !ref($value) && $value =~ /\A#([0-9A-Fa-f]{6})\z/;
        return uc $1;
    }

    my @allowed = @{$build_options{$name}{values}};
    if (!defined($value) || ref($value) || !grep { $value eq $_ } @allowed) {
        die "$location: expected " . join(' or ', @allowed) . "\n";
    }
    return $value;
}

sub read_yaml_options {
    my ($mapping, $location, @supported) = @_;
    die "$location: expected a mapping\n" unless ref($mapping) eq 'HASH';

    my %values;
    for my $name (sort keys %$mapping) {
        my $field = "$location.$name";
        die "$field: unknown option\n" unless exists $build_options{$name};
        die "$field: option is unsupported for this source\n"
            unless grep { $name eq $_ } @supported;

        my $value = $mapping->{$name};
        if ($name eq 'show_finger_numbers') {
            die "$field: expected a YAML boolean (true or false)\n"
                unless JSON::PP::is_bool($value);
            $value = $value ? 'true' : 'false';
        }
        $values{$name} = validate_build_value($name, $value, $field);
    }
    return \%values;
}

sub read_build_config {
    my $file = 'build.yaml';
    my $config = { defaults => {}, documents => {} };
    return $config unless -e $file || -l $file;

    eval { require YAML::PP; YAML::PP->VERSION(0.027); 1 }
        or die "$file: install YAML::PP 0.027 or newer for the Perl used by latexmk.\n$@";
    my $parser = YAML::PP->new(
        schema => ['Core'],
        boolean => 'JSON::PP',
        duplicate_keys => 0,
        cyclic_refs => 'fatal',
    );
    my @yaml_documents = eval { $parser->load_file($file) };
    die "$file: $@" if $@;
    die "$file: expected a single YAML mapping with defaults and/or documents\n"
        unless @yaml_documents == 1 && ref($yaml_documents[0]) eq 'HASH';
    my $settings = $yaml_documents[0];

    for my $section (sort keys %$settings) {
        die "$file: unknown top-level key '$section'\n" unless exists $config->{$section};
    }
    if (exists $settings->{defaults}) {
        $config->{defaults} =
            read_yaml_options($settings->{defaults}, "$file: defaults", keys %build_options);
    }
    if (exists $settings->{documents}) {
        my $overrides = $settings->{documents};
        die "$file: documents: expected a mapping\n" unless ref($overrides) eq 'HASH';
        my %registered = map { $_->[0] => $_ } @documents;
        for my $source (sort keys %$overrides) {
            my $location = "$file: documents.$source";
            die "$location: unknown TeX source (see the document registry in latexmkrc)\n"
                unless exists $registered{$source};
            $config->{documents}{$source} =
                read_yaml_options($overrides->{$source}, $location,
                    supported_build_options($registered{$source}));
        }
    }
    return $config;
}

sub resolve_pdf {
    my ($document, $config, $overrides) = @_;
    my ($source) = @$document;
    my @supported = supported_build_options($document);
    my $per_source = $config->{documents}{$source} // {};
    my %values = map {
        $_ => $overrides->{$_} // $per_source->{$_} // $config->{defaults}{$_}
            // $build_options{$_}{values}[0]
    } @supported;

    my $suffix = $values{language};
    $suffix .= '-dots' if ($values{show_finger_numbers} // 'true') eq 'false';
    $suffix .= '-octaves' if ($values{fretboard_labels} // 'notes') eq 'octaves';
    my $pretex = join '', map { sprintf '\def\%s{%s}', $build_options{$_}{macro}, $values{$_} }
        @supported;
    return {
        document => $document,
        stem => $source =~ s/\.tex\z/.$suffix/r,
        suffix => $suffix,
        pretex => $pretex,
    };
}

sub write_build_file {
    my ($path, $contents) = @_;
    if (open my $existing, '<:raw', $path) {
        local $/;
        my $previous = <$existing>;
        return $path if defined $previous && $previous eq $contents;
    }

    my $directory = File::Basename::dirname($path);
    File::Path::make_path($directory);
    my ($output, $temporary) = File::Temp::tempfile(DIR => $directory, UNLINK => 1);
    binmode $output, ':raw' or die "Cannot set binary mode for $temporary: $!\n";
    print {$output} $contents or die "Cannot write $temporary: $!\n";
    close $output or die "Cannot close $temporary: $!\n";
    rename $temporary, $path or die "Cannot publish $path: $!\n";
    return $path;
}

sub write_book_source {
    my ($language, @plan) = @_;
    my $title_index = $language eq 'en' ? 2 : 3;
    my $sections = join '', map {
        my $anchor = $_->{document}[1];
        my $title = $_->{document}[$title_index];
        "\\BookDocument{$_->{stem}}{$anchor}{$title}%\n";
    } @plan;
    my $contents = "\\def\\ChartLanguage{$language}\n"
        . "\\def\\BookDocuments{%\n$sections}\n"
        . "\\input{../book/music-reference.tex}\n";
    return write_build_file("build/music-reference.$language.tex", $contents);
}

sub run_latexmk {
    my ($source, @options) = @_;
    # Reuse the same Perl and latexmk script, including on TeX Live for Windows.
    my $status = system { $^X } $^X, $0, @options, $source;
    die "Cannot start latexmk for $source: $!\n" if $status == -1;
    die "latexmk failed for $source\n" if $status != 0;
}

sub build_pdfs {
    my ($target, %arguments) = @_;
    my $config = read_build_config();
    my %cli;
    for my $name (sort keys %arguments) {
        my $value = $arguments{$name};
        next unless defined $value && length $value;
        $cli{$name} = validate_build_value($name, $value, "Command-line $name");
    }

    my @plan;
    my $book_language;
    if ($target eq 'all') {
        my @fretboards = grep { $_->[1] eq 'fretboard' } @documents;
        for my $language (qw(en ru)) {
            push @plan, map {
                resolve_pdf($_, $config, { %cli, language => $language, fretboard_labels => 'notes' })
            } @documents;
            push @plan, map {
                resolve_pdf($_, $config, { %cli, language => $language, fretboard_labels => 'octaves' })
            } @fretboards;
        }
    } else {
        if ($target eq 'book') {
            $book_language = $cli{language} // $config->{defaults}{language}
                // $build_options{language}{values}[0];
            $cli{language} = $book_language;
        }
        my @selected = grep { $target eq 'documents' || $target eq 'book' || $_->[1] eq $target }
            @documents;
        die "Unknown build target '$target'\n" unless @selected;
        @plan = map { resolve_pdf($_, $config, \%cli) } @selected;
    }

    # latexmk tracks files read by TeX, but changes to -usepretex alone do not trigger a rebuild.
    my $accent_color = $config->{defaults}{accent_color} // $build_options{accent_color}{default};
    my $accent_source = write_build_file('build/accent-color.tex', "\\def\\ChartAccentHex{$accent_color}%\n");
    for my $pdf (@plan) {
        my $source = $pdf->{document}[0];
        my $accent_input = File::Spec->abs2rel($accent_source, File::Basename::dirname($source));
        $accent_input =~ tr{\\}{/};
        run_latexmk($source, "-jobname=%A.$pdf->{suffix}", "-usepretex=$pdf->{pretex}\\input{$accent_input}");
    }
    run_latexmk(write_book_source($book_language, @plan)) if defined $book_language;
    exit 0;
}

1;
