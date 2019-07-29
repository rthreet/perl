#!/usr/bin/perl -w
# RAT 7/23/19
# As my SQL/Perl evolves (need to redo the whole thing)
# 

use DBI;


my $userid = "";
my $password = "";
my $database = "vm2.db";
if ( -e $database ) {
	# Proceed (Do nothing)
	print "$database exists\n";
} else {
	print "Creating $database\n";
	my $dsn = "DBI:SQLite:dbname=$database";
	my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 })
		or die $DBI::errstr;
	print "Opened VM database successfully\n";
	my $sql_db = <<"SQL";
CREATE TABLE IF NOT EXISTS vmlist (
rowid INTEGER PRIMARY KEY AUTOINCREMENT,
uuid TEXT, 
name TEXT, 
state TEXT, 
os TEXT, 
ram INTEGER, 
cpus INTEGER, 
net TEXT, 
cluster TEXT, 
owner TEXT, 
backup TEXT, 
nat TEXT,
ksplice TEXT,
spacewalk TEXT,
other TEXT
	);
SQL
	$dbh->do($sql_db);
	print "Created table: vmlist in $database.\n";
}

