#!/usr/bin/perl 
# prog: watcher.pl
# author: Robert Threet
# July 5 2002
# Watches the specified process ($look4) and restarts if needed.
# Suggestion: rename it to match the log file name for clarity.
# Perhaps making $look4 a command line arg would be a nice feature.

#************Change these 3 values********************************
# Replace with the process to monitor.  Be sure that's how it
# will show up in the process list.
# Example:
# $look4   = "python";

$look4 = "ns-slapd";

# Here is where you specify the restart command.
# Example:
# $restart = "/home/rat/zope/start &";

$restart = "/opt/SUNWdsee/ds6/bin/dsadm start /var/opt/SUNWdsee/dsins1";

# Point this where you want your log.  Be sure to touch the file.
# Example:
# $log     = "/home/rat/scripts/zopewatch.log";

$log = "/var/log/ldapwatch.log";

#************End of part that gets edited************************

$found = 0;    # initialize

open( INPUT, "ps -e|" ) or die "Oops, couldn't open process list, $!\n";
while (<INPUT>) {

    # sometimes the ps command puts trailing spaces
    # in front.  If so, precede the following list
    # with $junk to correct the behavior.
    ( $pid, $who, $time, $name ) = split( /\s+/, $_ );
    if ( $name =~ m/$look4/ ) {
        $found = 1;
        last;
    }
}
close(INPUT);
if ( $found == 0 ) {
    open( LOG, ">>$log" ) or warn "couldn't write log $!\n";
    print LOG "$look4 had to be restarted:\t";
    system("date >>$log");
    system($restart);
    close(LOG);
}
