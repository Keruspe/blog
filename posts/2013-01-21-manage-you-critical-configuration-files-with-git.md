---
title: Manage you critical configuration files with git
author: Marc-Antoine Perennou
tags: sysadmin, git
---

A few months ago, I decided to track my configuration files using git, which I use for pretty much everything now.

The problem I had to face is that some of them contain passwords, so I couldn't let them as is.

## Setting up the test environment

    keruspe@Lou ~/tmp % mkdir test.git && cd test.git && git init --bare && cd ..
    Initialized empty Git repository in /home/keruspe/tmp/test.git/
    keruspe@Lou ~/tmp % mkdir test && cd test && git init
    Initialized empty Git repository in /home/keruspe/tmp/test/.git/
    keruspe@Lou ~/tmp/test (git)-[master] % git remote add origin ../test.git 

Ok, we now have a remote repository in `~/tmp/test.git` and a working directory in `~/tmp/test`

## Configuring the working directory to be "password-safe"

    keruspe@Lou ~/tmp/test (git)-[master] % git config filter.password.clean "sed -e 's/mypassword/@PASSWORD@/' -e 's/anotherpassword/@PASSWORD2@/'"
    keruspe@Lou ~/tmp/test (git)-[master] % git config filter.password.smuge "sed -e 's/@PASSWORD@/mypassword/' -e 's/@PASSWORD2@/anotherpassword/'"
    keruspe@Lou ~/tmp/test (git)-[master] % cat > .git/info/attributes << EOF
    myconf.conf filter=password
    EOF

Ok, what's going on there?

I'm creating a filter which I call "password". A filter consist of two functions:
    * clean is called on each file when you're committing, before creating the git objects corresponding to your commit.
    * smudge is called when you checkout, each time git is recreating your working directory from the git objects.

You can note that this is not an in-place edition with sed, since I did not add the `-i` argument, these commands are
called during a piping process, not directly on files.

I then create a `.git/info/attributes` file, in which I tell git to use my brand new "filter" password for the file
`myconf.conf`. You can use any pattern that git understands here, and can obviously add multiple lines.

## Example

Let's now create the `myconf.conf` file we mentioned earlier, let's push it to the remote repository, and clone it from
anywhere else, to see the result.

    keruspe@Lou ~/tmp/test (git)-[master] % cat > myconf.conf << EOF
    user = johndoe
    password = mypassword
    bddurl = root:anotherpassword@mysql.local
    EOF
    keruspe@Lou ~/tmp/test (git)-[master] % git add myconf.conf && git commit -m "initial config" && git push origin master
    [master (root-commit) 46153a1] initial config
     1 file changed, 3 insertions(+)
     create mode 100644 myconf.conf
    Counting objects: 3, done.
    Delta compression using up to 8 threads.
    Compressing objects: 100% (2/2), done.
    Writing objects: 100% (3/3), 283 bytes, done.
    Total 3 (delta 0), reused 0 (delta 0)
    To ../test.git
     * [new branch]      master -> master
    keruspe@Lou ~/tmp/test (git)-[master] % cd ..
    keruspe@Lou ~/tmp % git clone test.git test2
    Cloning into 'test2'...
    done.
    keruspe@Lou ~/tmp % cat test/myconf.conf
    user = johndoe
    password = mypassword
    bddurl = root:anotherpassword@mysql.local
    keruspe@Lou ~/tmp % cat test2/myconf.conf
    user = johndoe
    password = @PASSWORD@
    bddurl = root:@PASSWORD2@@mysql.local

As you can see, in my `~/tmp/test` working directory, where I have my filter set up, nothing has changed at all, whereas
in the brand new clone `~/tmp/test2` (and thus, in the server), all my passwords are masked and are not accessible. This way, you can
track your configuration files using git and sharing it with other without even thinking of your passwords, as long as
everything is in your filter.
