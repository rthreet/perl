#!/usr/bin/perl -w
# RAT 7/23/19
# Add Bacucla clients to database

use DBI;

my $userid = "";
my $password = "";
my $dsn = "DBI:SQLite:dbname=vm2.db";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 })
                      or die $DBI::errstr;
print "Opened database: $database successfully\n";

# cut and paste from https://status-ksplice.oracle.com/status/
$ksplice = "ksplice.txt";

# This is all KSpliced systems
my $count3=0;
open(KSPLICE,"<$ksplice") or die "Cannot open $ksplice: $!\n";
while(my $line = <KSPLICE>){
	if ($line =~ m/^$/) {
		next;
	}
	$line =~ m/(\w+)/;	# match first word (name)
	$name3 = $1;		# grab first word (name)
	$name3 = lc($name3);	# make it lower case
        chomp($name3);		# remove any trailing \n ?
        $name3 =~ s/\.usi\.edu//;	# remove .usi.edu if added
        $name3 =~ s/\.bak//;		# remove .bak 
	$count3++;			# bump counter
	#print " --- $name3 ---\n\n";	# print (debug) to see value
	my $stmt = "UPDATE vmlist SET ksplice=\'Y\' WHERE LOWER(name) LIKE LOWER(\'" . $name3 . "\%\')\;";
	print "$count3: $stmt\n";		# print (debug) to see value
	my $rv = $dbh->do($stmt) or die $DBI::errstr;
}
close(KSPLICE);
print "Closing database after processing $count3 records.\n";
$dbh->disconnect();
