#!/usr/bin/perl -w
# RAT 7/19/19
# New approach to reporting on OVM
# $Log: ovm_parse2.pl,v $
# Revision 1.1  2019/07/23 16:24:02  rat
# Initial revision
#

# Best XML module I've ever used!
use XML::LibXML;
use DBI;

# This is the report OVM generates
my $ovmreport = 'OVM_Report.xml';

# SQLite3 part
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

$count = 0;

my $VMs = XML::LibXML->load_xml( location => $ovmreport ) or die "Nope:$!\n";

foreach my $server ( $VMs->findnodes('//OvmReport/Vm') ) {
    my $state = $server->findvalue('./vmRunState');

    # Report only RUNNING (exclude snapshots and STOPPED)
    if ( $state =~ m/RUNNING/ ) {
        print 'UUID:       ', $server->findvalue('./id/id'),  "\n";
        my $uuid = $server->findvalue('./id/id');
        print 'Name:       ', $server->findvalue('./id/name'),  "\n";
        my $name = $server->findvalue('./id/name');
	if ($name =~ m/\.\d$/) {
		$name =~ m/(.*)\.\d/;
		$name = $1;
	}
	$name = lc($name);
        print 'CPUs:       ', $server->findvalue('./cpuCount'), "\n";
        my $cpus = $server->findvalue('./cpuCount');
        print 'Memory:     ', $server->findvalue('./memory'),   "\n";
        my $ram = $server->findvalue('./memory');
	$ram = $ram/1024;
	print "Human Readable RAM: $ram\n";
        print 'OS Type:    ', $server->findvalue('./osType'),   "\n";
        my $os = $server->findvalue('./osType');
	# future use?
        #print 'Repository: ', $server->findvalue('./repositoryId/name'), "\n";
        #$san = $server->findvalue('./repositoryId/name');
        #print 'Virtual NICs:  ',
        #  $server->findvalue('./vnics/vnic/ipAddresses'), "\n";
        my $net = $server->findvalue('./vnics/vnic/ipAddresses');
	if ($net =~ m/\d/) {
		# do nothing
		print "$net\n";
	} else {
		my $FQDN = $name . ".usi.edu";
        	$net = `/usr/bin/dig +short $FQDN`;
        	chomp($net);
		print "$net\n";
		#print "NO ADDRESS\n";
	}
	$owner = "RAT";
	print "NAME: $name\n";
        $count++;
        print "---\n";
	# incomplete stuff 
	my $cluster = "OVM";
	my $backup = "";
	my $nat = "";
	my $ksplice = "";
	my $spacewalk = "";	
	#my $state = "";
	$MAXrowid++;
	my $sql = qq(INSERT INTO vmlist (rowid,uuid,name,state,os,ram,cpus,net,cluster,owner,backup,nat,ksplice,spacewalk) VALUES ($MAXrowid,\'$uuid\',\'$name\',\'$state\',\'$os\',\'$ram\',\'$cpus\',\'$net\',\'$cluster\',\'$owner\',\'$backup\',\'$nat\',\'$ksplice\',\'$spacewalk\')\;);
        my $sth = $dbh->prepare($sql);
        $sth->execute();
    }
    $sth->finish();
}
print "Count: $count\n";

