#!/usr/bin/perl
# $Log: military.pl,v $
# Revision 1.1  2015/07/20 20:40:58  rat
# Initial revision
#

my $in  = shift(@ARGV) or die "Usage: military.pl string\n";
my $len = length $in;

my %alpha = (
    1 => 'wun',
    2 => 'too',
    3 => 'tree',
    4 => 'fower',
    5 => 'fife',
    6 => 'siks',
    7 => 'seven',
    8 => 'ait',
    9 => 'niner',
    0 => 'zeero',
    A => 'alpha',
    B => 'bravo',
    C => 'charlie',
    D => 'delta',
    E => 'echo',
    F => 'foxtrot',
    G => 'golf',
    H => 'hotel',
    I => 'india',
    J => 'juliet',
    K => 'kilo',
    L => 'lima',
    M => 'mike',
    N => 'november',
    O => 'oscar',
    P => 'papa',
    Q => 'quebec',
    R => 'romeo',
    S => 'sierra',
    T => 'tango',
    U => 'uniform',
    V => 'victor',
    W => 'whiskey',
    X => 'x-ray',
    Y => 'yankee',
    Z => 'zulu'
);

my $loop = 0;
for ( $loop .. $len + 1 ) {
    my $char = uc( substr( $in, $loop, 1 ) );
    print "$alpha{$char}\n";
    $loop++;
}

