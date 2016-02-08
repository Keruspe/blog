---
title: creds 1 released
author: Marc-Antoine Perennou
tags: creds, clipboard, GPaste, git, release, sysadmin, security
---

## What is creds? What is a credentials mangler?

Nowadays, we tend to use more and more online services. Some of them have nice integration with third-party providers
such are [google](http://google.com) or [github](https://github.com) for authentication, but not all of them, and you
might not want to use it for some services anyway.

### What strategy should I use to manage my online credentials?

#### The easy way

There's the easy way: using the same username and password everywhere. The advantage is that it'll be easy for you to
remember.

*Don't*

Doing that is the worst idea you'll ever get in your life. The global level of security is always equal to the level of
security of the weakest link. In the tons of services where you'll use these credentials, if *one* of them has a
security breach, any attacker *will* have access to your accounts on all the services where you use the same
credentials.

#### Use more that one username, when possible

As you get more and more accounts, some services might leak your information to some advertising company, or to some
attackers who might try to use these to bruteforce other services. In order to easily identify the source of the leak, I
strongly advice that you use one username per service.

If you have a custom domain name, it can be something like `sevice1@mydomain.com`, `service2@mydomain.com` which will
work nearly everywhere.

If you don't have one and are using gmail, for example, and you address is `foobar@gmail.com`, you can use
`foobar+service1@gmail.com` and so on. Unfortunately, not all services accept `+` in the username.

#### Passwords - the (random) seed way

Now that you have some good usernamed, let's talk about passwords.

One very common way of having passwords that you can remember while using a different one for each service is to start
from a "seed". You will decide that all you password will contain some phrase/word or match some pattern, more or less
randomly. The you'll use this as a base to construct the password for each service, trying to remember a logical link
between the service and the variable part of your password.

This is far better than the previously seen "easy way", and that's actually what a lot of people will tell you to do in
order to be "secure". It actually works pretty well.

What happens now if two or three of those services leak your credentials because they're stupid and store them as plain
text? Well, if you're lucky, you'll only have to change your password for those. If you're not, some attacker might
understand which pattern you use to create your passwords, and how you create the variable part depending on the
service and you'll be screwed.

#### Passwords - the safe way

The easier way to have a *strong* and *secure* password for each service is ... not knowing it. There are several tools
capable of generating passwords, such as [pwgen](http://sourceforge.net/projects/pwgen/).

If you don't know what your password is and if even you can't remember it, there's no chance that a leaky service could
cause you any harm on the other services you use.

But then, how do you use it, if you don't know it?

That's where the credentials manager gets in. I've used [password-store](http://www.passwordstore.org/) for a long time.
It's a really handy tool that generates passwords, store them on your disk encrypted using your GPG key so that only you
can decrypt it. When you need a password you just ask `pass` to give it to you, it will be decrypted using your key and
you'll be able to use it. Once you get used to adding this extra step as part of the authentication mechanism, it
becomes really powerful.

The problem with password-store though, is that it only keeps tracks of passwords. If you use several usernames, you
might as well forget what your username was for some service. That's where creds appears. I created creds so that it
could track both your username and your passwords for all of your service. It's basically a password-store on steroids.

As a bonus, creds comes with a `pass2creds` script to ease the migration.

## Typical creds workflow

The best experience you'll get with creds is when you use it combined to [GPaste](https://github.com/Keruspe/GPaste).

Let's say I wanna register to a new service `www.foobar.com`. Let's generate a new password (imagine my email address
is me@gmail.com)!

```
keruspe@Lou ~ % creds generate www.foobar.com 24
Username: me+foobar@gmail.com
[master dc4cfe2] Add www.foobar.com
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 www.foobar.com.creds
Sucessfully added to GPaste

```

Alright, my new 24-characters password has been generated, and I don't even know what it is. GPaste only show it to me
as `[Password] www.foobar.com`. Now I can create my account, just hitting `Ctrl-V` for pasting the password and that's
it.

If later on I want to log in to this service, all I need to do is `creds www.foobar.com`. My username will then be in my
clipboard. I hit `Ctrl-V` to paste it. I now hit `Ctrl-Alt-V` to nuke it from my clipboard and replace it with the
password (which is the next item in the history thanks to the nice integration in creds), I hit `Ctrl-V` in the password
box, and I'm logged in, despite the fact that I still have no idea whatsoever of what that password could be.

## How do I get it?

creds is available [on github](https://github.com/Keruspe/creds)

Version 1 release tarball is available [here](http://www.imagination-land.org/files/creds/creds-1.tar.xz), get it while it's hot!

I hope you'll enjoy it. Feel free to propose new features and/or to contribute!

