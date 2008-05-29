use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'WWW::CDTV',
    AUTHOR        => 'Yusuke Wada <yusuke@kamawada.com>',
    VERSION_FROM  => 'lib/WWW/CDTV.pm',
    ABSTRACT_FROM => 'lib/WWW/CDTV.pm',
    PL_FILES      => {},
    PREREQ_PM     => {
        'Test::More'            => 0,
        'LWP::UserAgent'        => 0,
        'Encode'                => 0,
        'HTML::Entities'        => 0,
        'DateTime'              => 0,
        'Class::Accessor::Fast' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'WWW-CDTV-*' },
);
