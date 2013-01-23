---
title: Knowing your system - Part 6 - Source-based distributions: Discovering Exherbo
author: Marc-Antoine Perennou
tags: sysadmin, knowingyoursystem, source-based, exherbo
---

## The limits of Gentoo

As I said [in part 3](http://www.imagination-land.org/posts/2012-12-10-knowing-your-system---part-3---source-based-distributions-the-gentoo-example.html)
of the [knowing your system](http://www.imagination-land.org/tags/knowingyoursystem.html) saga, I really started to dig
into my system when I used [Gentoo](http://www.gentoo.org/). I quickly spotted the limits of portage, its default
package manager [and switched to paludis](http://www.imagination-land.org/posts/2012-12-13-knowing-your-system---part-4---falling-in-love-with-paludis.html).
It really is easy to mess up your python installation, especially when you're not a python developer and you don't care
about it. Of course there are tools to help you, such as `python-updater`, but it won't be of great help if you're not
in a basic "breakage because of python update" case. Because of portage being written in python, you end up with an
unmaintainable system which is painful.

A pretty good example of this is when I tried install Gentoo on my Playstation 3. At this time, the powerpc stage was
kinda old. During the base system installation and update, you ended with the linux headers version being incompatible
with your python installation, and portage was unusable. After 3 attempts without success, I tried once starting by
installing paludis, and then doing everything with it. It worked like a charm.

Portage is not the only limitation of Gentoo. Its workflow is kinda insane. First of all, Gentoo aims to get every piece
of software packaged in a same repository, external overlays being there only for testing purpose before merging. You
end up with tons of packages being available on your machine, 95% of them won't ever interest you. You could say it's
cool to get everything available without needing internet access to retrieve them, but you'll still have to download the
source tarballs so it's pointless, it just make dependencies resolution slower.

Another problem is contribution. To contribute to Gentoo, you'll open a bug [on their bugzilla](https://bugs.gentoo.org/)
with a patch attached (I'm fine with this first step, the next ones are awful). When a developer or a proxy maintainer
sees it, he applies it locally and push it to the centralised CVS server (which you sync using rsync on client side...).
There is a HUGE lack of consistency in this process:

* As a simple contributor, you won't ever be the author of the real commit, at most you'll be mentioned in the commit message
* You don't use the same tool to pull changes in that the one developer use to push them.

## Exherbo is awesome

After having used [paludis](http://paludis.exherbo.org/) on Gentoo for one year or so, I decided to involve myself in
its community. I started to send a couple of patches for my purpose, and to help beginners to deal with it. I then heard
of another bigger project they were launching: a brand new source-based distribution, a kind of Gentoo rewritten from
scratch in a more modern, modular, clean and strict way.

While I was still using Gentoo, I started to install [exherbo](http://www.exherbo.org/) in a chroot, to give it a try.
First thing I really enjoyed was that everything is split into several repositories. If I do not have any C# application
installed, the repository containing the mono stuff won't be installed and those packages won't be available on my
system. If I finally decide to install mono, I will automatically be suggested to install the mono repository, and
running `cave resolve -x1 repository/mono` will do all the stuff for you. Everything is managed by git both on the
developer and "user" side. Being an exherbo "user" is kinda special, since every user is considered as a developer by
the community.

Contributing to exherbo is really easy and smooth, I'll explain my contribution workflow next week.

As exherbo is a "new" distribution, not every package is available, so you'll probably end up creating your own
repository to package your software. Once you get enough packages in it and you want to share it with the community, you
just have to submit it, people will review it and tell you how you can make it better. It will then be added to the list
of available repositories so that people will be guided to it when they try to install software you'll have packaged.
For example, at [Clever Cloud](http://www.clever-cloud.com/), we use [openstack](http://www.openstack.org/) for now, and
we had to package it and its dependencies. Everything is available in our repository.

One more thing: exherbo policy is to be as vanilla as possible. Every patch used in packages must contain the upstream
status of it, since they all have to be submitted. We want to maintain as few patches as possible.

[My exherbo repository](https://github.com/Keruspe/Keruspe-exhereses)

[Clever Cloud exherbo repository](https://github.com/CleverCloud/CleverCloud-exheres)
