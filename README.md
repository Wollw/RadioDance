RadioDance
========
A simple internet radio frontend for mpd to play stations made
with [Perl Dancer][dancer].

Why?
----

I was sick of SSHing into my server to play music in the living room and
realized I hadn't coded anything over the weekend so figured I'd do
something new.  I played around with Node.js before but it turns out I'm
much more comfortable with Perl than Javascript.  I found Dancer to be 
a breath of fresh air and a lot of fun to use.

Usage
-----

Make sure you have [Dancer][dancer], [DBD::SQLite][dbdsqlite] and
[Template Toolkit][tt] Perl modules installed and also that you have have
mpd installed and configured.

[dancer]:http://www.perldancer.org/
[tt]:http://search.cpan.org/~abw/Template-Toolkit-2.22/lib/Template.pm
[dbdsqlite]:http://search.cpan.org/~adamk/DBD-SQLite-1.33/lib/DBD/SQLite.pm
