package Finance::MIFIR::CONCAT;
use 5.014;
use warnings;
use strict;

use Text::Iconv;
use Date::Utility;
use YAML qw/LoadFile/;
use Exporter;
use utf8;

our $VERSION = '0.01';

=head1 NAME

Finance::MIFIR::CONCAT - provides CONCAT code generation out of client data according to MIFIR rules

=head1 SYNOPSIS

    use Finance::MIFIR::CONCAT;

    print Finance::MIFIR::CONCAT::concat({
        cc          => 'DE',
        date        => '1960-01-01',
        first_name  => 'Jack',
        last_name   => 'Daniels',
    });

    or

    use Finance::MIFIR::CONCAT /mifir_concat/
    print mifir_concat({
        cc          => 'DE',
        date        => '1960-01-01',
        first_name  => 'Jack',
        last_name   => 'Daniels',
    });

=cut

our @EXPORT_OK = qw( concat mifir_concat );

my $converter = Text::Iconv->new("UTF-8", "ASCII//TRANSLIT//IGNORE");
our $config       = LoadFile(File::ShareDir::dist_file('Finance-MIFIR-CONCAT', 'mifir.yml'));
our $romanization = LoadFile(File::ShareDir::dist_file('Finance-MIFIR-CONCAT', 'romanization.yml'));

sub concat {
    my $args = shift;
    my $cc   = $args->{cc};
    my $date = Date::Utility->new($args->{date})->date_yyyymmdd;
    $date =~ s/\-//g;
    my $first_name = process_name($args->{first_name});
    my $last_name  = process_name($args->{last_name});
    return uc($cc . $date . $first_name . $last_name);
}

sub _process_name {
    my ($str) = @_;
    $str = lc($str);
    $str =~ s/$_/$romanization->{$_}/g for keys %$romanization;
    $str =~ s/$_\s+//g for (@{$config->{titles}}, @{$config->{prefixes}});
    $str =~ s/’//g;    # our iconv does not handle this correctly, it returns empty string is we have it
    $str = $converter->convert($str);
    $str =~ s/[^a-z]//g;
    $str = substr($str . '######', 0, 5);
    return $str;
}

*mifir_concat = \&concat;

1;
