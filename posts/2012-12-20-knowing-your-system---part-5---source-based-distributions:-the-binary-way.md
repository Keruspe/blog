---
title: Knowing your system - Part 5 - Source-based distributions: the binary way
author: Marc-Antoine Perennou
tags: gnu, unix, linux, sysadmin, knowingyoursystem, source-based, paludis
---

[We last saw](http://www.imagination-land.org/posts/2012-12-13-knowing-your-system---part-4---falling-in-love-with-paludis.html)
the [paludis](http://paludis.exherbo.org/) tool. Now, we'll take a look at how we can handle a source-based distribution
using paludis for large pools of servers.

## Source-based distributions for huge server pools

At [Clever Cloud](http://www.clever-cloud.com/), we decided to use a source-based GNU/Linux distribution called
[exherbo](http://www.exherbo.org/), which I'll blog about next week, because of its strictness and flexibility. Since we
have to manage hundreds of servers and virtual machines, it would have been a big overload in energy consumption and in
time invested if we managed it the "conventional" way. Indeed, compiling everything on the hypervisors could cause
instabilities because of the CPUs being monopolised by the compilation process, leaving no power to virtual machines.
The virtual machines would have the same problem, and for much longer, since you do not have the same power in a virtual
machine than in an hypervisor, so compilations last longer.

This is why we decided to manage everything using binary packages. Wait… What? Binary packages in a source-based
distribution? How?!

## The search is over: paludis' pbins

### Setup

Paludis comes with a very nice feature: [pbins](http://paludis.exherbo.org/overview/pbins.html).

The concept is simple:

* You create an empty repository, anywhere in your filesystem, containing an empty `packages` directory, a `profiles`
  directory containing a file named `repo_name` which contents is your binary repository name, like `mybinaries`.
* In your repository, create a `metadata` containing a `layout.conf` file, with `masters = arbor` in it.
* On your compilation node, create a configuration file for you binary repository
* On the other nodes, create a configuration file for it too. It's the same, without the lines starting with `binary_`
  and modifying the `sync` line

A sample configuration file:

    format = e
    location = /var/db/paludis/repositories/mybinaries
    sync = file:///var/db/paludis/repositories/mybinaries
    importance = 100
    binary_destination = true
    binary_distdir = /var/cache/paludis/distfiles
    binary_keywords_filter = amd64 ~amd64
    binary_uri_prefix = http://mybinaries.com/exherbo/

`location` is the place where you put your empty repository.

`sync` is the same that `location` on the compilation node, and may refer to a git repository where you'll publish your binary repository on the other nodes.

`binary_distdir` is the directory where binary tarballs will be placed. I recommend you to make it point to the same place
as where paludis downloads its distfiles, since it will be easier to maintain in further use. That's why I left the
default value here.

`binary_prefix` is the URL where the generated tarballs will be available for the other nodes. Ensure that the
/var/cache/paludis/distfiles directory is available via http at this URL.

### Usage

You're now fully ready! All you have to do is create the binary packages on your compilation node, push the updated
repository to your git server, sync it on the other boxes and you will be able to install your freshly made binary
packages without having to compile them on all of your machines.

It's pretty simple to make binary packages, all you have to do is first to generate the binaries for everything you have
installed:

    cave resolve -xc world --make binaries --make-dependencies all

It will automatically generate packages and put tarballs in your distfiles directory. If you run this after updating
your compilation box, it will only generate new binary packages for those that have changed.

Last thing you might want to know: to create a binary package for a package you do not have installed yet, just run

    cave resolve -x --make binaries --make-dependencies all <insert a package name here>

It will create packages for all the dependencies, installing it afterwards, and finish by making the package for the
software you asked.

Don't forget to push all changes on your git server!
