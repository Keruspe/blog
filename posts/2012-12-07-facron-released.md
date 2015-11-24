---
title: Facron 0.9 released
author: Marc-Antoine Perennou
tags: facron, fanotify, cron, sysadmin
---

Usually, every Thursday I publish another post in [my "Knowing your system" saga](http://www.imagination-land.org/tags/knowingyoursystem.html),
but this week I was busy [working on facron](http://www.imagination-land.org/posts/2012-12-04-facron-fanotify-cron-system.html).
I plan to publish the part three on next Monday, it will be about source-based GNU/Linux distributions.

## What's in this release?

Since [last time I wrote about it](http://www.imagination-land.org/posts/2012-12-04-facron-fanotify-cron-system.html),
a few things have changed: the code is more robust and much cleaner, and several improvements have been made:

* You're now able to pass arguments containing spaces if you surround them with quotes or double quotes in the configuration
file.
* The fanotify flags handling have slightly changed with a new separator, the comma. If you specify
`FAN_MODIFY|FAN_CLOSE_WRITE,FAN_OPEN` the event caught will be: either `FAN_MODIFY` AND `FAN_CLOSE_WRITE`, or `FAN_OPEN`.
* `$@` is now the dirname of the file, `$#` the basename (`$$` is still the full path)
* A manual is now provided
* A systemd service is now provided (supporting the reload action to reload the configuration)
* You can now pass the `--background` argument to facron to launch it in background on non-systemd systems.

## How do I get it?

The release tarball is available [there: https://github.com/Keruspe/facron/downloads](https://github.com/Keruspe/facron/downloads).

You must have fanotify included in your kernel (most recent systems should have it by default).

Here are the steps you need to run in order to get it up and running:

```bash
wget https://github.com/downloads/Keruspe/facron/facron-0.9.tar.xz
tar xf facron-0.9.tar.xz
cd facron-0.9
./configure --sysconfdir=/etc --with-systemdsystemunitdir=/usr/lib/systemd/system
make
sudo make install
```

Then just create your configuration file [as I said in the previous post](http://www.imagination-land.org/posts/2012-12-04-facron-fanotify-cron-system.html)
or following the manual instructions (man facron).

When everything is ready, you just have to run

```bash
sudo systemctl start facron.service
```

Or for non-systemd systems

```bash
sudo facron --background
```

If you edit the configuration file, you can reload it without restarting the daemon by running

```bash
sudo systemctl reload facron.service
```

Or for non-systemd systems

```bash
sudo kill -USR1 $(pidof facron)
```


I hope you'll enjoy it. Feel free to propose new features and/or to contribute!

