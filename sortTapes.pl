#!/usr/bin/perl 
# RAT 9/12/17
# Attempt to sort tapes
# $Log: sortTapes.pl,v $
# Revision 1.3  2018/07/06 16:46:30  rat
# Put a conditional in to warn of existing database and point user
# at the perldoc.
#

use DBI;

$in    = "tapes.txt";
$tapes = "tapes.db";

if ( -e $tapes ) {
    warn "$tapes exists! See perldoc sortTapes.pl\n";
}

=pod

=head1 NAME 

sortTapes.pl 

=head1 DESCRIPTION

A quick hack to sift through Bacula tape list

=head1 SYNOPSIS

In Bacula, run "list media Pool=Tape" and then cut & paste the center of the 
center of the results into a file called tapes.txt in same directory as this
program. e.g.

|      44 | BAC001L6   | Full      |       1 |  3,179,884,474,368 |      187 |    8,035,200 |       1 |    0 |         0 | LTO6      |       2 |        0 | 2018-05-05 04:09:48 | 2,663,032 |
|      45 | BAC000L6   | Full      |       1 |  2,514,228,820,992 |      146 |    8,035,200 |       1 |    0 |         0 | LTO6      |       2 |        0 | 2018-05-06 02:59:15 | 2,745,199 |
|      46 | BAC011L6   | Full      |       1 |  3,107,256,800,256 |      180 |    8,035,200 |       1 |    0 |         0 | LTO6      |       2 |        0 | 2018-05-07 12:33:54 | 2,866,078 |

Then, create a sqlite3 database called tapes.db with the following schema:

=over 4

CREATE TABLE tapelist (rowid INTEGER PRIMARY KEY AUTOINCREMENT,
volumename TEXT, volstatus TEXT, rounded_terabytes TEXT,
volfiles INTEGER, slot INTEGER, inchanger INTEGER, lastdate TEXT);

=back

Now, simply run ./sortTapes.pl to create the new tape database.

=head1 CAVEATS

If you are reading this because tapes.db exists, either delete and re-create
the tapes.txt and an empty tapes.db (with schema from above) OR simply use
the existing data (See USAGE below).

=head1 USAGE

Now you can query the tape list with SQL using "sqlite3 tapes.db".  e.g.

=over 4

sqlite> select * from tapelist where volstatus not like '%Full%' AND inchanger == 1 ORDER BY lastdate;

sqlite> select * from tapelist where volstatus not like '%Full%' AND inchanger == 1 ORDER BY lastdate;

=back

=head1 AUTHOR

Robert Threet (of course)

L<https://www.robert3t.com/>

=head1 TODO

The program needs to check for existing database and then delete and recreate
so that the user does not have to do it manually.

=cut

print "opening SQLite3 database $tapes\n"
  if -e $tapes or die "Aborted: $tapes does not exist.\n";

my $rowid    = 0;
my $userid   = "";
my $password = "";
my $database = "tapes.db";
my $dsn      = "DBI:SQLite:dbname=$database";
my $sqlitedb = DBI->connect( $dsn, $userid, $password, { RaiseError => 1 } )
  or die $DBI::errstr;
print "Opened tapelist database successfully\n";

open( IN, "<$in" ) or die "Cannot open $in: $!\n";
while (<IN>) {

#      202 | BAC082L6   | Full      |       1 |  7,923,104,243,712 |      464 |   31,536,000 |       1 |    0 |         0 | LTO6      | 2017-09-11 05:50:23 |
    (
        $null,    $mediaid,  $volumename, $volstatus,
        $enabled, $volbytes, $volfiles,   $volretention,
        $recycle, $slot,     $inchanger,  $mediatype,
        $lastwritten
    ) = split(/\|/);
    $rowid++;
    $volumename  =~ s/^\s+|\s+$//g;
    $volstatus   =~ s/^\s+|\s+$//g;
    $volbytes    =~ s/^\s+|\s+$//g;
    $volfiles    =~ s/^\s+|\s+$//g;
    $slot        =~ s/^\s+|\s+$//g;
    $inchanger   =~ s/^\s+|\s+$//g;
    $lastwritten =~ s/^\s+|\s+$//g;
    $volbytes    =~ s/\,//g;
    $terabytes         = $volbytes / 1024000000000;
    $rounded_terabytes = sprintf "%.2f", $terabytes;
    ( $date, $time ) = split( /\s/, $lastwritten );

# (testing)print "$volumename,$volstatus,$rounded_terabytes TB,$volfiles,$slot,$inchanger,$date\n";
    my $statement =
qq(INSERT INTO tapelist (rowid,volumename,volstatus,rounded_terabytes,volfiles,slot,inchanger,lastdate) VALUES (\'$rowid\',\'$volumename'\,\'$volstatus\',\'$rounded_terabytes\',\'$volfiles\',\'$slot\',\'$inchanger\',\'$date\')\;);
    my $updatetape = $sqlitedb->prepare($statement);
    $updatetape->execute();
}

