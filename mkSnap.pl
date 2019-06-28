#!/usr/bin/perl
# Author: Robert Threet
# Snapshot. No logic for anything else. RAT 1/26/15
# $Log: mkSnap.pl,v $
# Revision 1.1  2019/06/28 16:09:10  rat
# Initial revision
#

use POSIX qw(strftime);

$UUID = "fd5cd464-33f9-708e-87ea-4de3a24d7313"; # Exchhub
$host = "exchhub";

# Capture snapshot UUID here
$log = "/var/log/snapshot.log";
open(LOG,">>$log") or die "Cannot open $log: $!\n";

# grab short day of week name
$month = strftime "%b", localtime;
# grab hour of day
$year = strftime "%Y", localtime;
# Grab time stamp for log
$logtime = strftime "%Y:%b:%e:%H:%M:%S", localtime;

$snapName = $host . $month . $year . "snap";

# -with-quiesce Quiesced snapshots take advantage of the 
# Windows Volume Shadow Copy Service (VSS) to generate 
# application consistent point-in-time snapshots. (Did not seem to work)
# my $value = qx(xe vm-snapshot-with-quiesce uuid=$UUID new-name-label=$snapName 2>&1);
my $value = qx(xe vm-snapshot uuid=$UUID new-name-label=$snapName 2>&1);

# Capture snapshot UUID stored here (/var/log/snapshot.log)
print LOG "$logtime:$snapName:$value";


