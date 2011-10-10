use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'RadioDance',
    AUTHOR              => q{David Shere <david.e.shere@gmail.com>},
    VERSION_FROM        => 'lib/RadioDance.pm',
    ABSTRACT            => 'Internet Radio Frontend',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'YAML'       => 0,
        'Dancer'     => 1.3072,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'RadioDance-*' },
);
