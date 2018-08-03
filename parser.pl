#!/usr/bin/perl
use strict;
use Net::LDAP::LDIF;
use Data::Dumper;
use utf8;
use open OUT => ':utf8';
use Text::CSV;

my $pro="0ae7404d-4891-4ea4-a2d5-620a19b32b73";
my $bas="0bde20b6-9fca-4f8c-a0e3-b8aa045c2ae0";
my $pre="734e6487-3ef9-42a4-ac32-33209365ae74";

my $file=$ARGV[0];
my @attr=qw(zimbraMailDeliveryAddress zimbraCOSId displayName zimbraMailStatus zimbraCreateTimestamp);

my $ldif = Net::LDAP::LDIF->new($file, "r", onerror => 'undef');

my $csv = Text::CSV->new ( { binary => 1, eol => "\n" } )
	or die "Cannot use CSV: ".Text::CSV->error_diag ();
my $filename = "domain.csv";
open my $fh, ">:encoding(utf8)", $filename or die "failed to create $filename: $!";

my(@heading) = ("CUENTA DE CORREO", "NOMBRE DE USUARIO", "ESTADO DE CASILLA", "TIPO CASILLA", "F. CREACION");
$csv->print($fh, \@heading);    # Array ref!

while (not $ldif->eof()){
   my $entry = $ldif->read_entry ();
   if ($entry->{attrs}{objectclass}[0] eq 'inetOrgPerson'){
      my $email = $entry->get_value('zimbraMailDeliveryAddress');
      my $name = $entry->get_value('displayName');
      my $status = $entry->get_value('zimbraMailStatus');
      my $date = $entry->get_value('zimbraCreateTimestamp');
      #20130618194644Z
      my $year = substr $date, 0, 4;
      my $month = substr($date, 4, -9);
      my $day = substr($date, 6, -7);
      my $cos = $entry->get_value('zimbraCOSId');

      if ( $cos eq $pro ){
        my @value = ("$email", "\u$name", "\u$status", "$day-$month-$year", "Profesional");
        $csv->print($fh, \@value);
        #print ($fh, "$email\t $name\t $status\t $day-$month-$year\t Profesional\t \n");
      }elsif ( $cos eq $pre ) {
        my @value = ("$email", "\u$name", "\u$status", "$day-$month-$year", "Premium");
        $csv->print($fh, \@value);
        #print "$email\t $name\t $status\t $day-$month-$year\t Premium\t \n";
      } else {
        my @value = ("$email", "\u$name", "\u$status", "$day-$month-$year", "Basica");
        $csv->print($fh, \@value);
        #print "$email\t $name\t $status\t $day-$month-$year\t Basica\t \n";
      }
   }
}

close $fh;
