#!/bin/env perl

use 5.010;      # Require at least Perl version 5.8
use strict;     # Must declare all variables before using them
use warnings;   # Emit helpful warnings
use autodie;
use Getopt::Long; # use GetOptions function to for CL args

my ($debug,$verbose,$help);
my ($infile,$tabout);

my $result = GetOptions(
    "infile=s"      =>  \$infile,
    "tabout"        =>  \$tabout,
    "help"          =>  \$help,
    "debug"         =>  \$debug,
);

if ($help) {
    help();
    exit(0);
}

sub help {

say <<HELP;
Script to parse *.snps file from mummer show-snps script
to tally SNPs and indels separately.

--infile    input file
--tabout    tab delimited output
--help      print this menu

HELP

}

open(my $IN,'<',$infile);

my $cnt = 0;
my ($snpcnt,$indelcnt,$lastchar) = (0,0,'');
while (<$IN>) {
    next unless (++$cnt > 4);
#    my $line = $_;
    print $_ if ($debug);
    my @fields = split /\t/, $_;
    if ($fields[1] eq '.' || $fields[2] eq '.') {
        if ($lastchar ne '.') {
            ++$indelcnt;
        }
        $lastchar = '.';
    } else {
        ++$snpcnt;
        $lastchar = $fields[1];
    } 
}

if ($tabout) {
    #print "$snpcnt\t$indelcnt\t", $snpcnt + $indelcnt, "\n";
    print "$snpcnt\t$indelcnt\t", $cnt - 4, "\n";
} else {
    say "SNPs: $snpcnt\tindels: $indelcnt";
}

