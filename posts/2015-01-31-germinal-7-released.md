---
title: Germinal 7 released
author: Marc-Antoine Perennou
tags: germinal, terminal, sysadmin
---

## What is Germinal?

Germinal is a minimaliste terminal emulator based on vte and tmux.

It starts as a maximised borderless window which allows you to have a
"fullscreen" terminal not overriding your status bar.

The default startup command attaches a tmux session, but it's customisable through dconf.

The default startup command requires you to have a `~/.tmux.conf` file containing

```
new-session
```

This will cause tmux to automatically start a new session if you use `tmux a` and none exists.

## How do I get it?

Germinal is available [on github](https://github.com/Keruspe/Germinal)

Version 7 release tarball is available [here](http://www.imagination-land.org/files/germinal/germinal-7.tar.xz), get it while it's hot!

## What's new in this release?

- port to new vte API

I hope you'll enjoy it. Feel free to propose new features and/or to contribute!

