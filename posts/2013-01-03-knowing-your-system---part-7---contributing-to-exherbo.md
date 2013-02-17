---
title: Knowing your system - Part 7 - Contributing to Exherbo
author: Marc-Antoine Perennou
tags: sysadmin, knowingyoursystem, source-based, exherbo, paludis
---

## The exherbo contribution mechanism

Basically everything regarding [exherbo](http://www.exherbo.org/) is discussed and managed via the `#exherbo` IRC
channel on `irc.freenode.org`.

Before contributing, you should first read the topic of the channel, [the zebrapig patchbot documentation](http://www.exherbo.org/docs/patchbot.html),
[the exheres for smarties tutorial](http://exherbo.org/docs/exheres-for-smarties.html) (You do not have to read the
whole thing, but always keep it around), and you can also keep [the contributing guide](http://www.exherbo.org/docs/contributing.html)
around.

## Using zebrapig

Zebrapig is exherbo's IRC patchbot. You can use three commands to interact with it:

* !pq &lt;patch\_url&gt; ::&lt;repository&gt; =&gt; Use this to submit the patch available at the given URL (use `git format-patch --stdout -M -C -C -1 | wgetpaste -r`
  to get an URL for your git commit) to the repository you specified.
* !pd &lt;pattern&gt; =&gt; Use this to mark all the patches matching the given pattern as done, useful when you want to
  resubmit an updated version of your patch.
* pl &lt;pattern&gt; =&gt; Don't ever use it in the channel, only use it in a private query with zebrapig. It will list all
  patches matching this pattern (which is optional).

A special use-case is to submit your personal repository, you'll submit it as a patch, given its git URL and specifying
::unavailable-unofficial as the repository.

Everything submitted to the bot will be reviewed by developers who'll tell you what's wrong in your patch and how you
could improve it. You're expected to be quite present in the channel if you start submitting stuff. Once your patch is
ready, it will be pushed to the repository and available to everyone.

What I love about this mechanism is that it's really simple, handy and powerful.

## My personal work flow for contributing

When I want to contribute to a repository, for a version bump or any bug fix, I proceed in 7 steps:

* If I do not have a copy of the repository locally I clone it, otherwise I pull new changes from upstream
* I write my patch and commit it
* I upload my patch with `git pe HEAD~<number_of_commits> | wgetpaste -r -s poundpython` (I'll explain this command
  later)
* I put a copy of my patch in my autopatch directory (which I'll explain after):

```bash
mkdir -p /etc/paludis/autopatch/<repository>
curl <patch_url> > /etc/paludis.autopatch/<repository>/my.patch
```

* I sync the repository so that the autopatch gets applied: `cave sync <repository>`
* I try my patch, compiling the related packages
* If everything succeeds, I submit my patch, otherwise, I get back to step 2 to fix my patch

The command which I run to upload my patch is a git alias, `git pe` means `git format-patch -M -C --find-copies-harder --stdout`
and takes as an argument the commits to publish, `HEAD~3` means 3 commits for example, I put `-s poundpython` as extra
args for `wgetpaste` since gist.github.com which is the default fails quite often for me.

The other interesting part of it is how I manage the autopatch system. I have [a paludis hook](https://github.com/Keruspe/paludis-config/blob/exherbo/hooks/sync_post/local_update.bash)
placed in `/etc/paludis/hooks/sync_post` which cause every patch located in `/etc/paludis/autopatch/<repository>/` to be
applied each time I sync the said repository.

Next time I'll explain how I contribute to upstream projects using nearly the same scheme, pointing out even more how
intuitive and integrated this process is in my every day work.
