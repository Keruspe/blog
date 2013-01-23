---
title: GPaste 2.9.1 released
author: Marc-Antoine Perennou
tags: GPaste, release, clipboard, gnome
---

It's available [there](https://github.com/Keruspe/GPaste/downloads), get it while it's hot!

## What's new?

* Fix memory leak when handling images
* Fix duplicated images in history
* Fix "changed" signal in GPasteSettings

## Introduction to clipboard managers

I started to use some clipboards manager a few years ago. If you're a developer and you don't use one yet, I highly
recommend you to do so!

### What is a clipboard manager?

A clipboard manager is a tool which allows you to keep a trace of what you're copying and pasting. Is is really useful
when you go through tons of documentation and you want to keep around a bunch of functions you might want to use, for
example. The clipboard manager will store an history of everything you do, so that you can get back to older copies you
now want to paste.

If you never tried using one, download and install one and give it a try for a few days. Chances are high that you'll
immediately get addicted.

### Which one should I use?

Well, it depends on your operating system. If you're on a non UNIX-like one, I won't be of great help to find yours.
If you're running Mac OS X, a lot of friends of mine use [JumpCut](http://jumpcut.sourceforge.net/) and are really happy
with it.

If you're running a GNU/Linux system like me, here is my experience:

I tried around ten different clipboards manager. I used [parcellite](http://parcellite.sourceforge.net/) for a couple of
years, it was kinda great and lightweight. But then it got unmaintained and used some deprecated stuff. I then forked it
and made [parcellite3](https://github.com/Keruspe/parcellite3) which was parcellite ported to gtk+-3 and with many bugs
fixed. But then I was not happy at all with the way it worked internally. At this time, I was student at university and
wanted to learn [vala](https://live.gnome.org/Vala/) (which is a great language by the way) and decided to write my own
clipboard manager: [GPaste](https://github.com/Keruspe/GPaste/). GPaste aims to be a new generation parcellite.
For some reasons, I since rewrote a large part of it in C, but that will be another story in another post.

GPaste structure is really modular. It's split in a few libraries:

* libgpaste-setting to handle user settings using [dconf](https://live.gnome.org/dconf)
* libgpaste-keybinder to handle keybindings leading to actions in the daemon
* libgpaste-core is the place where the history and the items composing it are managed
* libgpaste-daemon is a set of functions to create your own GPaste daemon
* libgpaste-client is a set of function to easily create your own client application

All these libraries are written with a full [gobject-introspection](https://live.gnome.org/GObjectIntrospection)
compatibility, so you can use them from any compatible language (python, javascript, perl...). Vala bindings are also
shipped.

On top of these libraries, the components of the GPaste stack are:

* gpasted, the daemon which is available over [dbus](http://www.freedesktop.org/wiki/Software/dbus)
* gpaste, a command line tool to manage gpasted
* gpaste-settings, a graphical interface to manager GPaste settings
* gpaste-applet, the legacy applet which shows you the list of the history managed by GPaste
* gnome-shell-extensions-gpaste, a [gnome-shell](https://live.gnome.org/GnomeShell) extension similar to gpaste-applet

All development takes place on [github](https://github.com/), so feel free to contribute and to test it!

GPaste is packaged by myself for the [exherbo](http://exherbo.org/) GNU/Linux distribution and by other people for
ubuntu, fedora, debian, archlinux and frugalware, at least.
