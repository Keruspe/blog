---
title: Knowing your system - Part 9 - Contributing to Exherbo: Updated and smoother method
author: Marc-Antoine Perennou
tags: sysadmin, knowingyoursystem, source-based, exherbo, paludis
---

In the [part 7](http://www.imagination-land.org/posts/2013-01-03-knowing-your-system---part-7---contributing-to-exherbo.html),
I described my workflow for contributing to Exherbo. Since then I had a few remarks (from [kloeri](http://kloeri.livejournal.com/),
the [Exherbo](http://www.exherbo.org/)'s father, amongst others) on how I could improve it.

## My new workflow

What I liked about my previous workflow is that it was exactly the same for contributing to Exherbo or [to upstream](http://www.imagination-land.org/posts/2013-01-10-knowing-your-system---part-8---on-the-road-to-upstream.html).
This is why it isn't completely done. Most of it is actually still here, but in another way. What's new is `cave sync`'s
option `-s`, aka `--source` which allows you to specify multiple sync sources for a repository.
For each repository that I install, I edit its configuration file changing `sync = git://git.exherbo.org/arbor.git` to
`sync = git://git.exherbo.org/arbor.git local: git+file:///home/keruspe/Exherbo/arbor`, for example.

What I do now is:

* If I do not have a copy of the repository locally I clone it, otherwise I pull new changes from upstream
* I write my patch and commit it
* I sync the repository from my local patched clone: `cave sync -s local <repository>`
* I try my patch, compiling the related packages
* If it fails, I go back to step two to fix my patch
* If it succeeds, I upload it with `git pe -<number_of_commits> | wgetpaste -r -s poundpython` and I submit it.

For the record, the command which I run to upload my patch is a git alias, `git pe` means `git format-patch -M -C --find-copies-harder --stdout`

## What has become my previous workflow?

This does not at all look like my previous workflow, but I said I kept it around… Why?

Actually, my previous workflow comes right after that. Once I've sumitted my patch, I add it to my autopatch folder: 

```bash
mkdir -p /etc/paludis/autopatch/<repository>
curl <patch_url> > /etc/paludis.autopatch/<repository>/my.patch
```

This way, they automatically get applied when I sync back the real repository instead of my copy. If a sync fail, I
rebase my patches and resubmit them. Once the patch is pushed, I can safely remove it from my autopatch directory.

Note that this whole second step can fully be ignored for repositories you have push access to, simplifying even more
this light workflow.
