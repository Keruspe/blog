---
title: Knowing your system - Part 2 - The init process
author: Marc-Antoine Perennou
tags: gnu, unix, linux, sysadmin, knowingyoursystem
---

[As we last saw](http://www.imagination-land.org/posts/2012-11-22-knowing-your-system-part-basics-on-unixlike-systems.html),
when we start an UNIX-like system, the kernel gives the hand to a main process called "init". We'll now see how it
works.

## The goal of the init process

The init process is the most important software running on your system. Its goal is to start everything up in order
for your system to work properly. It will manage everything, report errors (and maybe act regarding them) and
supervise everything. When a process gets orphaned (because its father process, the one which started it, exits or
dies), init will automatically become its father process.

The init process allows you to get a trace of what your processes are doing, where they do come from, and whether they're
in a decent or zombie state.

## The legacy System V init

UNIX System V is probably the most known UNIX system. It was one of the most used operating systems in the 80s-90s for
servers. Its init system is the base of most of our actual systems' ones.

[SysVInit](http://savannah.nongnu.org/projects/sysvinit) design splits the boot process into several steps (usually 6
or 7 for recent versions) called "runlevels":

* the runlevel 0 corresponds to the system shutdown
* the runlevel 1 corresponds to the "single user" mode, it's the step when the system's basic components are started
* the runlevel 2 corresponds to the "multi user" mode, all things that do not require networking are started there
* the runlevel 3 corresponds to the "multi user with network" mode, all things requiring networking are started there
* the runlevel 4 is usually unused, you can use it for specific custom purpose
* the runlevel 5 usually starts the graphical user interface, but a lot of distributions already does it in runlevel 3
* the runlevel 6 is used to reboot the system

Services that need to be started when you start the system must provide what is called an "init script" which will
tell SysVInit how to start the said service. This is usually a bash script which takes as argument either start, stop or
restart. If none is provided by upstream, you still can write your own one.
You then assign these services to some runlevels, and they will be started in a random order when SysVInit will reach
this runlevel. Usually they are started in alphabetical order so you can specify the order you want by prefixing the
init scripts with a numerical value such as "03" or "99" so start in n early or late stage of this runlevel.
Everything is done one after another, each task waits for the previous one to finish before starting.

In /etc/inittab, you specify which runlevel you want to reach by default at startup, so you can tell it to stop at
runlevel 3 for example. You will be able later to run "init 5" to start everything for example. You also can run "init
6" which is equivalent to "reboot" or "init 0" which is equivalent to "shutdown now"

## The new generation init systems

Here are four examples of alternatives to SysVInit. There are other but these are the most used.

### OpenRC

[OpenRC](http://www.gentoo.org/proj/en/base/openrc/) is [Gentoo](http://www.gentoo.org/)'s init process. It is not a
standalone one as it relies on SysVInit, it's only there to add handy features and performance to SysVInit.

OpenRC allows you to explicitly specify dependencies between services, which makes the task a lot easier than having to
prepend numbers to services names. It also adds the ability to get configuration files separated from init scripts.

### Runit

[Runit](http://smarden.org/runit/) is a replacement to SysVInit that also handles runlevels. It is not compatible with
the legacy ones, though. Runit splits the init process into three runlevels named "stages":

* the stage 1 corresponds to the system initialization. If anything goes wrong here, runit drops you to a rescue shell.
* the stage 2 corresponds to everything that needs to be started (like SysVInit's runlevel 5)
* the stage 3 corresponds to shutdown tasks.

Runit can read and handle SysVInit runlevels through an external compatibility layer called runsvdir but this is not how
it is intended to be run.

Runit's goal is to be as small and light as possible, it does exactly what you ask it to, and nothing more. You end up
with a system as small as possible, but you do not have to forget anything since it won't automatically do it for you.

### Upstart

[Upstart](http://upstart.ubuntu.com/) is an [Ubuntu](http://www.ubuntu.com/) attempt to make the system boot faster.
It is fully event-driven and hence only waits for stuff that needs to be waited for when it starts every process needed
by the system. It allows to start all these processes in parallel making them wait for dependencies only once they need
them. When a process fails or crashes, Upstart can handle this event to restart it automatically.

Upstart is fully compatible with SysVInit and the transition should be smooth and quite easy. Some software may need
specific init scripts though, especially to take advantage of upstart features.

### systemd

[systemd](http://www.freedesktop.org/wiki/Software/systemd) (yes, no caps here) is [Red Hat](http://www.redhat.com/)'s
attempt to make the boot faster, especially for its desktop distribution: [Fedora](http://fedoraproject.org/).
systemd is widely inspired from Upstart, the Upstart's TODO list, and from Apple's Mac OS X init system: launchd.

systemd is as lazy as possible. It does not handle "runlevels" but rather "targets". Everything handled by systemd is
called a "unit". A unit can either be a "target" (runlevel equivalent) or a "service" (the software itself), a "socket",
a "mount" operation, an "automount" operation or even a "timer" (cron-like) which will run your service in a regular
fashion.

Some targets are provided by default but you can create your owns as you wish, with the names you want. You can
specify which target has to be reached by default at system startup. In each unit, you can specify before or after which
unit it should be started, whether it requires or is required by other units, if it conflicts with other units, and to
which target it belongs. This allows systemd to know which targets and services it should start before starting the
specified default target. To each target corresponds a target.wants directory, where the unit which should be started
with this target are symbolic-linked. The sockets and mount operations are kinda more specific. Mount and automount
operations are auto-generated from /etc/fstab (auto-mounting means that the filesystem appears to be mounted, but it
really is mounted only once it has been accessed, which leads to a consequent gain of time). If a socket unit
corresponds to a service one, systemd supports the socket activation of this service, which means that the service will
really be started only when another service starts to communicate with it.

systemd is a real source of conflict between people against it and people in favor of it. The main argument of people
which are against it is that it does too many things, it's too complex and ships too many functionalities. I think this
is a fake problem, since most of the functionalities are optional (and thus can be disabled), and everything is split
into several binaries (systemd doesn't do all this stuff itself but calls tools that it ships to do so). It is fully
modular, and not modular like its "opponents".

One of the interesting tools provided by systemd is the "journal". The journal is basically a logging utility directly
integrated in the init process (well, it actually only communicates with it, it's not _really_ in it). This allows you
to get rid of an external logging utility such as syslog-ng or rsyslog. You can browse all the logs with the
"journalctl" command which allows you to apply a lot of filters on them.

A really interesting serie of blog posts by Lennart Poettering (systemd's lead developer) is available
[here](http://www.freedesktop.org/wiki/Software/systemd).
