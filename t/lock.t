#!perl -w
# Test O_EXLOCK

use Test::More;
use strict;
use Fcntl;

BEGIN {use_ok( "File::Temp" ); }

# see if we have O_EXLOCK
eval { &Fcntl::O_EXLOCK; };
if ($@) {
  plan skip_all => 'Do not seem to have O_EXLOCK';
} else {
  plan tests => 3;
}

# Get a tempfile with O_EXLOCK
my $fh = new File::Temp();
ok( -e "$fh", "temp file is present" );

# try to open it with a lock
my $flags = O_CREAT | O_RDWR | O_EXLOCK;

my $timeout = 5;
my $status;
eval {
   local $SIG{ALRM} = sub { die "alarm\n" }; # NB: \n required
   alarm $timeout;
   $status = sysopen(my $newfh, "$fh", $flags, 0600);
   alarm 0;
};
if ($@) {
   die unless $@ eq "alarm\n";   # propagate unexpected errors
   # timed out
}
ok( !$status, "File $fh is locked" );

# Now get a tempfile with locking disabled
$fh = new File::Temp( EXLOCK => 0 );

eval {
   local $SIG{ALRM} = sub { die "alarm\n" }; # NB: \n required
   alarm $timeout;
   $status = sysopen(my $newfh, "$fh", $flags, 0600);
   alarm 0;
};
if ($@) {
   die unless $@ eq "alarm\n";   # propagate unexpected errors
   # timed out
}
ok( $status, "File $fh is not locked");
