---
title: Knowing your system - Part 4 - Falling in love with paludis
author: Marc-Antoine Perennou
tags: sysadmin, knowingyoursystem, source-based, paludis
---

## Installing a source-based GNU/Linux distribution

[As we last saw](http://www.imagination-land.org/posts/2012-12-10-knowing-your-system---part-3---source-based-distributions-the-gentoo-example.html),
I'm really fond of source-based distributions. Beyond the administration and the management of an installed system, you
also have to install it in the first place. Because of the fact that you have to compile absolutely everything in your
system, it may be really scary to install one.

I formerly told you to keep in mind that your system is fully usable whilst you're upgrading it…

When you install a source-based distribution, it's not using a shiny interface and clicking repeatedly on the "next"
button. You have to use a "bootstrap" system, which can be a livecd such as the awesome [sysrescuecd](http://www.sysresccd.org/),
but you also can decide to first install a binary distribution like [Fedora](http://fedoraproject.org/) or
[Ubuntu](http://www.ubuntu.com/) (you may probably already have one, so you obviously can use it).

When you have booted your "bootstrap" system, there will be 3 steps:

* Mounting the target partition to anywhere in your filesystem, like `/mnt/newsystem`
* Unpacking the base filesystem of your distribution into that folder (these are commonly called "stages tarballs")
* Chrooting into this folder (you may have to mount several subsystems such as /dev beforehand, refer to the distribution
  documentation)

One you have chrooted, you will actually be (for the current shell) in your bare new system. However you can start to
manage and install it from a shell within your "bootstrap" system that you can hopefully use to work during the
installation. Note that you can also leave your computer do all the compilations during your idle time at night.

Here are two install guides that I recommend you to follow:

* [Gentoo install guide](http://www.gentoo.org/doc/en/handbook/handbook-x86.xml)
* [Exherbo install guide](http://www.exherbo.org/docs/install-guide.html)

## Paludis, the other package mangler

Now that you have all the minimal informations needed to understand what is a source-based GNU/Linux distribution and to
understand how it works globally, We'll give a closer look to the heart of the distribution: the package manager.

On Gentoo, the official package manager is portage, with the `emerge` command line. I used it the first weeks I tried
Gentoo, but when I really wanted to play with my system, it was too restrictive so I decided to switch. Moreover,
portage is written in python (so are a lot of core components of gentoo), and when your python installation gets broken…
Game over.

When exploring the list of available packages, I found out [paludis](http://paludis.exherbo.org/) and decided to give it
a try. Thanks to [a provided script](http://git.exherbo.org/paludis/paludis-scripts.git/tree/portage2paludis.bash), I
translated roughly my portage configuration to a paludis one (Paludis can use portage configuration but this is not
recommended). It was not perfect, but was a good start. After cleaning and updating it a little by myself ([the
documentation is really exhaustive](http://paludis.exherbo.org/)), I could start using it. The man pages
are also really complete.

You can see my current configuration here: [https://github.com/Keruspe/paludis-config](https://github.com/Keruspe/paludis-config).
A first configuration will be a lot lighter, this is a configuration that have evolved during 4 years, from Gentoo to
Exherbo.

Paludis command line `cave` is a modular tool which allow you to do a lot of things. Basically everything you would ever
want to do, and some more.

The main `cave` subcommands are:

* `cave resolve` looks for the whole dependency tree of a package, in pretend mode by default, and you then can apply
  this resolution (to install stuff) by specifying the `-x` argument
* `cave uninstall` is the pendent of `cave resolve` for uninstalling
* `cave purge` looks for unused packages (as for all commands, pretending by default, and execution with `-x`)
* `cave fix-linkage` looks for broken binaries (because of libraries updates) and suggest you to rebuild them.

A lot of other subcommands are available, and a lot of options for each of these. Amongst other things, cave allows you
to stop the installation process at a certain phase, or resume at another. This allows you to abort at compile phase to
apply custom patches, and them resume at compile phase to compile the package with your patches applied.
It also support a hooks mechanism.

We'll see some more advanced paludis features in a next post of [the knowing your system saga](http://www.imagination-land.org/tags/knowingyoursystem.html).

Last thing, The way I update my system is:

```bash
cave sync
cave resolve world -c -km -Km -Cs
```

It syncs repositories with upstream to get latest versions of the packages, and then resolve `world` which is the set
containing all the packages you have installed, with a complete dependency tree, as deep as it can, with `-c` aka
`--complete`  and reinstalling all packages for which metadata have changed because of `-km -Km` aka `--keep
if-same-metadata --keep-targets if-same-metadata`. If a failure occurs, it continues to build the rest while the
dependencies still are satisfied thanks to `-Cs` aka `--continue-on-failure if-satisfied`. I then run this last
command again with `-x` aka `--execute` to apply the available updates.

## Next chapter

[Read the continuation](http://www.imagination-land.org/posts/2012-12-20-knowing-your-system---part-5---source-based-distributions%3A-the-binary-way.html)
