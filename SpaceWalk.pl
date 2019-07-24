#!/usr/bin/perl 
# Author: RAT
# Date: 3/22/18
# $Log: SpaceWalkSystems.pl,v $
# Revision 1.2  2018/03/22 21:19:08  rat
# Figured out that the csv->fields() the 2nd fields was getting clobbered by edits.
#
# Revision 1.1  2018/03/22 21:16:24  rat
# Initial revision
#
#

use Text::CSV;
use DBI;

my $userid = "";
my $password = "";
my $dsn = "DBI:SQLite:dbname=vm2.db";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 })
                      or die $DBI::errstr;
print "Opened database: $database successfully\n";

my $csv = Text::CSV->new({ sep_char => ',' });

$space = "/home/rat/Downloads/download.csv";
$count = 0;

open(SPACE,"<$space") or die "Cannot open $space: $!\n";
while(my $line = <SPACE>){
	chomp $line;
	if ($csv->parse($line)) {
	#name,Id,Security Errata,Bug Errata,Enhancement Errata,Outdated Packages,Last Checkin,Entitlement Level,Channel Labels
      	 	my @walks = $csv->fields();
		my $name2 = @walks[0];
		my $id = @walks[1];
		my $err2 = @walks[2];
		my $bugs = @walks[3];
		my $enhance = @walks[4];
		my $outdated = @walks[5];
		my $checkin = @walks[6];
		my $entitle = @walks[7];
		my $channel2 = @walks[8];
		$namer2 = lc($name2);	# make it lower case
        	chomp($name2);		# remove any trailing \n ?
        	$name2 =~ s/\.usi\.edu//;	# remove .usi.edu if added
        	$name2 =~ s/\.bak//;		# remove .bak 
		$count++;
		#print "$count: $name2 - $bugs\n";
		print "$bugs: $name2\n";
		my $stmt = "UPDATE vmlist SET spacewalk=\'Y\' WHERE LOWER(name) LIKE LOWER(\'" . $name2 . "\%\')\;";
		my $rv = $dbh->do($stmt) or die $DBI::errstr;
  	} else {
      		warn "Line could not be parsed: $line\n";
  	}
}
close(SPACE);
