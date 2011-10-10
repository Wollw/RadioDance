RadioDance
========
A simple internet radio frontend using MPlayer to play stations made
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
MPlayer installed.  There are a couple of lines in bin/app.pl that will need
to be changed if you aren't using OpenBSD as the volume is handled with what
I believe is the OpenBSD specific program 'mixerctl'.  Other than that it
should run if you just run bin/app.pl from the project root.

[dancer]:http://www.perldancer.org/
[tt]:http://search.cpan.org/~abw/Template-Toolkit-2.22/lib/Template.pm
[dbdsqlite]:http://search.cpan.org/~adamk/DBD-SQLite-1.33/lib/DBD/SQLite.pm
