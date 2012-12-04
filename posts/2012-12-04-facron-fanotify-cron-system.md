---
title: Facron - fanotify cron system
author: Marc-Antoine Perennou
tags: facron, fanotify, cron
---

## The filesystem cron principle

At [Clever Cloud](http://www.clever-cloud.com), we often have to manage stuff based on filesystem events. In order to
react dynamically, we will sometimes have to reload some specific configurations when the config file has changed, or
we'll want to wrap some files which just appeared to grab them in the global flow.

Filesystem crons allow you to do this kind of things. What you have to do is specify the files you want to monitor with
the events you want to react to and the action you want to proceed when those events occur.

## Incron

[Incron](http://incron.aiken.cz/) is the filesystem cron we've been using so far. It's based on the
[inotify](http://en.wikipedia.org/wiki/Inotify) linux system. Inotify was the replacement to dnotify which has been
deprecated for quite a long time now. Thanks to inotify, incron watches for filesystem changes and act accordingly,
given the configuration file you provide.

Incron does not support [FUSE](http://fuse.sourceforge.net) which is used by several filesystems, since inotify doesn't
support it either.

We experienced quite a few instabilities with incron which was not as reliable as we expected, ending up with ugly bash
hacks to do the job correctly. That's why I decided we needed our own solution.

## Facron

[Facron](https://github.com/Keruspe/facron) is my vision of the filesystem cron problematic. It is based on the "new"
[fanotify](http://lwn.net/Articles/339253) [ABI](http://en.wikipedia.org/wiki/Application_binary_interface) which is
more reliable and have better performances than the now deprecated inotify one. I started to write it two days ago, it's
at a stage where it's usable. It's not yet perfect and I want to improve it a little but you already can try it.

The configuration file (/etc/facron.conf) looks like:

    /path/to/a/file FAN_MODIFY|FAN_EVENT_ON_CHILD /path/to/script fromFacron $$$$

The first element is the file or directory to watch (of course multiple lines are supported), the second one corresponds
to all fanotify events that you want to follow, and then your script or application (full path is recommended) + arguments.
"$$$$" is a special token which will be replaced by the full path of the file which has emitted the event.

The available fanotify events are:

* FAN_ACCESS
* FAN_MODIFY
* FAN_CLOSE_WRITE
* FAN_CLOSE_NOWRITE
* FAN_OPEN
* FAN_Q_OVERFLOW
* FAN_OPEN_PERM
* FAN_ACCESS_PERM
* FAN_ONDIR
* FAN_EVENT_ON_CHILD
* FAN_CLOSE
* FAN_ALL_EVENTS
* FAN_ALL_PERM_EVENTS
* FAN_ALL_OUTGOING_EVENTS

Two more special tokens will appear: "$@" which will contain the dirname of the file, and "$#" which will contain its
basename.

A systemd service file and a release tarball will be provided soon.

You can reload the configuration at any time by sending a SIGUSR1 to facron:

    kill -USR1 $(pidof facron)
