#!/usr/bin/perl -w
# RAT 7/23/19
# Add Palindrome clients to database

use DBI;

my $userid = "";
my $password = "";
my $dsn = "DBI:SQLite:dbname=vm2.db";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 })
                      or die $DBI::errstr;
print "Opened database: $database successfully\n";

# On palindrome - run this (then move file locally):
# /usr/openv/netbackup/bin/admincmd/bpplclients -allunique >/tmp/bpplclients.txt
$clients = "bpplclients.txt";

open(BAC,"<$clients") or die "Cannot open $bacula:$!\n";
while(<BAC>) {
	if ( $_ =~ m/^Hardware/) {
		 next;
	} elsif ( $_ =~ m/\-\-\-\-/) {
		next;
	} elsif ( $_ =~ m/^$/) {
		next;
	}
	($hardware, $os, $client) = split(/\s+/);
	chomp($client);
	$client =~ s/\.usi\.edu//;
	$client =~ s/\.bak//;
	$count++;
	my $stmt = "UPDATE vmlist SET backup=\'Palindrome\' WHERE LOWER(name) LIKE LOWER(\'" . $client . "\%\')";
	print "$stmt\n";
	my $rv = $dbh->do($stmt) or die $DBI::errstr;
}
print "Closing database after updating $count records.\n";
$dbh->disconnect();
