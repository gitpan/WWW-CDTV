use Test::More tests => 5;

use WWW::CDTV;
use Encode;

my $cdtv =
  WWW::CDTV->new(
    { url => "http://www.tbs.co.jp/cdtv/cddb/countdown20080126.html" });

my $week = $cdtv->week;
is($week,"2008/01/26", "Week");

my $track = $cdtv->track(1);
is($track->no, 1 , "Track No");
is($track->title, "Purple Line", "Track Title");
is($track->artist, decode("utf-8","東方神起"), "Artist Name");
is($track->move, "new");
