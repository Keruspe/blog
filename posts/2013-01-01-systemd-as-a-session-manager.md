---
title: systemd as a session manager
author: Marc-Antoine Perennou
tags: gnu, linux, sysadmin, systemd, gnome
---

As we are supposed to take good resolutions for 2013, mine has been to switch from `gnome-session` to [systemd](http://www.freedesktop.org/wiki/Software/systemd)
for managing my user session. Here is how I replaced gnome-session with systemd.

## How did it come to my mind?

Since its beginning, systemd has been created for both system and session management. The default is obviously the
system manager, aka `systemd --system`, but what less people know is that you also can run `systemd --user`.

Since I've been using systemd as my init system for a while and have been quite happy with it, I often thought of trying
a migration for my session. Recently, I started playing with my mails, first with [fetchmail](http://fetchmail.berlios.de/)
and [procmail](http://www.procmail.org/), and then with [offlineimap](http://offlineimap.org/) (I'll blog about this
later). With offlineimap, I needed a way to fetch periodically my emails.

I could have installed a cron system, but I don't like installing such things to only use them for a single command.
Since systemd handles natively cron jobs with its timers, I thought back to `systemd --session`.

## One problem, three solutions, which one to take?

The first solution was to run `systemd --session` as an autostart app for my session (e.g. writing a `.desktop` file for
it and putting it in `/etc/xdg/autostart`: [http://standards.freedesktop.org/autostart-spec/autostart-spec-latest.html](http://standards.freedesktop.org/autostart-spec/autostart-spec-latest.html).

With this solution I would have ended up with a first session manager (gnome-session) launching a second one (systemd
--user), and the latter would only have been used for offlineimap… Come on! We can do better.

The second solution was to replace my X session with a new one, which would launch offlineimap on one side and
gnome-session on the other, gnome-session taking care of all gnome-related stuff. This is way better! That's the
solution I adopted for a couple a hours and tries. I was pretty happy with it, but was still not convinced by the fact
that two different software were managing my session at the same time. Here is my X session file:
[https://github.com/Keruspe/system-config/blob/master/data/systemd.desktop](https://github.com/Keruspe/system-config/blob/master/data/systemd.desktop).
It has to be placed in `/usr/share/xsessions`.

Then comes the third solution, the one I'm currently running. Since my session was now directly managed by systemd, I
decided to migrate everything launched by gnome-session to systemd services, in order to remove totally gnome-session.
I found some helpful basis [here](https://github.com/grawity/systemd-user-units/) and [there](https://github.com/sofar/user-session-units).
I took some of them, modified them to fit my needs and wrote some myself, ending up with a nearly ready system.

## Last problem, gnome-session runtime dependency

Some of the [gnome](http://www.gnome.org/) parts such as [gnome-shell](https://live.gnome.org/GnomeShell) require
gnome-session to be available at runtime, in order to synchronize a few informations across the session, such as the
presence status or whether you want notifications to be displayed or ignored. This is all done via
[DBus](http://www.freedesktop.org/wiki/Software/dbus) but gnome-session does not use a helper to do so, it does it
itself. Since we cannot get totally rid of gnome-session, I decided to create a dummy gnome session that gnome-session
would launch.

Next problem: gnome-session refuses to launch such a session… Yay! I thus patched it and [opened a bug upstream](https://bugzilla.gnome.org/show_bug.cgi?id=690866)
to allow it and provide the dummy session I created. With this patch applied locally, I could run `gnome-session --session=gnome-dummy`
in my systemd service to get a session which does not launch anything. And then I realized that it was still starting
autostart applications, which I did not want since I only wanted it for its DBus interface. Passing `-a /dev/null` as an
extra arg to gnome-session so that it looks for autostart applications nowhere instead of in `/etx/xdg/autostart` did
this last trick.

My system user units are available there: [https://github.com/Keruspe/system-config/tree/master/systemd/user](https://github.com/Keruspe/system-config/tree/master/systemd/user).
This folder corresponds to your `${HOME}/.config/systemd/user/`.
