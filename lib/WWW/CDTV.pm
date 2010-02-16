package WWW::CDTV;

use warnings;
use strict;
use Carp;
use LWP::UserAgent;
use Encode;
use HTML::Entities;
use DateTime;
use WWW::CDTV::Track;

our $VERSION = "0.05";

sub new {
    my ( $class, $opt ) = @_;
    my $self =
      bless { url => $opt->{url}
          || "http://www.tbs.co.jp/cdtv/cddb/thisweek.html", }, $class;
    $self->init();
    $self;
}

sub init {
    my $self     = shift;
    my $ua       = LWP::UserAgent->new();
    my $response = $ua->get( $self->{url} );
    Carp::croak $response->status_line unless $response->is_success;
    my $content = $response->content;
    $content = decode('iso-2022-jp',$content);
    $self->{week} = $1
      if ( $content =~ m!<span class="date">(\d{4}/\d{2}/\d{2})</span>! );
    my (@match) = $content =~ m!<tr class="(?:tbg1|tbg2)">(.+?)</tr>!gs;
    my $entry_regex = <<"EOF";
.*?<th scope="row">([^/]+?)</th>.*<span class="ico_(.+?)">.*<td><a href="../songdb/song.+">(.+?)</a></td>.*<td><a href="../artistdb/.+?">(.+?)</a></td>.*
EOF
    my @tracks;
    my %move_table = ( 'new' => 'new', 'up' => 'up', 'down' => 'down', );
    for my $entry_html (@match) {
        if ( $entry_html =~ m/$entry_regex/gs ) {
            my $entry = {
                no     => $1,
                title  => decode_entities($3),
                artist => decode_entities($4),
            };
            $entry->{move} = $move_table{$2};
            $tracks[ $entry->{no} ] = WWW::CDTV::Track->new($entry);
        }else{
            Carp::croak("Failt to match regex of entries");
        }
    }
    $self->{tracks} = \@tracks;
}

sub track {
    my ( $self, $no ) = @_;
    $no = $no || 1;
    my @tracks = @{ $self->{tracks} };
    return $tracks[$no];
}

sub week {
    my $self = shift;
    return $self->{week};
}

sub datetime {
    my $self = shift;
    my $str  = $self->week;
    $str =~ m!(\d{4})/(\d{2})/(\d{2})!;
    my $dt = DateTime->new(
        year      => $1,
        month     => $2,
        day       => $3,
        time_zone => 'Asia/Tokyo',
    );
    return $dt;
}

1;

__END__

=head1 NAME

WWW::CDTV - Get a weekly music ranking from CDTV ( Japanese TV Program )

=head1 SYNOPSIS

    use WWW::CDTV;
    my $cdtv  = WWW::CDTV->new;
    my $track = $cdtv->track(1);
    print sprintf( "No.%d is %s by %s ", $track->no, $track->title,
        $track->artist );
  
=head1 DESCRIPTION

=head1 SEE ALSO

http://www.tbs.co.jp/cdtv/

=head1 AUTHOR

Yusuke Wada  C<< <yusuke@kamawada.com> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, Yusuke Wada C<< <yusuke@kamawada.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

