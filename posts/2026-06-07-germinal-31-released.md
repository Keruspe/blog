---
title: Germinal 31 released
author: Marc-Antoine Perennou
tags: germinal, terminal, sysadmin
---

## How do I get it?

Germinal is available [on github](https://github.com/Keruspe/Germinal)

Version 31 release tarball is available [here](https://www.imagination-land.org/files/germinal/germinal-31.tar.xz), get it while it's hot!

## What's new in this release?

Germinal now has a proper **About dialog** (built with libadwaita), reachable from a button at the bottom of the Preferences dialog.

Both dialogs are also easier to reach from outside the terminal. Running `germinal preferences` (or `settings`) opens the Preferences dialog and `germinal about` opens the About dialog — without spawning a terminal. If an instance is already running, it reuses its existing window instead of opening a fresh one. The same two entries are now exposed as **desktop launcher actions**, so you can right-click the Germinal icon in your application menu to jump straight to them.

This release also fixes a small colour bug: foreground and background colours are now applied even when the palette is empty. French translations have been updated too.

Full keybindings are documented [here](https://github.com/Keruspe/Germinal/blob/master/README.md).

I hope you'll enjoy it. Feel free to propose new features and/or to contribute!
