---
title: Knowing your system - Part 8 - On the road to upstream
author: Marc-Antoine Perennou
tags: gnu, unix, linux, sysadmin, knowingyoursystem, source-based, exherbo, paludis, gnome
---

## How did I start contributing?

When I started to really dig into my system to fully understand how it works, breaking everything to know of to fix it,
I decided to do even worse and started using [scm](http://en.wikipedia.org/wiki/Source_Control_Management) packages. Scm
packages download the source code directly for the upstream development repository using [git](http://git-scm.com/),
[subversion](http://subversion.tigris.org/), [mercurial](http://mercurial.selenic.com/) or whatever other
[vcs](http://en.wikipedia.org/wiki/Revision_control).

Doing this I ended up with a more-that-bleeding-edge system, causing a lot of breakages when stuff went incompatible
with recent versions of other. That's perfect, since that's exactly the state I wanted to reach. If I wanted to recover
a functional system, the easy solution that I adopted when I did not have much spare time was to revert my last changes
and get back to an earlier version of the guilty package, but this was not the goal of the operation. What I really
started to do at this point was to patch the broken stuff to make it compatible with the newer version of the guilty
stuff which broke everything. It was sometimes really trivial, sometimes way less. I mostly did this for [Gnome](http://www.gnome.org/)
projects. It's a really good experience since you have to dig in a lot of projects and documentation, making you know
better how various parts of your system work internally. Once I had everything back working, I then submitted my patches
to the developers of the projects upstream, so that it gets fixed for everyone.

Now that I have way less spare time, I no longer have such a bleeding edge system, or at least I have way less scm
packages. Sometimes I still need to patch stuff though, so I still use the same procedure.

## My work flow

My work flow for contributing to upstream is not much different to [the one I use for contributing to Exherbo](http://www.imagination-land.org/posts/2013-01-03-knowing-your-system---part-7---contributing-to-exherbo.html).
I also use an autopatch mechanism which is slightly different. My hook for automatically patch software is available
there: [https://github.com/Keruspe/paludis-config/blob/exherbo/hooks/ebuild_prepare_pre/patches.bash](https://github.com/Keruspe/paludis-config/blob/exherbo/hooks/ebuild_prepare_pre/patches.bash).
If I remember correctly it was initially written by [Ciaran McCreesh](http://ciaranm.wordpress.com/), the
[paludis](http://paludis.exherbo.org/)'s lead developer. When I want to patch something, I get a copy locally, I write
and commit my patch, I generate a patch file and move it to `/etc/paludis/autopatch/<category>/<package>/` where
&lt;category&gt; is for example "x11-dri" and &lt;package&gt; is "mesa", according to exherbo's packages name. Each time
I install a package, it applies all this patches before configuring and compiling the software. If it works, I submit it
upstream, if not, I fix it and retry.

I highly recommend you to try contributing to open source projects, to fix or improve them, like adding new
functionalities. The only risk is to learn a lot.
