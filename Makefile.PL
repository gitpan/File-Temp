
use strict;
use warnings;

use 5.008003;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "return name and handle of a temporary file safely",
  "AUTHOR" => "Tim Jenness <tjenness\@cpan.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "File-Temp",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "File::Temp",
  "PREREQ_PM" => {
    "Fcntl" => "1.03",
    "File::Path" => "2.06",
    "File::Spec" => "0.8"
  },
  "VERSION" => "0.2301",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

$WriteMakefileArgs{INSTALLDIRS} = 'perl'
    if $] >= 5.006001 && $] <= 5.011000;

WriteMakefile(%WriteMakefileArgs);



