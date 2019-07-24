#!/usr/bin/perl
#Program: Parse VM list from "xe vm-list" and compare to current DB
#Author: RAT
#Date: June 12,2014 
#
=pod

=head1 NAME 

$Id: VMreconcile.pl,v 1.15 2017/07/17 14:28:54 rat Exp rat $

=head1 VERSION

$Revision: 1.15 $

=head1 DESCRIPTION

$Header: /home/rat/workspace/XenServerScripts/RCS/VMreconcile.pl,v 1.15 2017/07/17 14:28:54 rat Exp rat $

Uses Citrix XenServer's "xe vm-list" command remotely to create list of VMs on both
Orchard and SmallWorld clusters.  It then checks for new Vms and displays them.

=head1 REVISIONS

# $Log: VMreconcile.pl,v $
# Revision 1.15  2017/07/17 14:28:54  rat
# Updated schema in documentation.
#
# Revision 1.14  2017/07/17 13:38:04  rat
# Added network section.
# Added NAT section.
# Converted memory to human readable (GB).
#
# Revision 1.13  2017/07/15 16:33:41  rat
# Close: Adds 0/ip for net value instead of networks (MRO): 0/ip: 10.15.29.
#
# Revision 1.12  2017/07/15 16:11:24  rat
# Fixed Bug that clobbered $os,$ram and $cpus (added Q to end of them).
# Added RAT as owner of EVERYTHING, easier (I think) to add the other
# ownership later.
#
# Revision 1.11  2015/02/27 17:31:25  rat
# Switched exception to print simple message instead of SQL INSERT code.
# Removed some old test code and comments.
# Updated TODO since old TODO was complete and a new TODO was added.
#
# Revision 1.10  2015/01/08 22:18:57  rat
# Added a check for last record.  Added loop to add the servers that were not included already.
#
# Revision 1.9  2014/06/13 19:15:05  rat
# Fixed logic for blank line from OR to AND and ==1 instead of >0.  Sloppy!

# Revision 1.8  2014/06/13 15:55:24  rat
# Changed to look at new vm2.db.  Correctly sees revisions.

# Revision 1.7  2014/06/13 15:14:52  rat
# Using new feed with new elements: +cpus, ram and os.  Ran on first try! [squee]

# Revision 1.6  2014/06/13 14:59:18  rat
# Added some documentation and made a few cosmetic changes.

# Revision 1.5  2014/06/12 20:40:23  rat
# Added POD

# Revision 1.4  2014/06/12 20:27:02  rat
# Running getCurrentVMlist.sh from within script (so fresh VM list every time!).

# Revision 1.3  2014/06/12 19:55:57  rat
# Pretty functional.  Uses file created from getCurrentVMlist.sh (run first)
# to see if any of the VMs in either cluster are not contained in the current
# SQLite3 database.

# Revision 1.2  2014/06/12 19:17:11  rat
# Cleaned up. It was working but then broke it and didn't have a saved revision.  grr!

# Revision 1.1  2014/06/12 18:28:18  rat
# Initial revision

=cut

use DBI;

=head2 File Import

Grabbing the current VM list from XenServers.  This need to be made more Perlish.  Also, initializing variables.

=cut

# Use getCurrentVMlist.sh to get this file
# RAT 7/15/17 - I guess the early versions worked on random files.  Weird.
# RAT 7/23/19 - Back at it.  Remarking out the file capture for testing.
# my @args = ("./getCurrentWetland.sh");
# system(@args) == 0 or die "system @args failed: $?";
my $in = "Wetland.txt";
my $cluster = "Wetland";
my $found_uuid = 0;
my $found_name = 0;
my $found_state = 0;
my $found_cpus = "";
my $found_os = "";
my $found_ram = "";
my $uuidQ = "";
my $name = "";
my $nameQ = "";
my $stateQ = "";
my $state = "";
my $cpus = "";
my $cpusQ = "";
my $ram = "";
my $ramQ = "";
my $os = "";
my $osQ = "";
my $net = "";
my $netQ = "";
my $nat = "";
my $natQ = "";
my $ksplice = "";
my $spacewalk = "";
my $kspliceQ = "";
my $spacewalkQ = "";
my $owner = "Tim";
my $backup = "";

=head2 Database Access

Opening SQLite3 database vm2.db

Schema: CREATE TABLE vmlist(rowid INTEGER PRIMARY KEY AUTOINCREMENT,
uuid TEXT, name TEXT, state TEXT, os TEXT, ram INTEGER, cpus INTEGER, 
net TEXT, cluster TEXT, owner TEXT, backup TEXT, nat TEXT, ksplice TEXT, 
spacewalk TEXT);

=cut

my $userid = "";
my $password = "";
my $database = "vm2.db";
my $dsn = "DBI:SQLite:dbname=$database";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 })
                      or die $DBI::errstr;
print "Opened VM database successfully\n";
my $lastrowid = "SELECT MAX(rowid) FROM vmlist";
my $sth = $dbh->prepare($lastrowid);
$sth->execute();
my ($MAXrowid) = $sth->fetchrow();

