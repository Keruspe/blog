---
title: Knowing your system - Part 1 - Basis on UNIX-like systems
author: Marc-Antoine Perennou
tags: gnu, unix, linux, sysadmin, knowingyoursystem
---

Before starting to blog about more technical stuff, I'd like to recall a few basis
about UNIX-like systems.

I use a GNU/Linux based distribution most of the time, so I'll speak about this kind of system,
but most of it is true for any UNIX-like system such as the BSDs and Mac OS X.

## What is GNU/Linux ?

First of all, let's make things clear: I'm talking about "GNU/Linux", not Linux.
What is the difference?
Linux is "only" a kernel, the heart of your system. Linux is the piece of your OS which
will provide you several interfaces to interact with the hardware and to manage your processes.
GNU is a set of libraries (a set of utilities for a developer) and tools such as the well known
glibc, gcc, tar and sed.
GNU is used most of the time on top of Linux, but can be used on top of other kernels, like
Debian shown us with [its GNU/kFreeBSD version](http://www.debian.org/ports/kfreebsd-gnu/).

GNU/Linux is not a full system, it's only the kernel with only a few set of core components on
top of it. This set can be _distributed_ in several different ways, with different team managing
them: the GNU/Linux distributions. The most common desktop distributions are:

* [Debian GNU/Linux](http://www.debian.org/)
* [Ubuntu GNU/Linux](http://www.ubuntu.com/) (Which is Debian-based)
* [Fedora GNU/Linux](http://fedoraproject.org/)

## It's better with colors

These distributions provide the GNU/Linux set packaged with a bunch of other software, like a
graphical environment (aka desktop/window manager). The most common desktop managers are:

* [GNOME](http://www.gnome.org/)
* [KDE](http://www.kde.org/)
* [XFCE](http://xfce.org/)

But there is also another kind of desktop managers which become more and more popular, like:

* [xmonad](http://xmonad.org/)
* [i3](http://i3wm.org/)
* [awesome](http://awesome.naquadah.org/)

They all run on top of a graphical server which aim is to display what we ask it to: [X11](http://www.x.org/).
A new compositor (a part of a graphical server) is raising: [wayland](http://wayland.freedesktop.org/).
Wayland will allow application to be a lot more flexible and will improve performances, but it will be
lazier (applications will have to do more stuff by themselves).

The X.org server, wayland, and all related libraries and tools are part of [the freedesktop project](http://www.freedesktop.org/).
Freedesktop aims to provide a free and opensource grapical user experience to everyone.

## A GNU/Linux system structure.

On a UNIX-like system, everything is a file.
A folder is just a specific kind of file, which can contain some other files.
Each piece of harware stuff is seen as a file. You write and read this file to
interact with the real hardware.
All of these files are stored in a tree respecting the [Filesystem Hierarchy Standard](http://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard).

* / is the parent folder of everything, we call it "slash".
* /boot is the folder where everything needed by the bootloader (The menu where you select which OS to start) is stored.
* /dev contains all the files corresponding to hardware devices or core functionalities.
* /etc contains all the system-wide configuration files.
* /home contains the personal directories of the users.
* /media used to be the place where external storage devices used to be automounted (the place where we accessed their files).
* /mnt is the place where we explicitly mount external (or internal) storage devices.
* /opt is the place where we place software we install system-wide using automatic installers
* /proc contains data specific to currently running processes
* /root is the home directory of "root" (administrator)
* /tmp is the place where are stored temporary data
* /var is the place where will be stored variable content such as logs and databases content
* /run is the folder used by software to store runtime specific data
* /run/media is the replacement to the deprecated /media
* /lib is the place where are stored libraries (there also can be /lib32 and/or /lib64)
* /bin is the place where the executables are stored
* /sbin is the place where administrative executables are stored
* /usr (unix shared resources) is a legacy directory where we used to put all the binaries, libraries and data which
were not necessary to boot the system, when the main hard drive was too small to store everything. It's now becoming
the standard place in which are moved /bin, /sbin and /lib.

There is now a standard filesystem hierarchy for data stored in each user home directory, guided by freedesktop:
[The XDG base directory specification](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html).

## The GNU/Linux boot process

When you start your computer, you (usually) get to a bootloader. This bootloader asks you to select which
system you want to start. What you actually do when you select an entry is to select a couple of informations:

* A kernel (you can have several ones installed at the same time, but you only boot using one of them).
* The part of your hard drive where your system lays.
* Extra configuration for your kernel.

When your kernel has successfully initialized everything, it then gives the power to a root process, commonly
called "init", which goal is to track all the other processes that you and your system will run.
The init process will then reach a few breakpoints (which can be called runlevels, or targets). To each of these
breakpoints correspond a list of process that must be started. This is how all the root components of your system are
started in the right order. One of the last things to start is the graphical interface.
