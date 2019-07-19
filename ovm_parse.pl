#!/usr/bin/perl -w
# RAT 7/19/19
# New approach to reporting on OVM
#

# Best XML module I've ever used!
use XML::LibXML;

# This is the report OVM generates
my $ovmreport = 'OVM_Report.xml';

$count = 0;

my $dom = XML::LibXML->load_xml( location => $ovmreport ) or die "Nope:$!\n";

foreach my $server ( $dom->findnodes('//OvmReport/Vm') ) {
    my $state = $server->findvalue('./vmRunState');

    # Report only RUNNING (exclude snapshots and STOPPED)
    if ( $state =~ m/RUNNING/ ) {
        print 'Name:       ', $server->findvalue('./id/name'),  "\n";
        print 'CPUs:       ', $server->findvalue('./cpuCount'), "\n";
        print 'Memory:     ', $server->findvalue('./memory'),   "\n";
        print 'OS Type:    ', $server->findvalue('./osType'),   "\n";
        print 'Repository: ', $server->findvalue('./repositoryId/name'), "\n";
        print 'Virtual NICs:  ',
          $server->findvalue('./vnics/vnic/ipAddresses'), "\n";
        $count++;
        print "---\n";
    }
}
print "Count: $count\n";