open(IN,"<$in") or die "Cannot open $in: $!\n";

=head2 Processing

Here, the pattern is:

=over

uuid ( RO)                 : c83c7646-db66-45e9-6b60-873dfc79621f
           name-label ( RW): ADFS22
          power-state ( RO): running
    memory-static-max ( RW): 4294967296
            VCPUs-max ( RW): 2
           os-version (MRO): name: Microsoft Windows Server 2012 R2 Datacenter|C:\Windows|\Device\Harddisk0\Partition2; distro: windows; major: 6; minor: 2; spmajor: 0; spminor: 0
             networks (MRO): 
               [2 blank lines]

=back

I look for each element, set it's found flag to 1 and when I hit a blank line, check
to see if I have all three elements.

=cut 

print "Checking current VM list against database archive...\n";
while(<IN>) {
	if ($_ =~ /uuid/) {
		($uuid_label,$uuid) = split(/:/,$_);
		chomp($uuid);
		$uuid =~ s/^\s//m;
		$found_uuid = 1;
		next;
	} elsif ($_ =~ /name-label/) {
		($name_label,$name) = split(/:/,$_);
		chomp($name);
		$name =~ s/^\s//m;
		$name = lc($name);
		$found_name = 1;
		print "Name: $name\n";
		next;
	} elsif ($_ =~ /power-state/) {
		($power_label,$state) = split(/:/,$_);
		chomp($state);
		$state =~ s/^\s//m;
		$found_state = 1;
		next;
	} elsif ($_ =~ /memory-static-max/) {
		($ram_label,$ram) = split(/:/,$_);
		chomp($ram);
		$ram =~ s/^\s//m;
		$found_ram = 1;
		# convert RAM to human readable (GB)
		$ram = $ram/1048576000;
		print "RAM: $ram\n";
		next;
	} elsif ($_ =~ /VCPUs-max/) {
		($cpus_label,$cpus) = split(/:/,$_);
		chomp($cpus);
		$cpus =~ s/^\s//m;
		$found_cpus = 1;
		print "CPUs: $cpus\n";
		next;
	} elsif ($_ =~ /os-version/) {
		($os_label,$osn,$os,$junk) = split(/:/,$_);
		chomp($os);
		$os =~ s/^\s//m;
		$os =~ s/\;\suname//m;
		$os =~ s/\|C//m;
		print "OS: $os\n";
		$found_os = 1;
		next;
	} elsif ($_ =~ /networks/) {
		$_ =~ s/networks \(MRO\)\:\s//;
		$net = $_;
		$net =~ s/^\s+//m;
		#($net_label,$net) = split(/:/,$_);
		chomp($net);
		$found_net = 1;
		next;
	} elsif ($_ =~ /^$/) {
		if ($found_uuid && $found_name && $found_state && $found_cpus && $found_ram && $found_os && $found_net == 1) {
			my $FQDN = $name . ".usi.edu";
			my $nat = `/usr/bin/dig +short $FQDN`;
			chomp($nat);
			my $stmt = "SELECT \* FROM vmlist WHERE uuid = \'" . $uuid . "\'";
			my $sth = $dbh->prepare($stmt);
			$sth->execute();
			($rowid,$uuidQ,$nameQ,$stateQ,$osQ,$ramQ,$cpusQ,$netQ,$clusterQ,$ownerQ,$backup,$natQ,$kspliceQ,$spacewalkQ) = $sth->fetchrow();
		        if ($uuidQ eq "") {
				$MAXrowid++;
                		print "*** $uuid $name not found. Adding... ***\n";
				my $stmt2 = qq(INSERT INTO vmlist (rowid,uuid,name,state,os,ram,cpus,net,cluster,owner,backup,nat,ksplice,spacewalk) VALUES ($MAXrowid,\'$uuid\',\'$name\',\'$state\',\'$os\',\'$ram\',\'$cpus\',\'$net\',\'$cluster\',\'$owner\',\'$backup\',\'$nat\',\'$ksplice\',\'$spacewalk\')\;);
			my $sth = $dbh->prepare($stmt2);
			$sth->execute();
        		} 
			$sth->finish();
			$uuid = "";
			$uuidQ = "";
			$nameQ = "";
			$stateQ = "";
			$osQ = "";  	# Added all of these 7/15/17 for rev.13
			$ramQ = "";	# I don't know why this should matter
			$cpusQ = "";
			$ownerQ = "";
			$netQ = "";
			$natQ = "";
			my $kspliceQ = "";
			my $spacewalkQ = "";
			$nat = "";
			$found_uuid = 0;
			$found_name = 0;
			$found_state = 0;
			next;
		}
	}
}
print "Closing database...\n";
# It doesn't like this.  I do not know why.
#$dbh->disconnect();

=head1 BUGS

No glaring bugs I know of - just a quick hack with a lot of unvalidated data (is that bad?).

=head1 AUTHOR

RAT

=head1 TODO

A log file would be nice to know when things were added (or add that to the database - duh!)

May want to parse neetwork data and discard IPv6.

Also, need to reconcile in the other direction.  Find name changes and remove from the database servers that no longer exist.

=cut
