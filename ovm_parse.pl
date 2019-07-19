#!/usr/bin/perl
# RAT 7/19/19
# New approach to reporting on OVM
#

use 5.010;
use warnings;

# Best XML module I've ever used!
use XML::LibXML;

# This is the report OVM generates
my $ovmreport = 'OVM_Report.xml';

$count = 0;

my $dom = XML::LibXML->load_xml(location => $ovmreport) or die "Nope:$!\n";

foreach my $server ($dom->findnodes('//OvmReport/Vm')) {
    my $state = $server->findvalue('./vmRunState');
    # Report only RUNNING (exclude snapshots and STOPPED)
    if ($state =~ m/RUNNING/) {
    	say 'Name:          ', $server->findvalue('./id/name');
    	say 'CPUs:          ', $server->findvalue('./cpuCount');
    	say 'Memory:        ', $server->findvalue('./memory');
    	say 'OS Type:       ', $server->findvalue('./osType');
    	say 'Repository:    ', $server->findvalue('./repositoryId/name');
    	say 'Virtual NICs:  ', $server->findvalue('./vnics/vnic/ipAddresses');
    	#say 'Virtual Disks  ', $server->findvalue('./vmDiskMappings/vmDiskMapping/virtualDisk/size');  # This doesn't work
	$count++;
	print "---\n";
    }
}
print "Count: $count\n";
