#!/usr/bin/perl -w
# RAT 4/27/18
# $Log: muhProxy.pl,v $
# Revision 1.3  2018/04/27 16:38:05  rat
# Changed from streaming USerAgent to save file mode.
#
# Revision 1.2  2018/04/27 16:19:59  rat
# Removed unneeded ftp part
#
# Revision 1.1  2018/04/27 16:17:44  rat
# Initial revision
#

use Net::HTTP::Methods::Patch::LogRequest;
use LWP::UserAgent;
$ua = LWP::UserAgent->new;

# Laziness Impatience Hubris - yeah, use CPAN, 50,000+ modules
# Cover all the bases (you never know which parts are https)
$ua->proxy( [ 'http', 'https' ] => 'http://proxy.usi.edu:3128/' );

my $filerequest = HTTP::Request->new( GET => 'https://www.robert3t.com/' )
  or die "Cannot access file:$!\n";
my $myfile = "ratindex.html";
print "Clobbering old $myfile! (hope that *was* ok)\n" if -e $myfile;
my $myrepsonse = $ua->simple_request( $filerequest, $myfile );
