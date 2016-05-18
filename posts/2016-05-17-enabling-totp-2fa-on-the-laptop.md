---
title: Enabling TOTP 2 factor authentication on the laptop
author: Marc-Antoine Perennou
tags: exherbo, security, sysadmin
---

## TOTP? 2FA? What is this all about?

Usually, when you want to authenticate yourself, you decline your identity with
either a user name or an email address, and you provide one factor of authentication,
most likely being a password, a pass phrase or a PIN code.

That's good, but that's far from good enough. 2FA (two factor authentication) brings
another factor of authentication as a requirement to authenticate yourself so that
you now need two of those.

There are three kinds of factors:

- who you are (fingerprint, etc)
- what you know (password, etc)
- what you possess (a smart pone, a USB device, etc)

The most popular 2FA method in the biggest popular web services (such as Google,
Facebook, etc) is TOTP (Time-based One Time Password). The concept is fairly simple:
you share a secret key with the service, and this secret key is used to generate
a code, which varies every 30 seconds. There are a lot of applications to manage those
but the most popular is certainly [google-authenticator](https://support.google.com/accounts/answer/1066447?hl=en).
It's simple to use: the service displays you a QR code when you enable 2FA, you flash it
with the application, and then, in order to log in, you have to type both your password
and the code displayed in the application.

## Why would I do that on my laptop

My laptop is not only my personal computer. It also contains a lot of data that is
Intellectual property of [Clever Cloud](https://www.clever-cloud.com/), the company
I work for, and some keys to access lots of servers from projects I contribute to.

As a lot of people rely on me and the integrity and security of what I manage, my
computer *needs* to be secure. My hard drive is obviously fully encrypted, but shit
always can happen with shoulder surfing, or surveillance cameras, for example.
A well organised malicious person could maybe get my password while I type it, so
the password is not enough. Time to be paranoid and put an extra security measure.

## How do I enable 2FA on my laptop?

Google doesn't only provide a nice client application, they also provide
[a PAM module](https://github.com/google/google-authenticator/tree/master/libpam),
that's what we're gonna use.

First you'll need to install that. It should be available on most of distributions
(for exherbo, the package is called `google-authenticator` in the `::keruspe` repository).

During the whole setup procedure, keeping a root shell around to fix stuff in case of an
error is highly recommended.

First, run `google-authenticator` as your user. The agent will prompt you with
several questions regarding configuration, and will print you a QR code once the
setup is finished (if you have libqrencode installed, which you will if you're using
the exherbo package) that you can flash using the application. Do the same for the
root user too.

By default, this will generate a `~/.google-authenticator` file belonging to the user.
That's not really acceptable as I don't even want my user to be able to read that
configuration (with the secret key in it). I thus created a `/etc/google-authenticator`
directory, and I moved my two files in it, using the user name as file name. I thus have
`/etc/google-authenticator/keruspe` and `/etc/google-authenticator/root`. Next important
step is to make sure the rights and ownership are right.

```
chown root:root /etc/google-authenticator/*
chmod 0400 /etc/google-authenticator/*
```

Now, our files are read-only and belong to root, which is quite safer than a file in your
home directory that even your web browser can read.

Last step: actually enable the feature and make it use those files. For that, you need to
locate the pam configuration file responsible for system authentication. On exherbo,
that is `/etc/pam.d/system-auth`. At the very beginning of that file, You just need to
add this first line (or second if you want to enter your password before the verification code):

```
auth        required    pam_google_authenticator.so user=root secret=/etc/google-authenticator/${USER}
```

With that set, each time you try to login, use sudo, unlock your computer or authorise an
admin action, you will be prompted for the TOTP code, and then for your password.
The `user=root` part in the configuration will automatically make the authentication fail if
the file in `/etc/google-authenticator` doesn't belong to root.

Now let's check that everything is working properly by logging as your user (`su - keruspe` for me)
and as root (`su -`). If everything works fine, you're done.

Voila, your computer is now more secure. The only way to bypass it is to edit the
pam configuration file, which is not possible without your decryption key if your system
is fully encrypted like mine.
