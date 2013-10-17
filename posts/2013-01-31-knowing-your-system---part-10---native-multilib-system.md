---
title: Knowing your system - Part 10 - Native multilib system
author: Marc-Antoine Perennou
tags: sysadmin, knowingyoursystem, systemd, source-based, exherbo
---

## Why no post last week?

Last week, we were quite busy at [Clever Cloud](http://www.clever-cloud.com/en/), since we were releasing
[an awesome offer](http://blog.clever-cloud.com/Press/2013/01/30/open-cloud-month.html) and it took us quite some time
since we migrated amongst other things from [openstack](http://www.openstack.org/) to a custom home made solution which
better fits our needs.

## The future of "Knowing your system"

Two weeks ago, with [Part 9](http://www.imagination-land.org/posts/2013-01-17-knowing-your-system---part-9---contributing-to-exherbo:-updated-and-smoother-method.html),
I actually finished my initial Roadmap for this saga of posts, so I won't continue to make 1 post per week. I'll keep
posting them on Thursdays, as I find out interesting stuff about system internals.

I recommend you reading [last Lennart's post](http://0pointer.de/blog/projects/the-biggest-myths) which explains a lot
of things about the common myths regarding systemd.

## What is multilib?

On classical systems running on machines with Intel or AMD processors (the vast majority of systems), you have the
choice between installing a 32-bits (x86) or 64-bits (x86\_64) system.

Most systems used to be 32-bits, but these last years, 64-bits systems mostly became the standard. Point is that you
cannot run 32-bits binaries from a 64-bits system (the opposite is also true). Since some clients may need it, we
switched all our applicative systems to multilib, at Clever Cloud.

Solution: On your 64-bits system, you can install 32-bits libraries in parallel of 64-bits one (the former will be in
`/usr/lib32`, the latter in `/usr/lib64`, usually). Doing so allows you to run both 64 and 32-bits binaries on your system
as long as you have the dependencies installed both for 64 and 32-bits. A good example is skype, which do not release a
proper 64-bits version, so you need to run the 32-bits one, no matter your system.

## Multilib system: the right way

Multilib is implemented in different ways depending on the distribution. Some of them like Debian or Gentoo provide huge
packages with a while set of libraries in them, and only a subset or your system is available in 32-bits. For fedora,
it's kinda better, multilib packages are installed with `<packages_name>.i386` for the 32-bits version and
`<package_name>.amd64` for the 64-bits version.

The only distribution I know of which allow you real native multilib installation is, you'll have guessed it,
[Exherbo](http://www.exherbo.org/). The tutorial to switch to a multilib system is quite simple:
<http://www.mailstation.de/wordpress/?p=118>, and once this is done, the only thing you have to do is enabling the
`multibuild_c: 32` option to all the packages that you want to be available in 32-bits too. That's it, you can get your
whole system in both 64 and 32-bits just like this, natively.

A good example of this is [Clement's article](http://blog.clement.delafargue.name/posts/2013-01-08-dwarf-fortress-and-multilib-on-exherbo.html)
telling how he switched his system to multilib in order to be able to run dwarf fortress on Exherbo.
