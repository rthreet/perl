#!/usr/bin/perl -w
# $Author: rat $
# $Log: MacSQL.pl,v $
# Revision 1.5  2014/06/20 16:46:12  rat
# Going to fork this for the program to write an entry to the MS SQL DB and
# keep this as is to query the table.
#
# Revision 1.4  2014/06/20 15:07:01  rat
# Eureka! This queries all entries in the MS SQL database.
#
# Revision 1.3  2014/06/20 15:03:42  rat
# Getting ready to slash a lot.
#
# Revision 1.2  2014/06/20 14:24:50  rat
# Jason reset password on dev system and now it says: Successful Connection.
# Need to clean out test code and test querying the table.
#
# Revision 1.1  2014/06/20 13:52:23  rat
# Initial revision
#

use DBI;
my $server = "usi-sqldbdev.usi.edu";
my $user   = "LogTrackSQL";
my $passwd = "Wh0Am1";

# Schema Documentation (as close as I could find):
# SqlCommand myCreateCommand = new SqlCommand("INSERT INTO lgStatus VALUES ('" + Environment.MachineName + "','1','99999','99999','" + LabName + "', '" + Building + "');", myCreateConnection);
my $dbh = DBI->connect( "DBI:Sybase:server=$server", $user, $passwd,
    { PrintError => 0 } );
my $sql = "SELECT * from dbo.lgStatus WHERE lgLabName like \'BE%\'";
my $sth = $dbh->prepare($sql)
  or die
"ERROR: Failed to prepare SQL statement.\nSQL: $sql\nERROR MESSAGE: $DBI::errstr";
$sth->execute();
while ( my @row = $sth->fetchrow_array ) {
    print "@row\n";

    # example output (compare to above schema layout)
    # BE-1035-011 0 99999 99999 BE-1035 BE
    # RL-OPAC-213 2 99999 99999 RL-OPAC RL
    # So ...
    # Field 1: Environment.MachineName = BE-1035-011
    # Field 2: Unknown single integer
    # Field 3: Five 9s ?
    # Field 4: Five 9s again ?
    # Field 5: LabName = BE-1035
    # Field 6: Building = BE
}
$dbh->disconnect;
$sth->finish;
undef $sth;    # This fixes a segfault bug with certain versions of DBD::Sybase
$dbh->disconnect;
